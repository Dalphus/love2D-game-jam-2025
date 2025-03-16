require("Units.Unit")

Ally = {}
Ally.__index = Ally
setmetatable(Ally, Unit)

function Ally:new(...)
  local ally = Unit:new(...)
  ally.movement_node = {}
  setmetatable(ally, self)
  return ally
end

function Ally:addMovementNode(_x, _y)
  print(string.format("Adding movement node at %d, %d", _x, _y))
  self.movement_node = {x = _x, y = _y}
end
