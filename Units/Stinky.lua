require("Units.Ally")
require( "Particles.ParticleGenerator" )


Stinky = {}
Stinky.__index = Stinky
setmetatable(Stinky, Ally)

function Stinky:new(...)
  local Stinky = Ally:new(...)
  self.top_speed = 100
  self.acceleration = 50
  self.rotation_speed = 2
  setmetatable(Stinky, self)
  return Stinky
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
