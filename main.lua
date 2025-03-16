-- the debugger causes a lot of lag, so we only want to load it when debugging
if arg[ 2 ] == "vsc_debug" then
  require( "lldebugger" ).start()
end

require( "helpers" )
require( "Dummy" )
require( "Camera" )


function love.load()
  -- Unit Globals
  projectiles = {}
  players = {}
  players[ 1 ] = Dummy:new( nil, 400, 200, 30 )
  players[ 2 ] = Dummy:new( nil, 100, 100, 50 )
  active_player = 1
  top_speed = 200
  rotation_speed = 2.5
  acceleration = 100
  fire_delay = 0.2

  -- Scene Globals
  scene = { width = 800, height = 800 }
  
  -- set up the window
  love.window.setMode( 2000, 1100, { resizable = true, vsync = false })
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
        break
      end
    end
  end
end

function love.mousemoved( mouseX, mouseY, dx, dy )
  if love.mouse.isDown( 2 ) then
    Camera.x = Camera.x + dx
    Camera.y = Camera.y + dy
  end
end

function love.wheelmoved( x, y )
  Camera.zoom = Camera.zoom + y * 0.05
  Camera.zoom = math.max( Camera.min_zoom, Camera.zoom )
  Camera.zoom = math.min( Camera.max_zoom, Camera.zoom )
end

function love.draw()
  local canvas = love.graphics.newCanvas( scene.width, scene.height )
  love.graphics.setCanvas( canvas )

  -- draw players
  for _, player in pairs( players ) do
    local x = player.x
    local y = player.y
    if mouseInRadius( player ) then
      love.graphics.setColor( 255, 0, 0 )
    else
      love.graphics.setColor( 255, 255, 255 )
    end
    love.graphics.circle( "fill", x, y, player.size, 50 )
    local x2 = math.cos( player.rotation ) * player.size
    local y2 = math.sin( player.rotation ) * player.size
    love.graphics.setColor( 0, 0, 0 )
    love.graphics.line( x, y, x + x2, y + y2 )
  end

  -- draw projectiles
  love.graphics.setColor( 255, 255, 255 )
  for _, projectile in pairs( projectiles ) do
    love.graphics.circle( "fill", projectile.x, projectile.y, 5, 10 )
  end

  love.graphics.setCanvas()
  love.graphics.draw( canvas, Camera.x, Camera.y, 0, Camera.zoom, Camera.zoom )
  love.graphics.setColor( 255, 255, 255 )
  love.graphics.rectangle( "line", Camera.x, Camera.y, scene.width * Camera.zoom, scene.height * Camera.zoom )

end

function love.update( dt )
  -- update player
  local player = players[ active_player ]

  if love.keyboard.isDown( "escape" ) then
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

  -- fire projectile
  player.fire_timer = player.fire_timer - dt
  if love.keyboard.isDown( "space" ) and player.fire_timer <= 0 then
    table.insert( projectiles, { x = player.x, y = player.y, rotation = player.rotation })
    player.fire_timer = fire_delay
  end

  -- update projectiles
  for i, projectile in pairs( projectiles ) do
    -- remove projectile if it goes off screen
    if projectile.x < 0 or projectile.x > love.graphics.getWidth() or
       projectile.y < 0 or projectile.y > love.graphics.getHeight() then
        table.remove( projectiles, i )
    else
      -- move projectile
      projectile.x = projectile.x + math.cos( projectile.rotation ) * dt * 1000
      projectile.y = projectile.y + math.sin( projectile.rotation ) * dt * 1000
    end
  end
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
