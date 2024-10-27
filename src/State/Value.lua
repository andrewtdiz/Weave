--!nonstrict

--[[
	Constructs and returns objects which can be used to model independent
	reactive state.
]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local useDependency = require(Package.Dependencies.useDependency)
local initDependency = require(Package.Dependencies.initDependency)
local updateAll = require(Package.Dependencies.updateAll)
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
function class:push(value: any)
	local oldValue = self._value
	if isArray(oldValue) then
		table.insert(oldValue, value)
		self._value = oldValue
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
	local oldValue = self._value
	if typeof(cb) ~= "function" then
		self._value = cb(oldValue)
		updateAll(self)
		self._OnChanged:Fire(self._value)
	end
end

--[[
	FUSION 0.21 (CDT version)
	
	ARRAYS ONLY
	Removes the first occurance of value in the State object if it is an array
]]
function class:remove(value: any)
	local oldValue = self._value
	if isArray(oldValue) then
		local ind = table.find(oldValue, value)
		local pop = ind and table.remove(oldValue, value)
		self._value = oldValue
		updateAll(self)
		self._OnChanged:Fire(self._value)
	end
end

--[[
	FUSION 0.21 (CDT version)
	
	DICTIONARIES ONLY
	Inserts the key and value into the dictionary
]]
function class:insert(key: any, value: any)
	local oldValue = self._value
	if isDictionary(oldValue) then
		oldValue[key] = value
		self._value = oldValue
		updateAll(self)
		self._OnChanged:Fire(self._value)
	end
end

--[[
	FUSION 0.21 (CDT version)
	
	DICTIONARIES ONLY
	Deletes the key from the dictionary
]]
function class:delete(key: any)
	local oldValue = self._value
	if isDictionary(oldValue) then
		oldValue[key] = nil
		self._value = oldValue
		updateAll(self)
		self._OnChanged:Fire(self._value)
	end
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
		_value = initialValue
	}, CLASS_METATABLE)
	
	task.delay(0, function()
		self._OnChanged:Fire(self._value)
	end)

	initDependency(self)

	return self
end

return class