--!strict
--[[
    Returns true if a is an array or undetermined table type
]]

local tableType = require(script.Parent.tableType)

local function isArray(a: any): boolean
	local tableType = tableType(a)
	return tableType == "Array" or tableType == "Undetermined" 
end

return isArray