require("Units.Ally")
require("helpers")

Dummy = {}
Dummy.__index = Dummy
setmetatable(Dummy, Ally)

function Dummy:new(...)
  local dummy = Ally:new(...)
  setmetatable(dummy, self)
  return dummy
end

function Dummy:draw()
  if mouseInRadius(self, self.size) then
    love.graphics.setColor(255, 0, 0)
  else
    love.graphics.setColor(255, 255, 255)
  end
  love.graphics.circle("fill", self.x, self.y, self.size, 50)
  local x2 = math.cos(self.rotation) * self.size
  local y2 = math.sin(self.rotation) * self.size
  love.graphics.setColor(0, 0, 0)
  love.graphics.line(self.x, self.y, self.x + x2, self.y + y2)

  if self.movement_node.x then
    love.graphics.setColor( 255, 0, 0 )
    love.graphics.line(self.x, self.y, self.movement_node.x, self.movement_node.y)
  end
end

function Dummy:update( dt )
  if self.movement_node.x then
    -- rotates Dummy to face movement node
    -- I have no idea why this works
    local current_angle = math.deg(self.rotation)
    local x1, y1 = self.x, self.y
    local x2, y2 = self.movement_node.x, self.movement_node.y
    local target_angle = math.deg(math.atan2(( y2 - y1 ), ( x2 - x1 ))) - 90
    if target_angle < 0 then
      target_angle = target_angle + 360
    end
    local angle_diff = math.abs(current_angle - target_angle)
    if angle_diff < 90 or angle_diff > 270 then
      self.rotation = self.rotation + dt * rotation_speed / 2
    else
      self.rotation = self.rotation - dt * rotation_speed / 2
    end
    self.rotation = self.rotation % ( 2 * math.pi )

    -- accelerates self forward
    self.speed = self.speed + acceleration * dt * 1.5

    if vectorDist(self.x, self.y, self.movement_node.x, self.movement_node.y) <= self.size then
      self.movement_node.x = nil
      self.movement_node.y = nil
    end
  end

  self.speed = self.speed - acceleration * dt * 0.5
  self.speed = clamp( self.speed, 0, top_speed )

  -- move self
  self.x = self.x + math.cos( self.rotation ) * dt * self.speed
  self.y = self.y + math.sin( self.rotation ) * dt * self.speed

  -- keep self on screen
  self.x = clamp(self.x, 0 - self.size, scene.width + self.size)
  self.y = clamp(self.y, 0 - self.size, scene.height + self.size)
end
