

Particle = {}
Particle.__index = Particle

function Particle:new( _x, _y, _size, _rotation, _speed, _lifetime, _color )
  local particle = {
    ["x"]        = _x,
    ["y"]        = _y,
    ["size"]     = _size,
    ["rotation"] = _rotation,
    ["speed"]    = top_speed,
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
  print("deleting particle")
  self = nil
end

function Particle:draw()
  love.graphics.setColor( unpack(self.color) )
  love.graphics.circle( "fill", self.x, self.y, self.size, 50 )
end

ParticleGenerator = {}
ParticleGenerator.__index = ParticleGenerator

function ParticleGenerator:new( _parent, _interval )
  local generator = {
    ["parent"] = _parent,
    ["particles"] = {},
    ["timer"] = 0,
    ["interval"] = _interval
  }

  setmetatable(generator, self)

  return generator
end

function ParticleGenerator:update( dt )
  self.timer = self.timer + dt
  if self.timer >= self.interval then
    self.timer = 0
    self:add( 100, { 1, 1, 0 } )
  end
  for i, particle in pairs(self.particles) do
    particle:update( dt )
    if particle:isDead() then
      particle:delete()
      table.remove( self.particles, i )
    end
  end
end

function ParticleGenerator:draw()
  for _, particle in pairs( self.particles ) do
    particle:draw()
  end
end

function ParticleGenerator:add( _lifetime, _color )
  local particle = Particle:new(
    self.parent.x,
    self.parent.y,
    10,
    math.random() * 2 * math.pi,
    10,
    _lifetime or 100,
    _color
  )
  table.insert( self.particles, particle )
  return particle
end
