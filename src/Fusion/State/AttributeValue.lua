--!nonstrict

--[[
	Constructs and returns objects which can be used to model independent
	reactive state.
]]

local Package = script.Parent.Parent
local Value = require(script.Parent.Value)
local Types = require(script.Parent.Parent.Types)

local class = {}

local ATTRIBUTE_DATA_TYPES = {"string", "boolean", "number", "Color3", "UDim2", "CFrame", "Vector2", "Vector3"}

function class.new<T>(instance: Instance, attribute: string, initialValue: T?): Types.State<T>
	assert(instance and instance:IsA("Instance"), `Instance {instance} is not an instance`)

	local attributeValue = instance:GetAttribute(attribute)
	local _value = if attributeValue ~= nil then attributeValue else initialValue 
	assert(_value ~= nil, `nil Attribute value {attributeValue} and Initial Value {initialValue} is invalid`)

	local attributeType = typeof(_value)
	assert(table.find(ATTRIBUTE_DATA_TYPES, attributeType), `{_value} is not a valid Attribute data type. {attributeValue}`)

	local value = Value.new(_value)

	local connection = instance:GetAttributeChangedSignal(attribute):Connect(function()
		value:set(instance:GetAttribute(attribute))
	end)

	local valueConnection = value.Changed:Connect(function()
		instance:SetAttribute(attribute, value:get())
	end)

	instance.Destroying:Connect(function()
		value:set(initialValue)
		valueConnection:Disconnect()
		connection:Disconnect()
	end)

	return value
end

return class
