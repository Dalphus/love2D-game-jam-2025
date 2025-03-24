require("Units.Unit")
require("Units.Node")

Enemy = {}
Enemy.__index = Enemy
setmetatable(Enemy, Unit)

function Enemy:new(_x, _y, _size, _rotation, _speed, _health, _fov, _sight_dist)
  local enemy = Unit:new(_x, _y, _size, _rotation, _speed, _health)
  self.fov = _fov or 45
  self.sight_dist = _sight_dist
  enemy.rotation_speed = 2
  enemy.name = "Enemy"
  enemy.locked_in = nil
  setmetatable(enemy, self)
  return enemy
end