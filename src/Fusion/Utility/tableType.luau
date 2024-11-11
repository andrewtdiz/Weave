--!strict
--[[
    Returns true if A and B are 'similar' - i.e. any user of A would not need
    to recompute if it changed to B.
]]

local function tableType(t)
	if next(t) == nil then return "Undetermined" end
	local isArray = true
	local isDictionary = true
	for k, _ in next, t do
		if typeof(k) == "number" and k%1 == 0 and k > 0 then
			isDictionary = false
		else
			isArray = false
		end
	end
	if isArray then
		return "Array"
	elseif isDictionary then
		return "Dictionary"
	else
		return "Mixed"
	end
end

return tableType