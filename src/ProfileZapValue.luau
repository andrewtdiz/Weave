local ProfileServiceValue = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local CLASS_METATABLE = { __index = ProfileServiceValue }
local WEAK_KEYS_METATABLE = { __mode = "k" }
local WeaveUtils = require(script.Parent.WeaveUtils)
local ZapPlayerValue = require(script.Parent.ZapPlayerValue)

local Types = require(script.Parent.Fusion.Types)

function ProfileServiceValue:getFor(player: Player)
	if RunService:IsClient() then
		error("Cannot use getFor on the client. Try using get() for the value or Fusion() for the fusion value")
		return
	end
	return self._playerValue:getFor(player)
end

function ProfileServiceValue:getWeaveValue()
	return self._playerValue:getWeaveValue()
end

function ProfileServiceValue:setFor(player: Player, newValue: any, force: boolean?)
	if RunService:IsClient() then
		error("Cannot set ProfileServiceValue value on the client. Only the Server")
		return
	end
	self._playerValue:setFor(player, newValue, force)
	task.spawn(function()
		self._dataHandler:Set(player, self._profileServiceKey, newValue)
	end)
end

function ProfileServiceValue:isLoaded(player)
	if RunService:IsClient() then
		error("Cannot get isLoaded ProfileServiceValue value on the client. Only the Server")
		return false
	end
	return self._isLoaded[player]
end

function ProfileServiceValue:_PlayerAdded(player: Player)
	if not RunService:IsServer() then
		return
	end
	self._isLoaded[player] = false
	local storedValue = self._dataHandler:GetAsync(player, self._profileServiceKey)
	self._isLoaded[player] = true
	self._playerValue:setFor(player, storedValue)
end

function ProfileServiceValue:_PlayerRemoving(player: Player)
	task.delay(2, function()
		self._isLoaded[player] = nil
	end)
end

local function ProfileServiceValue<T>(valueName: string, zapEventName: string, profileServiceKey: string): Types.State<T>
	if RunService:IsClient() then
		return ZapPlayerValue(`profileServiceValue_{valueName}`, zapEventName)
	end

	if profileServiceKey == nil then
		error(`Must provide profileServiceKey string to ProfileServiceValue on the server for {valueName}`)
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
		_name = valueName,
		_isLoaded = {},
		_playerValue = ZapPlayerValue(`profileServiceValue_{valueName}`, zapEventName, initialValue),
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

return ProfileServiceValue
