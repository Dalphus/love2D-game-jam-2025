function mouseInRadius(centerpoint, radius)
    -- return true if vector distance between the center of the player
    -- and the cursor is less then or equal to the player radius
    local adj_point = { x = centerpoint.x * Camera.zoom - Camera.x, y = centerpoint.y * Camera.zoom - Camera.y }
    return vectorDist(adj_point.x, adj_point.y, love.mouse.getX(), love.mouse.getY()) <= (radius * Camera.zoom)
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
