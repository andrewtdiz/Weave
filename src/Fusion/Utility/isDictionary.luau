--!strict
--[[
    Returns true if a is an array or undetermined value
]]

local tableType = require(script.Parent.tableType)

local function isDictionary(a: any): boolean
	local tableType = tableType(a)
	return tableType == "Dictionary" or tableType == "Undetermined" 
end

return isDictionary