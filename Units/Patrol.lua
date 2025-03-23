require("Units.Enemy")

Patrol = {}
Patrol.__index = Patrol
setmetatable(Patrol, Enemy)

function Patrol:new(_x, _y, _size, _rotation, _speed, _fov, _sight_dist)
  local patrol = Enemy:new(_x, _y, _size, _rotation, _speed, _fov, _sight_dist)
  patrol.target_point = 1
  patrol.speed = 100
  patrol.locked_in = nil
  setmetatable(patrol, self)
  return patrol
end

function Patrol:update(dt)
  if not TurnEndFlag then return end
  if self.locked_in then
    self:face(self.locked_in.x, self.locked_in.y, dt)
    -- move dummy
    self.x = self.x + math.cos( self.rotation ) * dt * self.speed
    self.y = self.y + math.sin( self.rotation ) * dt * self.speed
  else
    self:face(self.movement_nodes[self.target_point].x, self.movement_nodes[self.target_point].y, dt)
    -- move dummy
    self.x = self.x + math.cos( self.rotation ) * dt * self.speed
    self.y = self.y + math.sin( self.rotation ) * dt * self.speed
    if vectorDist(self.x, self.y, self.movement_nodes[self.target_point].x, self.movement_nodes[self.target_point].y) <= (self.size * 1.1) then
      if self.movement_nodes[self.target_point + 1] then
        self.target_point = self.target_point + 1
      else
        self.target_point = 1
      end
    end
    local closest = nil
    local closestDist = self.sight_dist
    for _, player in pairs( players ) do
      local dist = vectorDist(self.x, self.y, player.x, player.y)
      if dist < closestDist then
        closestDist = dist
        closest = player
      end
      if closest then
        self.locked_in = closest
      end
    end
  end
end

function Patrol:draw()
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
  for i = 1, #self.movement_nodes do
    local x5, y5 = self.movement_nodes[i].x, self.movement_nodes[i].y
    local x6, y6 = 0, 0
    if self.movement_nodes[i + 1] then
      x6, y6 = self.movement_nodes[i + 1].x, self.movement_nodes[i + 1].y
    else
      x6, y6 = self.movement_nodes[1].x, self.movement_nodes[1].y
    end
    love.graphics.line(x5, y5, x6, y6)
  end
  love.graphics.line(self.movement_nodes[self.target_point].x, self.movement_nodes[self.target_point].y, self.x, self.y)
end