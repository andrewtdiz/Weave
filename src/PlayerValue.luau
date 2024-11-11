local PlayerValue = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local CLASS_METATABLE = { __index = PlayerValue }
local WEAK_KEYS_METATABLE = { __mode = "k" }
local Fusion = require(script.Parent.Fusion)
local WeaveUtils = require(script.Parent.WeaveUtils)

local Types = require(script.Parent.Fusion.Types)

local FusionValue = Fusion.Value

function PlayerValue:getFor(player: Player)
	if RunService:IsClient() then
		error("Cannot use getFor on the client. Try using get() for the value or Fusion() for the fusion value")
		return
	end
	return self._fusionValue:get()[player]
end

function PlayerValue:getWeaveValue()
	return self._fusionValue
end

function PlayerValue:getChangedSignal()
	return self._fusionValue.Changed
end

function PlayerValue:setFor(player: Player, newValue: any, force: boolean?)
	if RunService:IsClient() then
		error("Cannot set PlayerValue value on the client. Only the Server")
		return
	end

	local fusionValue = self._fusionValue:get()
	fusionValue[player] = newValue
	self._fusionValue:set(fusionValue, force)
	self:_UpdateValueToClient(player, newValue)
end

function PlayerValue:updateFor(player: Player, cb: (a: any) -> any, force: boolean?)
	if RunService:IsClient() then
		error("Cannot set PlayerValue value on the client. Only the Server")
		return
	end

	local fusionValue = self._fusionValue:get()
	local updatedValue = cb(fusionValue[player])
	fusionValue[player] = updatedValue
	self._fusionValue:set(fusionValue, force)
	self:_UpdateValueToClient(player, updatedValue)
end

function PlayerValue:_UpdateValueToClient(player: Player, newValue: any)
	self._remoteEvent:FireClient(player, newValue)
end

function PlayerValue:_UpdateOnClient(newValue: any)
	self._playerValue:set(newValue)
end

function PlayerValue:_PlayerAdded(player: Player)
	if not RunService:IsServer() then
		return
	end

	self._fusionValue:update(function(current)
		current[player] = self._initialValue
		return current
	end)
end

function PlayerValue:_PlayerRemoving(player: Player)
	if not RunService:IsServer() then
		return
	end

	self._fusionValue:update(function(current)
		current[player] = nil
		return current
	end)
end

function PlayerValue:_SetUpValue()
	if RunService:IsServer() then
		local newInstance = WeaveUtils.GetNewInstance(self._name, self._initialValue)
		if newInstance == nil then
			error("Unsupported data type for WeaveObject")
		end
		self._parentInstance = newInstance
	end
end

function PlayerValue.new<T>(valueName: string, initialValue: T?): Types.State<T>
	local parentInstance = nil
	if initialValue == nil then
		initialValue = {}

		if RunService:IsClient() then
			local workspaceFolder = WeaveUtils.GetWeaveFolder()
			parentInstance = workspaceFolder:WaitForChild(valueName, 10)

			if parentInstance == nil then
				error(`Couldn't find value instance for {valueName}`)
			end
			initialValue = WeaveUtils.GetValueFromInstance(parentInstance)
		end
	end
	local self = setmetatable({
		type = "State",
		kind = "Value",
		-- if we held strong references to the dependents, then they wouldn't be
		-- able to get garbage collected when they fall out of scope
		dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
		_initialValue = initialValue,
		_name = valueName,
		_parentInstance = parentInstance,
		_fusionValue = FusionValue.new({}),
		_playerValue = FusionValue.new(initialValue),
		_remoteEvent = WeaveUtils.RemoteEvent(`PlayerValue/{valueName}`),
		_troves = {},
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
		self._remoteEvent.OnClientEvent:Connect(function(newValue: any)
			self:_UpdateOnClient(newValue)
		end)
	end

	if RunService:IsClient() then
		return self._playerValue
	end
	return self
end

return PlayerValue
