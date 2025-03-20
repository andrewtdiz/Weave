local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WorkspaceValue = {}
local RunService = game:GetService("RunService")

local CLASS_METATABLE = { __index = WorkspaceValue }
local WEAK_KEYS_METATABLE = { __mode = "k" }
local Fusion = require(script.Parent.Fusion)
local WeaveUtils = require(script.Parent.WeaveUtils)
local Trove = require(script.Parent.Trove)

local FusionValue = Fusion.Value

local instanceCache = {}
local reloadCache = {}
local checkCache = false

function WorkspaceValue:get()
	return self._fusionValue:get()
end

function WorkspaceValue:getWeaveValue()
	return self._fusionValue
end

function WorkspaceValue:set(newValue: any, force: boolean?)
	assert(
		typeof(newValue) == typeof(self._fusionValue:get()),
		`Expected type {typeof(self._fusionValue:get())}, got {newValue} of type {typeof(newValue)}`
	)

	self._value = newValue
	self._fusionValue:set(self._value, force)
end

function WorkspaceValue:update(func: (t: any) -> nil, force: boolean)
	local currentValue = self:get()
	local newValue = func(currentValue)
	self:set(newValue, force)
end

function WorkspaceValue:UpdateGameWorkspace(parentInstance: Instance, valueObject)
	if typeof(valueObject) ~= "table" then
		if not WeaveUtils.IsCorrectInstanceType(valueObject, parentInstance) then
			error(`Setting incorrect value for instance type. {parentInstance}, {valueObject}`)
		end
		parentInstance.Value = valueObject
		return
	end

	if not WeaveUtils.IsCorrectInstanceType(valueObject, parentInstance) then
		parentInstance:SetAttribute("Type", WeaveUtils.TableType(valueObject))
	end

	for key, value in valueObject do
		local valueInstance
		if WeaveUtils.IsAPlayer(key) then
			valueInstance = parentInstance:FindFirstChild(`{key.UserId}`)
		else
			valueInstance = parentInstance:FindFirstChild(key)
		end

		if valueInstance == nil or not WeaveUtils.IsCorrectInstanceType(value, valueInstance) then
			if valueInstance ~= nil then
				valueInstance:Destroy()
			end
			valueInstance = WeaveUtils.GetNewInstance(key, value)
			valueInstance.Parent = parentInstance
		end
		self:UpdateGameWorkspace(valueInstance, valueObject[key])
	end

	if next(valueObject) == nil then
		for _, valueInstance in parentInstance:GetChildren() do
			valueInstance:Destroy()
		end
	else
		for _, valueInstance in parentInstance:GetChildren() do
			local tableType = WeaveUtils.TableType(valueObject)
			if tableType == "List" then
				local index = tonumber(valueInstance.Name)
				if index > #valueObject then
					valueInstance:Destroy()
				end
			elseif tableType == "Object" then
				local key = WeaveUtils.GetKeyNameFromInstance(valueInstance)
				if valueObject[key] == nil then
					valueInstance:Destroy()
				end
			end
		end
	end
end

function WorkspaceValue:_Reload()
	if RunService:IsServer() then
		return
	end
	
	if self._isTable and reloadCache[self] then return end
	reloadCache[self] = true
	checkCache = true
	
	self:set(WeaveUtils.GetValueFromInstance(self._parentInstance))
end

function WorkspaceValue:_AttachListenersToInstance(instance: Instance)
	if RunService:IsServer() then
		return
	end

	if instance:IsA("StringValue") or instance:IsA("BoolValue") or instance:IsA("NumberValue") then
		self._troves[instance] = Trove.new()
		self._troves[instance]:AttachToInstance(instance)
		self._troves[instance]:Connect(instance:GetPropertyChangedSignal("Value"), function()
			self:_Reload()
		end)
		return
	end

	for _, valueInstance in instance:GetChildren() do
		self:_AttachListenersToInstance(valueInstance)
	end
	if self._troves[instance] then
		return
	end
	local trove = Trove.new()
	trove:Connect(instance.ChildAdded, function(child)
		self:_Reload()
		self:_AttachListenersToInstance(child)
	end)
	trove:Connect(instance.ChildRemoved, function(child)
		if self._troves[child] ~= nil then
			self._troves[child]:Destroy()
			self._troves[child] = nil
		end
		self:_Reload()
	end)
	self._troves[instance] = trove
	return nil
end

function WorkspaceValue:_SetUpValue()
	local rootTrove = Trove.new()
	rootTrove:AttachToInstance(self._rootFolder)
	rootTrove:Add(function()
		self:Destroy()
		instanceCache[self._rootFolder] = nil
	end)
	instanceCache[self._rootFolder] = self
	
	if RunService:IsServer() then
		local newInstance = WeaveUtils.InitInstance("Value", self.initialValue)
		if newInstance == nil then
			error("Unsupported data type for Value")
		end
		newInstance.Parent = self._rootFolder
		self._parentInstance = newInstance
		
		self._rootFolder:SetAttribute("isLoaded", true)
		
		self.Changed = self._fusionValue.Changed
		
		rootTrove:Connect(self._fusionValue.Changed, function()
			self:UpdateGameWorkspace(self._parentInstance, self._fusionValue:get())
		end)
		rootTrove:Add(function()
			self._fusionValue:Destroy()
			for _, trove in self._troves do
				trove:Destroy()
			end
		end)
		self._troves[self._rootFolder] = rootTrove
	else
		self._parentInstance = self._rootFolder:WaitForChild("Value", 60)

		if self._parentInstance == nil then
			error(`Couldn't find value instance for {self._name}`)
		end

		self._value = WeaveUtils.GetValueFromInstance(self._parentInstance)
		self._fusionValue = FusionValue.new(self._value)
		self:_AttachListenersToInstance(self._parentInstance)
		
		rootTrove:Add(function()
			self._fusionValue:Destroy()
			for _, trove in self._troves do
				trove:Destroy()
			end
			reloadCache[self] = nil
		end)
		if self._isTable then
			reloadCache[self] = false
		end
	end
end

function WorkspaceValue:Destroy()
	if RunService:IsServer() then
		if self._rootFolder.Parent ~= nil then
			self._rootFolder:Destroy()
		end
	else
		self._fusionValue:Destroy()
	end
end

function WorkspaceValue.new<T>(folder: Folder, initialValue: T?)
	if RunService:IsServer() and initialValue == nil then
		repeat task.wait() until instanceCache[folder]
	end
	if instanceCache[folder] then
		return instanceCache[folder]
	end
	if RunService:IsClient() then
		repeat task.wait() until folder:GetAttribute("isLoaded")	
		initialValue = WeaveUtils.GetValueFromInstance(folder:WaitForChild("Value"))	
	end
	if not folder:IsDescendantOf(workspace) then 
		error(`Folder {folder} must be descendant of workspace`)	
	end
	if not folder:IsA("Folder") then
		error(`Instance {folder} must be a folder`)	
	end
	
	local self = setmetatable({
		type = "State",
		kind = "Value",
		-- if we held strong references to the dependents, then they wouldn't be
		-- able to get garbage collected when they fall out of scope
		dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
		_name = folder.Name,
		_rootFolder = folder,
		_parentInstance = nil,
		initialValue = initialValue,
		_isTable = typeof(initialValue) == "table",
		_value = initialValue,
		_fusionValue = FusionValue.new(initialValue),
		_Changed = nil,
		_troves = {},
	}, CLASS_METATABLE)

	self:_SetUpValue()
	
	if RunService:IsClient() then
		return self:getWeaveValue()
	end

	return self
end

if RunService:IsClient() then
	RunService.PreRender:Connect(function()
		if not checkCache then return end
		
		for value, _ in reloadCache do
			reloadCache[value] = false
		end
		
		checkCache = false
	end)
end

return WorkspaceValue
