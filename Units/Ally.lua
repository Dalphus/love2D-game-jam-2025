require("Units.Unit")

Ally = {}
Ally.__index = Ally

function Ally:new(...)
	local ally = Unit:new(...)
	setmetatable(ally, self)
	ally.name = "Ally"
	return ally
end
