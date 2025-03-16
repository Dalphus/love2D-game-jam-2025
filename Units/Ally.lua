require("Units.Unit")

Ally = {}
Ally.__index = Ally

function Ally:new(...)
	local ally = Unit:new(...)
	setmetatable(ally, self)
	return ally
end
