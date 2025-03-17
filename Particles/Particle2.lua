Particle = {}
Particle.__index = Particle

function Particle:new( o )
  local particle = {
    x        = o.x or 0,
    y        = o.y or 0,
    speed    = o.speed,
    color    = o.color,
    size     = o.size,
    lifetime = o.lifetime,
    rotation = o.rotation or math.random() * 2 * math.pi,
    age      = 0,
  }

  setmetatable(particle, self)
  return particle
end

function Particle:isDead()
  return self.age >= self.lifetime
end

function Particle:delete()
  self = nil
end

function Particle:update( dt )
  self.age = self.age + dt
  self.x = self.x + math.cos( self.rotation ) * dt * self.speed
  self.y = self.y + math.sin( self.rotation ) * dt * self.speed
end

function Particle:draw( o )
  local x1 = o and o.x or 0
  local y1 = o and o.y or 0
  love.graphics.setColor( unpack(self.color) )
  love.graphics.circle( "fill", x1 + self.x, y1 + self.y, self.size, 50 )
end
