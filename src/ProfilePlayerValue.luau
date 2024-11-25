local ProfilePlayerValue = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local CLASS_METATABLE = { __index = ProfilePlayerValue }
local WEAK_KEYS_METATABLE = { __mode = "k" }
local Fusion = require(script.Parent.Fusion)
local WeaveUtils = require(script.Parent.WeaveUtils)
local PlayerValue = require(script.Parent.PlayerValue)

local Types = require(script.Parent.Fusion.Types)

function ProfilePlayerValue:getFor(player: Player)
	if RunService:IsClient() then
		error("Cannot use getFor on the client. Try using get() for the value or Fusion() for the fusion value")
		return
	end
	return self._playerValue:getFor(player)
end

function ProfilePlayerValue:getWeaveValue()
	return self._playerValue:getWeaveValue()
end

function ProfilePlayerValue:updateFor(player: Player, func: (t: any) -> nil, force: boolean)
	if RunService:IsClient() then
		error("Cannot use getFor on the client. Try using get() for the value or Fusion() for the fusion value")
		return
	end
	if typeof(func) ~= "function" then 
		error("Update for must use a callback function")
		return
	end

	local initialValue = self:getFor(player)
	local updatedValue = func(initialValue)

	self:setFor(player, updatedValue, force)

	return self:getFor(player)
end

function ProfilePlayerValue:setFor(player: Player, newValue: any, force: boolean?)
	if RunService:IsClient() then
		error("Cannot set ProfilePlayerValue value on the client. Only the Server")
		return
	end
	self._playerValue:setFor(player, newValue, force)
	task.spawn(function()
		self._dataHandler:Set(player, self._profileServiceKey, newValue)
	end)
end

function ProfilePlayerValue:isLoaded(player)
	if RunService:IsClient() then
		error("Cannot get isLoaded ProfilePlayerValue value on the client. Only the Server")
		return false
	end
	return self._isLoaded[player]
end

function ProfilePlayerValue:_PlayerAdded(player: Player)
	if not RunService:IsServer() then
		return
	end
	self._isLoaded[player] = false
	local storedValue = self._dataHandler:GetAsync(player, self._profileServiceKey)
	self._isLoaded[player] = true
	self._playerValue:setFor(player, storedValue)
end

function ProfilePlayerValue:_PlayerRemoving(player: Player)
	task.delay(2, function()
		self._isLoaded[player] = nil
	end)
end

function ProfilePlayerValue.new<T>(profileServiceKey: string): Types.State<T>
	if RunService:IsClient() then
		return PlayerValue.new(`ProfilePlayerValue_{profileServiceKey}`)
	end

	if profileServiceKey == nil then
		error(`Must provide profileServiceKey string to ProfilePlayerValue on the server for {profileServiceKey}`)
		return
	end

	local DataHandler = WeaveUtils.GetPlayerDataHandler()

	local initialValue = DataHandler:GetProfileTemplate()[profileServiceKey]
	if initialValue == nil then
		print(DataHandler:GetProfileTemplate())
		error(
			`Profile template object must have {profileServiceKey}. Did you add the key {profileServiceKey} to the ProfileService Profile?`
		)
		return
	end

	local playerValue = PlayerValue.new(`ProfilePlayerValue_{profileServiceKey}`, initialValue)

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
		_isLoaded = {},
		_playerValue = playerValue,
		Changed = playerValue:getChangedSignal(),
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

return ProfilePlayerValue
