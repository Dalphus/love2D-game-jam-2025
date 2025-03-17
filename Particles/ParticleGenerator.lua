require("Particles.Particle2")

ParticleGenerator = {}
ParticleGenerator.__index = ParticleGenerator

function ParticleGenerator:new( o, ... )
  local generator = {
    parent = o,
    emitters = {},
    particles = {},
  }
  setmetatable(generator, self)

  for _, emitter in pairs{...} do
    generator:add( emitter )
  end

  return generator
end

function ParticleGenerator:add( o )
  local emitter = {
    particle = _particle,
    timer = 0,
    interval = _interval,
    on_death = _on_death,
    age = 0,
  }
  table.insert( self.emitters, emitter )
end

function ParticleGenerator:update( dt )
  for _, emitter in pairs(self.emitters) do
    emitter.timer = emitter.timer + dt
    if emitter.timer >= emitter.interval then
      emitter.timer = 0
      table.insert( self.particles, emitter.particle:new() )
    end
  end
  for i, particle in pairs(self.particles) do
    particle:update( dt )
    if particle:isDead() then
      if particle.on_death then
        particle:on_death()
      end
      table.remove( self.particles, i )
      particle:delete()
    end
  end
end

function ParticleGenerator:draw()
  for _, particle in pairs( self.particles ) do
    particle:draw(self.parent)
  end
end
