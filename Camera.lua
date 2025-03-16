COMMAND_WIDTH = 300
COMMAND_HEIGHT = 100

Camera = {x = 100, y = 100, zoom = 1, min_zoom = 0.4, max_zoom = 2, UI_unit = nil}

function Camera:grabUIofUnit(unit)
    UI_unit = unit
end

function Camera:drawUnitUI()
    if UI_unit then 
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
        love.graphics.setColor(0, 0, 255)
        love.graphics.line(x1, y1, x2, y2, x3, y3, x4 ,y4)
    end
end

function Camera:drawEndTurn()
    local button_width = 100
    local button_height = 50
    local window_height = love.graphics.getHeight()
    local window_width = love.graphics.getWidth()
    love.graphics.setColor(0, 0, 255)
    love.graphics.line(x1, y1, x2, y2, x3, y3, x4 ,y4)
end
-- Camera object
-- relative postion in scene
-- zoom value
-- max and minimum zoom parameters
-- pan camera by amount
-- keep camera in bounds of scene
