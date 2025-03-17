Particle = {}
Particle.__index = Particle

function Particle:new( _x, _y, _size, _rotation, _speed, _lifetime, _color )
  local particle = {
    ["x"]        = _x,
    ["y"]        = _y,
    ["size"]     = _size,
    ["rotation"] = _rotation,
    ["speed"]    = _speed,
    ["lifetime"] = _lifetime,
    ["age"]      = 0,
    ["color"]    = _color
  }

  setmetatable(particle, self)

  return particle
end

function Particle:update( dt )
  self.age = self.age + dt
  self.x = self.x + math.cos( self.rotation ) * dt * self.speed
  self.y = self.y + math.sin( self.rotation ) * dt * self.speed
end

function Particle:isDead()
  return self.age >= self.lifetime
end

function Particle:delete()
  self = nil
end

function Particle:draw()
  love.graphics.setColor( unpack(self.color) )
  love.graphics.circle( "fill", self.x, self.y, self.size, 50 )
end
