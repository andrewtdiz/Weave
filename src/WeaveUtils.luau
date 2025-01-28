local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaveUtils = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Trove = require(script.Parent.Trove)

function WeaveUtils.GetWeaveFolder()
	local weaveFolder
	if RunService:IsClient() then
		weaveFolder = game.Workspace:WaitForChild("WeaveFolder", 5)
		if weaveFolder == nil then
			error("Weave Folder not found on client")
		end
	else
		weaveFolder = game.Workspace:FindFirstChild("WeaveFolder")
		if weaveFolder == nil then
			weaveFolder = Instance.new("Folder")
			weaveFolder.Name = "WeaveFolder"
			weaveFolder.Parent = game.Workspace
		end
	end
	return weaveFolder
end

function WeaveUtils.CloneTable(table: any, deep: boolean)
	if table == nil then
		return nil
	end

	if typeof(table) ~= "table" then
		return table
	end

	local copy = {}
	for key, value in pairs(table) do
		if deep and typeof(value) == "table" then
			copy[key] = WeaveUtils.CloneTable(value, true)
		else
			copy[key] = value
		end
	end
	return copy
end

function WeaveUtils.GetPlayerDataHandler()
	local child = game:GetService("ServerStorage"):FindFirstChild("WeaveProfileHandler", true)
	
	if not child then
		error("Could not find WeaveProfileHandler ModuleScript. Make sure it is in ServerStorage.")
	end
	
	local DataHandler = require(child)
	if not WeaveUtils.MethodExists(DataHandler, "GetProfileTemplate") then
		error([[GetProfileTemplate method not found in ProfileHandler.
		    Make sure ProfileHandler module implements the GetProfileTemplate method:
		    function WeaveProfileHandler:GetProfileTemplate()
				return Profile
			end
    	]])
	end
	if not WeaveUtils.MethodExists(DataHandler, "Set") then
		error("Set method not found in ProfileHandler. Ensure the PlayerDataHandler Module script implements the Set method")
	end
	if not WeaveUtils.MethodExists(DataHandler, "GetAsync") then
		error("GetAsync method not found in ProfileHandler. Ensure the PlayerDataHandler Module script implements the GetAsync method")
	end
	return DataHandler
end

function WeaveUtils.TableType(someObject)
	if typeof(someObject) ~= "table" then
		return "NotTable"
	end
	local isList = true

	local index = 0
	for key, _ in pairs(someObject) do
		index = index + 1
		if key ~= index then
			isList = false
			break
		end
	end
	if isList then
		return "List"
	else
		return "Object"
	end
end

function WeaveUtils.MethodExists(obj, methodName)
	return type(obj[methodName]) == "function"
end

function WeaveUtils.KeyExists(obj, keyName)
	return obj[keyName] ~= nil
end

local typesDictionary = {
	["number"] = "NumberValue",
	["string"] = "StringValue",
	["boolean"] = "BoolValue",
	["Vector3"] = "Vector3Value",
	["Instance"] = "ObjectValue"
}
local supportedTypes = {}
for _, value in typesDictionary do
	supportedTypes[value] = true
end

function WeaveUtils.IsCorrectInstanceType(initialValue: any, instance: Instance)
	local valueType = typeof(initialValue)
	if valueType == "table" and instance.ClassName == "Folder" then
		return WeaveUtils.TableType(initialValue) == instance:GetAttribute("Type")
	end
	return typesDictionary[valueType] == instance.ClassName
end

function WeaveUtils.IsAPlayer(value: any)
	return typeof(value) == "Instance" and value:IsA("Player")
end

function WeaveUtils.GetNewInstance(key: any, initialValue: any)
	local newInstance
	local valueType = typeof(initialValue)
	if valueType == "table" then
		newInstance = Instance.new("Folder")
		if WeaveUtils.IsAPlayer(key) then
			newInstance:SetAttribute("isPlayerKey", true)
			newInstance.Name = `{key.UserId}`
		else
			newInstance.Name = key
		end
		newInstance.Parent = WeaveUtils.GetWeaveFolder()
		newInstance:SetAttribute("Type", WeaveUtils.TableType(initialValue))
		for newKey, newValue in pairs(initialValue) do
			local newValueInstance = WeaveUtils.GetNewInstance(newKey, newValue)
			newValueInstance.Parent = newInstance
		end
		return newInstance
	elseif typesDictionary[valueType] then
		newInstance = Instance.new(typesDictionary[valueType])
	else
		error(`Invalid instance type for {initialValue}: {valueType}`)
	end
	
	if WeaveUtils.IsAPlayer(key) then
		newInstance:SetAttribute("isPlayerKey", true)
		newInstance.Name = `{key.UserId}`
	else
		newInstance.Name = key
	end
	newInstance.Parent = WeaveUtils.GetWeaveFolder()
	newInstance.Value = initialValue
	return newInstance
end

function WeaveUtils.IsSupportedBaseInstanceType(instance: Instance)
	return supportedTypes[instance.ClassName]
end

function WeaveUtils.GetValueFromInstance(instance: Instance)

	if WeaveUtils.IsSupportedBaseInstanceType(instance) then
		return instance.Value
	end

	if instance:IsA("Folder") then
		local tableType = instance:GetAttribute("Type")
		local outTable
		if tableType == "List" then
			outTable = {}
			for _, child in ipairs(instance:GetChildren()) do
				table.insert(outTable, {})
			end
			for _, child in ipairs(instance:GetChildren()) do
				local keyName = tonumber(child.Name)
				outTable[keyName] = WeaveUtils.GetValueFromInstance(child)
			end
		elseif tableType == "Object" then
			outTable = {}
			for _, child in ipairs(instance:GetChildren()) do
				local newKey = WeaveUtils.GetKeyNameFromInstance(child)
				outTable[newKey] = WeaveUtils.GetValueFromInstance(child)
			end
		else
			error(`Table Type {tableType} is not supported for folder {instance}`)
		end
		return outTable
	end
	return nil
end

function WeaveUtils.GetKeyNameFromInstance(instance: Instance)
	if instance:GetAttribute("isPlayerKey") then
		local userId = tonumber(instance.Name)
		local player = Players:GetPlayerByUserId(userId)
		return player
	end
	return instance.Name
end

function WeaveUtils.RemoteEvent(name: string)
	local remoteEvent
	name = `RemoteEvents/{name}`
	if RunService:IsServer() then
		remoteEvent = script:FindFirstChild(name)
		if remoteEvent == nil then
			remoteEvent = Instance.new("RemoteEvent")
			remoteEvent.Name = name
			remoteEvent.Parent = script
		end
	else
		remoteEvent = script:WaitForChild(name, 10)
		if remoteEvent == nil then
			error(`Remote event not found {remoteEvent}`)
		end
	end
	return remoteEvent
end

function WeaveUtils.Connect(name: string, handler: (...any) -> ()): RBXScriptConnection
	if RunService:IsServer() then
		return WeaveUtils.RemoteEvent(name).OnServerEvent:Connect(handler)
	else
		return WeaveUtils.RemoteEvent(name).OnClientEvent:Connect(handler)
	end
end

return WeaveUtils
