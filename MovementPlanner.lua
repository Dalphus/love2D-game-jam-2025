MovementPlanner = {}

-- draw ghost x, y
-- draw path
-- keep track of time based checkpoint ghosts
-- update movement nodes array
--

-- put ghost drawing into unit class
-- put movement node updating into unit class
-- put movement node undoing into unit class
-- put movement node checking into unit class
-- put movement node drawing into unit class

function MovementPlanner:load( player )
  
  self.shadow = {
    x = player.x,
    y = player.y,
    rotation = player.rotation
  }

end

function MovementPlanner:draw()
  local x1, y1 = getRelativeCursor()
  local x2, y2 = Players[ active_player ]:getLastNodePos()
  if Players[ active_player ]:isValidMovementNode( x1, y1 ) then
    love.graphics.setColor( 1, 1, 1 )
  else
    love.graphics.setColor( 1, 0, 0 )
  end
  love.graphics.circle( "line", x1, y1, Players[ active_player ].size, 50 )
  love.graphics.line( x1, y1, x2, y2 )
end

function MovementPlanner:update()
  local player = Players[ active_player ]

  local speed = 0

  -- update player
  if love.keyboard.isDown("w") then
    speed = player.speed
  else
    speed = 0
  end

  -- move player

  -- add node
  if (speed > 0) and (vectorDist(player.x, player.y, player.shadowx, player.shadowy) > player.size) then
    if player.rate_limit_tally == 0 then
      player:addMovementNode(player.shadowx, player.shadowy)
    elseif (player.rate_limit_tally == 60) then
      player.rate_limit_tally = 0
    else
      player.rate_limit_tally = player.rate_limit_tally + 1
    end
  else
    player.rate_limit_tally = 0
  end
end
