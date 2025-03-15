function mouseInRadius(centerpoint, _radius)
    local radius = (_radius and centerpoint.size) and centerpoint.size or 50
    -- return true if vector distance between the center of the player
    -- and the cursor is less then or equal to the player radius
    local x = (love.mouse.getX() - Camera.x) / Camera.zoom
    local y = (love.mouse.getY() - Camera.y) / Camera.zoom
    return vectorDist(centerpoint.x, centerpoint.y, x, y) <= radius
  end

function mouseInUISquare()
    
end

function averagePoint(items)
    local coords = {[1] = 0, [2] = 0}
    for _, i in pairs(items) do
        coords[1] = coords[1] + i.x
        coords[2] = coords[2] + i.y
    end
    coords[1] = coords[1] / #items
    coords[2] = coords[2] / #items
    return coords
end

function circumscribe(items, buffer)
    local coords = averagePoint(items)
    local maxDist = 0
    local thisDist = 0
    for _, i in pairs(items) do
        thisDist = vectorDist(coords[1], coords[2], i.x, i.y)
        if thisDist > maxDist then
            maxDist = thisDist
        end
    end
    return love.graphics.circle("line", coords[1], coords[2], maxDist + buffer, 50)
end

function vectorDist(x1, y1, x2, y2)
    local xdiff2 = math.pow(x1 - x2, 2)
    local ydiff2 = math.pow(y1 - y2, 2)
    return math.sqrt(xdiff2 + ydiff2)
end
