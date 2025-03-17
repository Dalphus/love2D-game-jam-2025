require("Particles.Particle2")

local SillySpore = {
  speed = 10,
  interval = 0.5,
  color = {rgb("#00FFFF")},
  count = 10,
  size = 5,
}
local MiniSpore = {
  speed = 10,
  interval = 0.5,
  lifetime = 1,
  color = {rgb("#FFFF00")},
  count = 10,
  size = 5,
}
local SuperSpore = {
  speed = 20,
  interval = 0.5,
  color = {rgb("#00FF00")},
  size = 100,
  on_expire = MiniSpore,
}
