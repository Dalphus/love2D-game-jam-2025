require("Units.Ally")
require( "Particles.ParticleGenerator" )


Dummy = {}
Dummy.__index = Dummy
setmetatable(Dummy, Ally)

function Dummy:new(...)
  local dummy = Ally:new(...)
  dummy.rotation_speed = 10
  setmetatable(dummy, self)
  dummy.name = "Dummy"
  return dummy
end

function Dummy:draw()
  if mouseInRadius(self, self.size) then
    love.graphics.setColor(255, 0, 0)
  else
    love.graphics.setColor(255, 255, 255)
  end
  love.graphics.circle("fill", self.x, self.y, self.size, 50)
  local x2 = math.cos(self.rotation) * self.size
  local y2 = math.sin(self.rotation) * self.size
  love.graphics.setColor(0, 0, 0)
  love.graphics.line(self.x, self.y, self.x + x2, self.y + y2)

  if next(self.movement_nodes) then
    love.graphics.setColor( 255, 0, 0 )
    love.graphics.line(self.x, self.y, self.movement_nodes[1].x, self.movement_nodes[1].y)
    for i = 1, #self.movement_nodes - 1 do
      local x1, y1 = self.movement_nodes[i].x, self.movement_nodes[i].y
      local x2, y2 = self.movement_nodes[i + 1].x, self.movement_nodes[i + 1].y
      love.graphics.line(x1, y1, x2, y2)
    end
  end
end

function Dummy:update( dt )
  if TurnEndFlag then
    if next(self.movement_nodes) then
      -- rotates Dummy to face movement node
      print(#self.movement_nodes)
      local x1, y1 = self.x, self.y
      local x2, y2 = self.movement_nodes[ 1 ].x, self.movement_nodes[ 1 ].y
      local angle_diff = math.atan2(( y2 - y1 ), ( x2 - x1 )) - self.rotation
      angle_diff = ( angle_diff + math.pi ) % ( 2 * math.pi ) - math.pi
      self.rotation = self.rotation + dt * self.rotation_speed * sign( angle_diff )
      self.rotation = self.rotation % ( 2 * math.pi )

      -- accelerates dummy forward
      self.speed = self.speed + self.acceleration * dt * 1.5

      if self.movement_nodes[2] then
        while #self.movement_nodes > 0 and vectorDist(self.x, self.y, self.movement_nodes[1].x, self.movement_nodes[1].y) <= (self.size * 1.1)  do
          table.remove(self.movement_nodes, 1)
        end
      elseif self.movement_nodes then
        if vectorDist(self.x, self.y, self.shadowx, self.shadowy) <= (self.size * 0.01) then
          self.speed = 0
          self.movement_nodes = {}
          self.x = self.shadowx
          self.y = self.shadowy
        end
      end
    end

    self.speed = self.speed - self.acceleration * dt * 0.5
    self.speed = clamp( self.speed, 0, top_speed )

    -- move dummy
    self.x = self.x + math.cos( self.rotation ) * dt * self.speed
    self.y = self.y + math.sin( self.rotation ) * dt * self.speed
  end
end
