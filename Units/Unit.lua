Unit = {}
Unit.__index = Unit

function Unit:new(_x, _y, _size, _rotation, _speed)
  local unit = {
    ["x"]        = _x        or 100,
    ["y"]        = _y        or 100,
    ["size"]     = _size     or 50,
    ["rotation"] = _rotation or 0,
    ["speed"]    = _speed    or 0,
    ["name"]     = "Unit",
    ["movement_nodes"] = {}
  }
  setmetatable(unit, self)
  return unit
end

function Unit:getPosition()
  return self.x, self.y
end

function Unit:addMovementNode(_x, _y)
  if not self:isValidMovementNode( _x, _y ) then
    print( "nope" )
    return
  end
  table.insert( self.movement_nodes, Node:new( _x, _y ) )
end

function Unit:isValidMovementNode( x1, y1 )
  local x2, y2 = self:getLastNodePos()
  for _, wall in ipairs( Scene.walls ) do
    if wall:collides( x1, y1, x2, y2, self.size ) then
      return false
    end
  end
  return true
end

function Unit:getLastNodePos()
  local nodes = self.movement_nodes
  local node = nodes[ #nodes ] or self
  return node.x, node.y
end

function Unit:face(x2, y2, dt)
  local x1, y1 = self.x, self.y
  local angle_diff = math.atan2(( y2 - y1 ), ( x2 - x1 )) - self.rotation
  angle_diff = ( angle_diff + math.pi ) % ( 2 * math.pi ) - math.pi
  self.rotation = self.rotation + dt * self.rotation_speed * sign( angle_diff )
  self.rotation = self.rotation % ( 2 * math.pi )
end

function Unit:angleDiff(x2, y2)
  local pt1 = math.atan2(( y2 - self.y ), ( x2 - self.x )) - self.rotation
  return ( pt1 + math.pi ) % ( 2 * math.pi ) - math.pi
end
