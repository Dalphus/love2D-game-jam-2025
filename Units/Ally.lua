require("Units.Unit")
require("Units.Node")

Ally = {}
Ally.__index = Ally
setmetatable(Ally, Unit)

function Ally:new(...)
  local ally = Unit:new(...)
  ally.top_speed = 200
  ally.acceleration = 100
  ally.rotation_speed = 2
  ally.name = "Ally"
  ally.movement_nodes = {}
  ally.shadowx = ally.x
  ally.shadowy = ally.y
  ally.rate_limit_tally = 0
  setmetatable(ally, self)
  return ally
end

function Ally:addMovementNode(_x, _y)
  table.insert(self.movement_nodes, Node:new(_x, _y))
end

function Ally:undoMovementNodes()
  self.movement_nodes = {}
  self.shadowx = self.x
  self.shadowy = self.y
end

function Ally:shadowUpdate(dt)
  local speed = 0
  
  -- update self
  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
    speed = 100
  else
    speed = 0
  end

  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    self.rotation = self.rotation - dt * self.rotation_speed * 0.3
  elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    self.rotation = self.rotation + dt * self.rotation_speed * 0.3
  end

  -- move self
  self.shadowx = self.shadowx + math.cos(self.rotation) * dt * speed
  self.shadowy = self.shadowy + math.sin(self.rotation) * dt * speed
  
  -- keep self on screen
  self.shadowx = (self.shadowx + self.size) % (love.graphics.getWidth() + self.size * 2) - self.size
  self.shadowy = (self.shadowy + self.size) % (love.graphics.getHeight() + self.size * 2) - self.size

  -- add node
  if (speed > 0) and (vectorDist(self.x, self.y, self.shadowx, self.shadowy) > self.size) then
    if self.rate_limit_tally == 0 then
      self:addMovementNode(self.shadowx, self.shadowy)
    elseif (self.rate_limit_tally == 60) then
      self.rate_limit_tally = 0
    else
      self.rate_limit_tally = self.rate_limit_tally + 1
    end
  else 
    self.rate_limit_tally = 0
  end
end

function Ally:shadowDraw()
  if self.movement_nodes then
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.circle("fill", self.shadowx, self.shadowy, self.size, 50)
    local x2 = math.cos(self.rotation) * self.size
    local y2 = math.sin(self.rotation) * self.size
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(self.shadowx, self.shadowy, self.shadowx + x2, self.shadowy + y2)
  end
end
