require("Units.Ally")
require( "Particles.ParticleGenerator" )


Dummy = {}
Dummy.__index = Dummy
setmetatable(Dummy, Ally)

function Dummy:new(...)
  local dummy = Ally:new(...)
  dummy.rotation_speed = 5
  setmetatable(dummy, self)
  return dummy
end

function Dummy:addParticleGenerator( interval )
  self.particle_generator = ParticleGenerator:new( self, interval )
end

function Dummy:draw()
  if self.particle_generator then
    self.particle_generator:draw()
  end

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
  if self.particle_generator then
    self.particle_generator:update( dt )
  end
  if next(self.movement_nodes) then
    -- rotates Dummy to face movement node
    local x1, y1 = self.x, self.y
    local x2, y2 = self.movement_nodes[ 1 ].x, self.movement_nodes[ 1 ].y
    local angle_diff = math.atan2(( y2 - y1 ), ( x2 - x1 )) - self.rotation
    angle_diff = ( angle_diff + math.pi ) % ( 2 * math.pi ) - math.pi
    self.rotation = self.rotation + dt * self.rotation_speed * sign( angle_diff )
    self.rotation = self.rotation % ( 2 * math.pi )

    -- accelerates dummy forward
    self.speed = self.speed + self.acceleration * dt * 1.5

    if vectorDist( x1, y1, x2, y2 ) <= self.size then
      table.remove( self.movement_nodes, 1 )
    end
  end

  self.speed = self.speed - self.acceleration * dt * 0.5
  self.speed = clamp( self.speed, 0, self.top_speed )

  -- move dummy
  self.x = self.x + math.cos( self.rotation ) * dt * self.speed
  self.y = self.y + math.sin( self.rotation ) * dt * self.speed

end
