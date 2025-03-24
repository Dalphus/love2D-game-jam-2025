require("Units.Node")

Bullet = {}
Bullet.__index = Bullet
setmetatable(Bullet, Node)

function Bullet:new(_x, _y, _radius, _speed, _heading, _owner)
  local bullet = Node:new(_x, _y)
  bullet.radius = _radius
  bullet.speed = _speed
  bullet.heading = _heading
  bullet.owner = _owner
  bullet.needs_cleanup = false
  setmetatable(bullet, self)
  return bullet
end

function Bullet:update(dt)
  -- move bullet
  self.x = self.x + math.cos( self.heading ) * dt * self.speed
  self.y = self.y + math.sin( self.heading ) * dt * self.speed

  -- hit detection
  for _, player in pairs( players ) do
    if vectorDist(player.x, player.y, self.x, self.y) < player.size and player ~= self.owner then
      player.health = player.health - 1
      self.needs_cleanup = true
      break
    end
  end
  if self.needs_cleanup then return end
  for _, enemy in pairs( enemies ) do
    if vectorDist(enemy.x, enemy.y, self.x, self.y) < enemy.size and enemy ~= self.owner then
      enemy.health = enemy.health - 1
      self.needs_cleanup = true
      break
    end
  end
end

function Bullet:draw()
  love.graphics.setColor(1, 0.5, 0)
  love.graphics.circle("fill", self.x, self.y, self.radius, 10)
end