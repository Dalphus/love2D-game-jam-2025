require("Units.Enemy")

Turret = {}
Turret.__index = Turret
setmetatable(Turret, Enemy)

function Turret:new(_x, _y, _size, _rotation, _speed, _health, _fov, _sight_dist)
  local turret = Enemy:new(_x, _y, _size, _rotation, _speed, _health, _fov, _sight_dist)
  setmetatable(turret, self)
  return turret
end

function Turret:update(dt)
  if not TurnEndFlag then return end
  local closest = nil
  local closestDist = self.sight_dist
  for _, player in pairs( players ) do
    local dist = vectorDist(self.x, self.y, player.x, player.y)
    if dist < closestDist then
      closestDist = dist
      closest = player
    end
    if closest then
      if math.abs(self:angleDiff(closest.x, closest.y)) <= self.fov/2 then 
        self:face(closest.x, closest.y, dt)
      end
    end
  end
end

function Turret:draw()
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", self.x, self.y, self.size, 50)
  local x2 = math.cos(self.rotation) * self.size
  local y2 = math.sin(self.rotation) * self.size
  local x3 = math.cos(self.rotation - (self.fov/2)) * self.sight_dist
  local y3 = math.sin(self.rotation - (self.fov/2)) * self.sight_dist
  local x4 = math.cos(self.rotation + (self.fov/2)) * self.sight_dist
  local y4 = math.sin(self.rotation + (self.fov/2)) * self.sight_dist
  love.graphics.line(self.x, self.y, self.x + x3, self.y + y3)
  love.graphics.line(self.x, self.y, self.x + x4, self.y + y4)
  love.graphics.setColor(1, 1, 1)
  love.graphics.line(self.x, self.y, self.x + x2, self.y + y2)
end