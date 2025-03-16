Button = {}

function Button:new(_x, _y, _width, _height, _anchor)
  local button = {
    ["x"] = _x or 0,
    ["y"] = _y or 0,
    ["true_x"] = _x or 0,
    ["true_y"] = _y or 0,
    ["width"] = _width or 0,
    ["height"] = _height or 0,
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["anchor"] = _anchor or "TLEFT"
  }
  return button
end

function Button:draw()
  if self.anchor == "BRIGHT" then
    coordBottomRight(self)
  else
    coordTopLeft(self)
  end

  love.graphics.setColor(self.r, self.g, self.b)
  love.graphics.rectangle("fill", self.true_x, self.true_y, self.width, self.height)

  -- recolor button when user is hovering/clicking 
  if mouseWithin(self) then
    if love.mouse.isDown( 1 ) then
      love.graphics.setColor(self.r * 0.2, self.r * 0.2, self.r * 0.2)
    else
      love.graphics.setColor(self.r * 0.8, self.r * 0.8, self.r *0.8)
    end
    love.graphics.rectangle("fill", self.true_x + 2, self.true_y + 2, self.width - 4, self.height - 4)
  end
end

function mouseWithin(self)
  return ((love.mouse.getX() > self.true_x) and (love.mouse.getX() < (self.true_x + self.width))) and ((love.mouse.getY() > self.true_y) and (love.mouse.getY() < (self.true_y + self.height)))
end

function coordBottomRight(self)
  local window_height = love.graphics.getHeight()
  local window_width = love.graphics.getWidth()
  self.true_x = window_width - self.width - self.x
  self.true_y = window_height - self.height - self.y
end

function coordTopLeft(self)
  self.true_x = self.x
  self.true_y = self.y
end