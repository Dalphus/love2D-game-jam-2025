require("Units.Unit")
require("Units.Node")

Ally = {}
Ally.__index = Ally
setmetatable(Ally, Unit)

function Ally:new(...)
  local ally = Unit:new(...)
  ally.top_speed = 200
  ally.acceleration = 100
  ally.rotation_speed = 2
  ally.name = "Ally"
  ally.movement_nodes = {}
  setmetatable(ally, self)
  return ally
end

function Ally:addMovementNode(_x, _y)
  if not self:isValidMovementNode( _x, _y ) then
    print( "nope" )
    return
  end
  table.insert( self.movement_nodes, Node:new( _x, _y ) )
end

function Ally:isValidMovementNode( x1, y1 )
  for _, wall in ipairs( scene.walls ) do
    local x2, y2 = self:getLastNodePos()
    if wall:collides( x1, y1, x2, y2 ) then
      return false
    end
  end
  return true
end

function Ally:undoMovementNode()
  table.remove(self.movement_nodes)
end

function Ally:getLastNodePos()
  local nodes = self.movement_nodes
  local node = nodes[ #nodes ] or self
  return node.x, node.y
end
