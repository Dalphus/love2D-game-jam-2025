require("Units.Unit")
require("Units.Node")

Ally = {}
Ally.__index = Ally
setmetatable(Ally, Unit)

function Ally:new(...)
  local ally = Unit:new(...)
  ally.movement_nodes = {}
  setmetatable(ally, self)
  return ally
end

function Ally:addMovementNode(_x, _y)
  print(string.format("Adding movement node at %d, %d", _x, _y))
  table.insert(self.movement_nodes, Node:new(_x, _y))
end
