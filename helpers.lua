function mouseInRadius(centerpoint, _radius)
  local radius = (_radius and centerpoint.size) and centerpoint.size or 50
  -- return true if vector distance between the center of the player
  -- and the cursor is less then or equal to the player radius
  local x = (love.mouse.getX() - Camera.x) / Camera.zoom
  local y = (love.mouse.getY() - Camera.y) / Camera.zoom
  return vectorDist(centerpoint.x, centerpoint.y, x, y) <= radius
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

function clamp(value, min, max)
  if max then
    return math.max(min, math.min(max, value))
  else
    return math.max(value, min)
  end
end

function getRelativeCursor()
  local x = (love.mouse.getX() - Camera.x) / Camera.zoom
  local y = (love.mouse.getY() - Camera.y) / Camera.zoom
  return x, y
end

function sign(val)
  if val > 0 then
    return 1
  elseif val < 0 then
    return -1
  else
    return 0
  end
end

function rgb( ... )
  local r, g, b = ...
  if not g then
    local hex = r:gsub("#", "")
    r = tonumber(hex:sub(1, 2), 16)
    g = tonumber(hex:sub(3, 4), 16)
    b = tonumber(hex:sub(5, 6), 16)
  end
  return r / 255, g / 255, b / 255
end



function lineIntersectsLine( x1, y1, x2, y2, x3, y3, x4, y4 )
  local den = ( x1 - x2 ) * ( y3 - y4 ) - ( y1 - y2 ) * ( x3 - x4 )
  if den == 0 then
    return false
  end
  local t = ( ( x1 - x3 ) * ( y3 - y4 ) - ( y1 - y3 ) * ( x3 - x4 ) ) / den
  local u = - ( ( x1 - x2 ) * ( y1 - y3 ) - ( y1 - y2 ) * ( x1 - x3 ) ) / den
  return t >= 0 and t <= 1 and u >= 0 and u <= 1
  
end
