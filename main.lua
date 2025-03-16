-- the debugger causes a lot of lag, so we only want to load it when debugging
if arg[ 2 ] == "vsc_debug" then
  require( "lldebugger" ).start()
end

require( "helpers" )
require( "Units.Dummy" )
require( "Units.Dummy" )
require( "Camera" )


function love.load()
  -- Unit Globals
  players = {
    ["Francis"] = Dummy:new( 400, 200, 30 ),
    ["Geraldo"] = Dummy:new( 100, 100, 50 )
  }
  active_player = "Francis"
  top_speed = 200
  rotation_speed = 2.5
  acceleration = 100
  fire_delay = 0.2

  -- Scene Globals
  scene = { width = 2000, height = 800 }
  
  -- set up the window
  love.window.setMode( 1000, 1000, { resizable = true, vsync = false })
  love.graphics.setBackgroundColor( 0, 0, 0 )
  love.graphics.setColor( 255, 255, 255 )

  -- make the mouse visible
  love.mouse.setVisible(true)

end

function love.mousepressed( mouseX, mouseY, button )
  if button == 1 then
    for i, player in pairs( players ) do
      if mouseInRadius( player ) then
        active_player = i
        Camera:grabUIofUnit(active_player)
        break
      end
    end
  end
end

function love.mousemoved( mouseX, mouseY, dx, dy )
  local total_width = scene.width * Camera.zoom
  local total_height = scene.height * Camera.zoom

  if love.mouse.isDown( 2 ) then
    if love.graphics.getWidth() - total_width - 100 < 0 then
      Camera.x = clamp( Camera.x + dx, love.graphics.getWidth() - total_width - 50, 50 )
    else
      Camera.x = clamp( Camera.x + dx, 50, love.graphics.getWidth() - total_width - 50 )
    end
    if love.graphics.getHeight() - total_height - 100 < 0 then
      Camera.y = clamp( Camera.y + dy, love.graphics.getHeight() - total_height - 50, 50 )
    else
      Camera.y = clamp( Camera.y + dy, 50, love.graphics.getHeight() - total_height - 50 )
    end
  end
end

function love.wheelmoved( x, y )
  local old_zoom = Camera.zoom
  Camera.zoom = Camera.zoom + y * 0.05
  Camera.zoom = math.max(Camera.min_zoom, Camera.zoom)
  Camera.zoom = math.min(Camera.max_zoom, Camera.zoom)

  -- I generated this algorithm with Wolphram Alpha, don't ask me how it works
  local mouse_x, mouse_y = love.mouse.getPosition()
  Camera.x = (Camera.zoom / old_zoom) * (Camera.x - mouse_x) + mouse_x
  Camera.y = (Camera.zoom / old_zoom) * (Camera.y - mouse_y) + mouse_y
end

function love.draw()
  local canvas = love.graphics.newCanvas( scene.width, scene.height )
  love.graphics.setCanvas( canvas )

  -- draw players
  for _, player in pairs( players ) do
    player:draw()
  end

  love.graphics.setColor(255, 255, 255)
  love.graphics.setCanvas()
  love.graphics.draw( canvas, Camera.x, Camera.y, 0, Camera.zoom, Camera.zoom )
  love.graphics.setColor( 255, 255, 255 )
  love.graphics.rectangle( "line", Camera.x, Camera.y, scene.width * Camera.zoom, scene.height * Camera.zoom )

  Camera:drawUnitUI()
  Camera:drawEndTurn()  
end

function love.update( dt )
  -- update player
  local player = players[ active_player ]

  if love.keyboard.isScancodeDown( "escape" ) then
    love.event.quit()
  end
  
  if love.keyboard.isDown( "w" ) or love.keyboard.isDown( "up" ) then
    player.speed = player.speed < top_speed and ( player.speed + acceleration * dt ) or top_speed
  else
    player.speed = player.speed > 0 and ( player.speed - acceleration * dt * 0.5 ) or 0
  end

  if love.keyboard.isDown( "a" ) or love.keyboard.isDown( "left" ) then
    player.rotation = player.rotation - dt * rotation_speed
  elseif love.keyboard.isDown( "d" ) or love.keyboard.isDown( "right" ) then
    player.rotation = player.rotation + dt * rotation_speed
  end

  -- move player
  player.x = player.x + math.cos( player.rotation ) * dt * player.speed
  player.y = player.y + math.sin( player.rotation ) * dt * player.speed

  -- keep player on screen
  player.x = ( player.x + player.size ) % ( scene.width + player.size * 2 ) - player.size
  player.y = ( player.y + player.size ) % ( scene.height + player.size * 2 ) - player.size

end

-- Love catches errors to show the nice error screen,
-- but we want the program to actually throw an error when one occurs
local love_errorhandler = love.errorhandler
function love.errorhandler( msg )
    if lldebugger then
        error( msg, 2 )
    else
        return love_errorhandler( msg )
    end
end
