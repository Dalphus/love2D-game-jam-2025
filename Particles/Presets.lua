require("Particles.Particle2")


SillySpore = {}
SillySpore.__index = SillySpore
setmetatable(SillySpore, Particle)
function SillySpore:new()
  local particle = Particle:new({
    speed = 30,
    lifetime = 1,
    color = {rgb("#00FFFF")},
    size = 15,
  })
  setmetatable(particle, self)
  return particle
end

MiniSpore = {}
MiniSpore.__index = MiniSpore
setmetatable(MiniSpore, Particle)
function MiniSpore:new()
  local particle = Particle:new({
    speed = 10,
    lifetime = 1,
    color = {rgb("#FFFF00")},
    size = 5,
  })
  setmetatable(particle, self)
  return particle
end

SuperSpore = {}
SuperSpore.__index = SuperSpore
setmetatable(SuperSpore, Particle)
function SuperSpore:new()
  local particle = Particle:new({
    speed = 20,
    lifetime = 2,
    color = {rgb("#00FF00")},
    size = 30
  })
  setmetatable(particle, self)
  return particle
end
