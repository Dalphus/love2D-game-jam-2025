require("Units.Unit")

Ally = {}
Ally.__index = Ally

function Ally:new(...)
  local ally = Unit:new(...)
  ally.movement_nodes = {}
  setmetatable(ally, self)
  return ally
end
