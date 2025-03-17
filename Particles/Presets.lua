require("Particles.Particle2")


SillySpore = {}
SillySpore.__index = SillySpore
setmetatable(SillySpore, Particle)
function SillySpore:new()
  local particle = Particle:new({
    speed = 10,
    interval = 0.5,
    color = {rgb("#00FFFF")},
    size = 5,
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
    interval = 0.5,
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
    interval = 0.5,
    color = {rgb("#00FF00")},
    size = 100,
    on_expire = MiniSpore,
  })
  setmetatable(particle, self)
  return particle
end
