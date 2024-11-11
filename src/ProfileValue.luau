local ProfileValue = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local CLASS_METATABLE = { __index = ProfileValue }
local WEAK_KEYS_METATABLE = { __mode = "k" }
local Fusion = require(script.Parent.Fusion)
local WeaveUtils = require(script.Parent.WeaveUtils)
local NetworkValue = require(script.Parent.NetworkValue)

local Types = require(script.Parent.Fusion.Types)
type State = Fusion.State

function ProfileValue:getFor(player: Player)
	if RunService:IsClient() then
		error("Cannot use getFor on the client. Try using get() for the value or Fusion() for the fusion value")
		return
	end
	return self._playerObject:get()[player]
end

function ProfileValue:get()
	if RunService:IsClient() then
		error("Uhhhhh how did you do that? Did you follow the documentation for how to use ProfileValue?")
		return
	end
	return self._playerObject:get()
end

function ProfileValue:getWeaveValue()
	return self._playerObject:getWeaveValue()
end

function ProfileValue:setFor(player: Player, newValue: any, force: boolean?)
	if RunService:IsClient() then
		error("Cannot set ProfileValue value on the client. Only the Server")
		return
	end
	local tempObject = self._playerObject:get()
	tempObject[player] = newValue
	self._playerObject:set(tempObject, force)
	task.spawn(function()
		self._dataHandler:Set(player, self._profileServiceKey, newValue)
	end)
end

function ProfileValue:_PlayerAdded(player: Player)
	if not RunService:IsServer() then
		return
	end
	local fusionValue = self._playerObject:get()
	fusionValue[player] = self._initialValue
	self._playerObject:set(fusionValue)
	local newValue = self._dataHandler:GetAsync(player, self._profileServiceKey)
	local fusionValue = self._playerObject:get()
	fusionValue[player] = newValue
	self._playerObject:set(fusionValue)
end

function ProfileValue:_PlayerRemoving(player: Player)
	if not RunService:IsServer() then
		return
	end
	local fusionValue = self._playerObject:get()
	fusionValue[player] = nil
	self._playerObject:set(fusionValue)
end

function ProfileValue.new<T>(profileServiceKey: string): State<T>
	if RunService:IsClient() then
		return NetworkValue.new(`ProfileValue_{profileServiceKey}`)
	end

	if profileServiceKey == nil then
		error(`Must provide profileServiceKey string to ProfileValue on the server for {profileServiceKey}`)
		return
	end

	local DataHandler = WeaveUtils.GetPlayerDataHandler()

	local initialValue = DataHandler:GetProfileTemplate()[profileServiceKey]
	if initialValue == nil then
		error(
			`Profile template object must have {profileServiceKey}. Did you add the key {profileServiceKey} to the ProfileService Profile?`
		)
		return
	end

	local self = setmetatable({
		type = "State",
		kind = "Value",
		-- if we held strong references to the dependents, then they wouldn't be
		-- able to get garbage collected when they fall out of scope
		dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
		_initialValue = initialValue,
		_profileServiceKey = profileServiceKey,
		_dataHandler = DataHandler,
		_name = profileServiceKey,
		_playerObject = NetworkValue.new(`ProfileValue_{profileServiceKey}`, {}),
		_troves = {},
	}, CLASS_METATABLE)

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
	end

	return self
end

return ProfileValue
