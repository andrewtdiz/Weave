--!nonstrict

--[[
	Constructs and returns objects which can be used to model independent
	reactive state.
]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local useDependency = require(Package.Dependencies.useDependency)
local initDependency = require(Package.Dependencies.initDependency)
local updateAll = require(Package.Dependencies.updateAll).updateAll
local onDestroy = require(Package.Dependencies.updateAll).onDestroy
local isSimilar = require(Package.Utility.isSimilar)
local isArray = require(Package.Utility.isArray)
local isDictionary = require(Package.Utility.isDictionary)


local class = {}

local CLASS_METATABLE = {__index = class}
local WEAK_KEYS_METATABLE = {__mode = "k"}

--[[
	Returns the value currently stored in this State object.
	The state object will be registered as a dependency unless `asDependency` is
	false.
]]
function class:get(asDependency: boolean?): any
	if asDependency ~= false then
		useDependency(self)
	end
	return self._value
end

--[[
	Updates the value stored in this State object.

	If `force` is enabled, this will skip equality checks and always update the
	state object and any dependents - use this with care as this can lead to
	unnecessary updates.
]]
function class:set(newValue: any, force: boolean?)
	if self._destroyed then
		warn(`Cannot set destroyed Value`, self)
		return
	end
	local oldValue = self._value
	if force or not isSimilar(oldValue, newValue) then
		self._value = newValue
		updateAll(self)
		self._OnChanged:Fire(self._value)
	end
end

--[[
	FUSION 0.21 (CDT version)
	
	ARRAYS ONLY
	Inserts a value into this State object  if it is an array
]]
function class:update(cb: (a: any) -> any)
	if self._destroyed then
		warn(`Cannot set destroyed Value`, self)
		return
	end
	local oldValue = self._value
	if typeof(cb) == "function" then
		self:set(cb(oldValue))
	end
end

function class:Destroy()
	self._destroyed = true
	onDestroy(self)
	
	table.clear(self.dependentSet)
	
	self._OnChanged:Destroy()
end

function class.new<T>(initialValue: T): Types.State<T>
	local OnChanged = Instance.new("BindableEvent")
	local self = setmetatable({
		type = "State",
		kind = "Value",
		Changed = OnChanged.Event,
		-- if we held strong references to the dependents, then they wouldn't be
		-- able to get garbage collected when they fall out of scope
		dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
		_OnChanged = OnChanged,
		_value = initialValue,
		_destroyed = false
	}, CLASS_METATABLE)

	task.delay(0, function()
		self._OnChanged:Fire(self._value)
	end)

	initDependency(self)

	return self
end

return class