require("Units.Ally")
require( "Particles.ParticleGenerator" )
require( "Particles.Presets" )


Stinky = {}
Stinky.__index = Stinky
setmetatable(Stinky, Ally)

function Stinky:new(...)
  local stinky = Ally:new(...)
  stinky.top_speed = 100
  stinky.acceleration = 50
  stinky.rotation_speed = 2
  stinky.emitter = ParticleGenerator:new( stinky, SillySpore, SuperSpore )
  setmetatable(stinky, self)
  return stinky
end

function Stinky:addParticleGenerator( interval )
  self.particle_generator = ParticleGenerator:new( self, interval )
end

function Stinky:draw()
  if self.particle_generator then
    self.particle_generator:draw()
  end

  love.graphics.setColor(255, 255, 255)
  love.graphics.circle("line", self.x, self.y, self.size, 50)

end

Stinky.update = Dummy.update
