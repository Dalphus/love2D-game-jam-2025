require("Units.Node")

Bullet = {}
Bullet.__index = Bullet
setmetatable(Bullet, Node)

function Bullet:new(_x, _y, _radius, _speed, _heading)
  local bullet = Node:new(_x, _y)
  bullet.radius = _radius
  bullet.speed = _speed
  bullet.heading = _heading
  setmetatable(bullet, self)
  return bullet
end

function Bullet:update(dt)
  -- move bullet
  self.x = self.x + math.cos( self.heading ) * dt * self.speed
  self.y = self.y + math.sin( self.heading ) * dt * self.speed
end

function Bullet:draw()
  love.graphics.setColor(1, 0.5, 0)
  love.graphics.circle("fill", self.x, self.y, self.radius, 10)
end