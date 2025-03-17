
require("Particles.Particle2")

ParticleGenerator = {}
ParticleGenerator.__index = ParticleGenerator

function ParticleGenerator:new( _parent, _interval )
  local generator = {
    ["parent"] = _parent,
    ["particles"] = {},
    ["timer"] = 0,
    ["interval"] = _interval
  }

  local x = Particle:new( 100, 100, 10, 0, 10, 100, { 1, 1, 0 } )

  setmetatable(generator, self)

  return generator
end

function ParticleGenerator:update( dt )
  self.timer = self.timer + dt
  if self.timer >= self.interval then
    self.timer = 0
    self:add( .6, { 1, 1, 0 } )
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
    _lifetime or 1,
    _color
  )
  table.insert( self.particles, particle )
  return particle
end
