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
  -- stinky.emitter = ParticleGenerator:new( stinky )
  -- stinky.emitter:add( SillySpore, .1 )
  -- stinky.emitter:add( SuperSpore, .5 )

  setmetatable(stinky, self)
  return stinky
end

function Stinky:draw()
  -- self.emitter:draw()

  love.graphics.setColor(255, 255, 255)
  love.graphics.circle("line", self.x, self.y, self.size, 50)

end

function Stinky:update( dt )
  -- self.emitter:update( dt )
  Brute.update( self, dt )
end
