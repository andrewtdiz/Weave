local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeavePlayerValue = {
}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CLASS_METATABLE = {__index = WeavePlayerValue}
local WEAK_KEYS_METATABLE = {__mode = "k"}
local Fusion = require(script.Parent.Fusion)
local WeaveUtils = require(script.Parent.WeaveUtils)
local Trove = require(script.Parent.Trove)

local Value = Fusion.Value

function WeavePlayerValue:getFor(player: Player)
	if RunService:IsClient() then
		error("Cannot use getFor on the client. Try using get() for the value or Fusion() for the fusion value")
		return
	end
	return self._fusionValue:get()[player]
end

function WeavePlayerValue:getWeaveValue()
	return self._fusionValue
end

function WeavePlayerValue:setFor(player: Player, newValue: any, force: boolean?)
	if RunService:IsClient() then
		error("Cannot set WeavePlayerValue value on the client. Only the Server")
		return
	end

	local fusionValue = self._fusionValue:get()
	fusionValue[player] = newValue
	self._fusionValue:set(fusionValue, force)
	self:_UpdateValueToClient(player, newValue)
end

function WeavePlayerValue:_UpdateValueToClient(player: Player, newValue: any)
	self._zapEvent.Fire(player, { value = newValue })
end

function WeavePlayerValue:_UpdateOnClient(newValue: any)
	self._playerValue:set(newValue)
end

function WeavePlayerValue:_PlayerAdded(player: Player)
	if not RunService:IsServer() then return end
	local fusionValue = self._fusionValue:get()
	fusionValue[player] = self._initialValue
	self._fusionValue:set(fusionValue)
end

function WeavePlayerValue:_PlayerRemoving(player: Player)
	if not RunService:IsServer() then return end
	
	local fusionValue = self._fusionValue:get()
	fusionValue[player] = nil
	self._fusionValue:set(fusionValue)
end

function WeavePlayerValue:_SetUpValue()
	if RunService:IsServer() then
		local newInstance = WeaveUtils.GetNewInstance(self._name, self._initialValue)
		if newInstance == nil then
			error("Unsupported data type for WeaveObject")
		end
		self._parentInstance = newInstance
	end
end

local function GetZapModule()
	for _, child in game:GetService("ReplicatedStorage"):GetDescendants() do
		if RunService:IsClient() and child.Name == "ZapClient" and child:IsA("ModuleScript") then
			return child
		elseif RunService:IsServer() and child.Name == "ZapServer" and child:IsA("ModuleScript") then
			return child
		end
	end
	if RunService:IsClient() then
		error("Could not find ZapClient Module script. You sure it exists and is in ReplicatedStorage somewhere?")
	else
		error("Could not find ZapServer Module script. You sure it exists and is in ReplicatedStorage somewhere?")
	end
end

local function WeavePlayerValue<T>(valueName: string, zapEventName: string, initialValue: T?): Types.State<T>
	local parentInstance = nil
	if initialValue == nil then
		initialValue = {}
		
		if RunService:IsClient() then
			local workspaceFolder = WeaveUtils.GetWeaveFolder()
			print(`Waing for child: {valueName}`)
			parentInstance = workspaceFolder:WaitForChild(valueName, 60)

			if parentInstance == nil then
				error(`Couldn't find value instance for {valueName}`)
			end
			initialValue = WeaveUtils.GetValueFromInstance(parentInstance)
			print(`Setting initial value to: `)
			print(initialValue)
		end
	end
	
	local zapModule = require(GetZapModule())
	if not WeaveUtils.KeyExists(zapModule, zapEventName) then
		error(`{zapEventName} Event not found on zapModule. Ensure the zapModule Client and Server Implements the {zapEventName} Event`)
		return
	end
	warn(zapModule[`{zapEventName}`])
	local self = setmetatable({
		type = "State",
		kind = "Value",
		-- if we held strong references to the dependents, then they wouldn't be
		-- able to get garbage collected when they fall out of scope
		dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
		_initialValue = initialValue,
		_name = valueName,
		_parentInstance = parentInstance,
		_fusionValue = Value({}),
		_playerValue = Value(initialValue),
		_zapEvent = zapModule[`{zapEventName}`],
		_troves = {}
	}, CLASS_METATABLE)

	self:_SetUpValue()

	if RunService:IsServer() then
		for _, player in Players:GetPlayers() do 
			self:_PlayerAdded(player)
		end
		Players.PlayerAdded:Connect(function(player)
			self:_PlayerAdded(player)
		end)
		Players.PlayerRemoving:Connect(function(player)
			self:_PlayerRemoving(player)
		end)
	else
		warn(self._zapEvent)
		self._zapEvent.SetCallback(function(Data: { value: number })
			local newValue = Data.value
			self:_UpdateOnClient(newValue)
		end)
	end
	
	if RunService:IsClient() then
		return self._playerValue
	end
	return self
end


return WeavePlayerValue
