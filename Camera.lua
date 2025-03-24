require("helpers")
require("UI.Button")

COMMAND_WIDTH = 300
COMMAND_HEIGHT = 100

Camera = {
  x = 100,
  y = 100,
  zoom = 1,
  min_zoom = 0.4,
  max_zoom = 2,
  UI_unit = nil,
  margin = 150
}

local button_width = 100
local button_height = 50
local window_height = love.graphics.getHeight()
local window_width = love.graphics.getWidth()
local buffer = 50
love.graphics.rectangle("fill", window_width - button_width - buffer, window_height - button_height - buffer, button_width, button_height)
local turnEnd = Button:new(50, 50, 100, 50, "BRIGHT")
turnEnd:setColor(0, 0, 1)
turnEnd:setText("End Turn")
local unitLabel = love.graphics.newText(love.graphics.getFont(), {{1,1,1}, "Empty"})
turnEnd:setFunction(function() co = coroutine.create(function()
  turnEnd.heldAction = co
  TurnEndFlag = true
  local start = love.timer.getTime()
  while (love.timer.getTime() - start) < TurnTime do
    coroutine.yield()
  end
  for _, player in pairs( players ) do
    player:undoMovementNodes()
  end
  TurnEndFlag = false 
end)
coroutine.resume(co)
end, true)
local AbilityAButton = nil
local AbilityBButton = nil

function Camera:grabUIofUnit(unit)
  UI_unit = unit
  if players[unit] then 
    unitLabel:set(players[unit].name)
  else
    unitLabel:set(enemies[unit].name)
  end
end

function Camera:renderUI()
  drawUnitUI()
  Button.draw(turnEnd)
end

function Camera:buttonEvents()
  Button.mouseEvent(turnEnd)
  if AbilityAButton then Button.mouseEvent(AbilityAButton) end
  if AbilityBButton then Button.mouseEvent(AbilityBButton) end
end

function Camera:buttonCooling(dt)
  Button.coolDown(turnEnd, dt)
end

function drawUnitUI()
  if players[UI_unit] or enemies[UI_unit] then 
      local unit = players[UI_unit] or enemies[UI_unit]
      local window_height = love.graphics.getHeight()
      local window_width = love.graphics.getWidth()
      x1 = window_width/2 - COMMAND_WIDTH
      y1 = window_height
      x2 = window_width/2 - COMMAND_WIDTH
      y2 = window_height - COMMAND_HEIGHT
      x3 = window_width/2 + COMMAND_WIDTH
      y3 = window_height - COMMAND_HEIGHT
      x4 = window_width/2 + COMMAND_WIDTH
      y4 = window_height
      if unit.time_budget then 
        love.graphics.setColor(0, 0, 1)
      else 
        love.graphics.setColor(1, 0, 0)
      end
      love.graphics.line(x1, y1, x2, y2, x3, y3, x4 ,y4)
      love.graphics.rectangle("fill", x2, y2, COMMAND_WIDTH * 2, COMMAND_HEIGHT/4)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(unitLabel, x2 + 5, y2 + (COMMAND_HEIGHT/8) - (unitLabel:getHeight()/2))
      love.graphics.setColor(0, 1, 0)
      if unit.time_budget then love.graphics.rectangle("fill", x2, y2 - (COMMAND_HEIGHT/4), COMMAND_WIDTH * 2 * (unit.time_budget/100), COMMAND_HEIGHT/4) end
      if unit.AbilityA then
        AbilityAButton = Button:new(x2 + 10, y2 + (COMMAND_HEIGHT/4) + 5 , COMMAND_WIDTH - 15, COMMAND_HEIGHT*.75 - 10, "TLEFT")
        AbilityAButton:setText(unit.AbilityA)
        AbilityAButton:setFunction(function () unit:AbilityAFunction() end, false)
        AbilityAButton:setColor(0, 0, 1)
        if unit.AbilityB then
          AbilityBButton = Button:new(x2 + COMMAND_WIDTH + 5, y2 + (COMMAND_HEIGHT/4) + 5 , COMMAND_WIDTH - 15, COMMAND_HEIGHT*.75 - 10, "TLEFT")
          AbilityBButton:setText(unit.AbilityB)
          AbilityBButton:setColor(0, 0, 1)
          AbilityBButton:draw()
        end
        AbilityAButton:draw()
      end
      if unit.portrait then
        love.graphics.setColor(1, 1, 1)
        local portrait_transform = love.math.newTransform(0, window_height-200, 0, 200/500, 200/500)
        love.graphics.draw(unit.portrait, portrait_transform)
      end
      for i = 1, unit.health do
        love.graphics.circle("fill", x3 - (25*i) , y3 + (COMMAND_HEIGHT/8) , 10)
      end
  end
end

-- Camera object
-- relative postion in scene
-- zoom value
-- max and minimum zoom parameters
-- pan camera by amount
-- keep camera in bounds of scene
