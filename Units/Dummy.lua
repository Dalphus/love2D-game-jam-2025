require("Units.Ally")

Dummy = {}
Dummy.__index = Dummy

function Dummy:new(...)
  local dummy = Ally:new(...)
  setmetatable(dummy, self)
  return dummy
end

function Dummy:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.circle("fill", self.x, self.y, self.size, 50)
  local x2 = math.cos(self.rotation) * self.size
  local y2 = math.sin(self.rotation) * self.size
  love.graphics.setColor(0, 0, 0)
  love.graphics.line(self.x, self.y, self.x + x2, self.y + y2)
end
