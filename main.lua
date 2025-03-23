-- the debugger causes a lot of lag, so we only want to load it when debugging
if arg[ 2 ] == "vsc_debug" then
  require( "lldebugger" ).start()
end

require( "helpers" )
require( "Units.Dummy" )
require( "Units.Stinky" )
require( "Units.Turret" )
require( "Units.Patrol" )
require( "Camera" )
require( "Scenes.LevelLoader" )
require( "Walls" )
require( "Scenes.LevelData" )

function love.load()
  -- Unit Globals
  players = {}
  players[ "Francis" ] = Dummy:new( 400, 200, 30 )
  players[ "Geraldo" ] = Stinky:new( 100, 100, 50 )
  active_player = "Francis"
  enemies = { 
    Turret:new(500, 500, 25, -math.pi/2, 0, 3, math.pi/2, 500),
    Patrol:new(600, 600, 15, -math.pi/2, 0, 3, math.pi/2, 300)
  }
  
  -- Scene Globals
  Scene = Loader:addScene( LevelOne, "LevelOne" )

  -- Set up enemy paths
  enemies[2]:addMovementNode(600, 600)
  enemies[2]:addMovementNode(600, 700)
  enemies[2]:addMovementNode(700, 700)
  enemies[2]:addMovementNode(700, 600)

  -- Set up the window
  love.window.setMode( 1000, 1000, { resizable = true, vsync = false })
  love.graphics.setBackgroundColor( 0, 0, 0 )
  
  love.mouse.setVisible(true)

  TurnEndFlag = false
  TurnTime = 4

  -- set default font
  love.graphics.setFont(love.graphics.newFont(50))

end

function love.mousepressed( mouseX, mouseY, button )
  if button == 1 then
    if love.keyboard.isDown( "space" ) then
      players[ active_player ]:addMovementNode( getRelativeCursor() )
    else
      for i, player in pairs( players ) do
        if mouseInRadius( player ) then
          active_player = i
          Camera:grabUIofUnit(active_player)
          break
        end
      end
    end
  elseif button == 2 then
    if love.keyboard.isDown( "space" ) and TurnEndFlag then
      players[ active_player ]:undoMovementNodes()
    end
  end

  Camera:buttonEvents()
end

function love.mousemoved( mouseX, mouseY, dx, dy, force )
  local total_width = Scene.width * Camera.zoom
  local total_height = Scene.height * Camera.zoom

  if love.mouse.isDown( 2 ) or force then
    if love.graphics.getWidth() - total_width - Camera.margin * 2 < 0 then
      Camera.x = clamp( Camera.x + dx, love.graphics.getWidth() - total_width - Camera.margin, Camera.margin )
    else
      Camera.x = clamp( Camera.x + dx, Camera.margin, love.graphics.getWidth() - total_width - Camera.margin )
    end
    if love.graphics.getHeight() - total_height - Camera.margin * 2 < 0 then
      Camera.y = clamp( Camera.y + dy, love.graphics.getHeight() - total_height - Camera.margin, Camera.margin )
    else
      Camera.y = clamp( Camera.y + dy, Camera.margin, love.graphics.getHeight() - total_height - Camera.margin )
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
  love.mousemoved( mouse_x, mouse_y, 0, 0, true )
end

function love.draw()
  local canvas = love.graphics.newCanvas( Scene.width, Scene.height, { format = "rgba8" } )
  love.graphics.setCanvas( canvas )
  -- LevelLoader:draw()
  -- draw players
  for _, player in pairs( players ) do 
    player:draw()
  end
  players[ active_player ]:shadowDraw()
  for _, enemy in pairs( enemies ) do
    enemy:draw()
  end

  -- -- draw walls
  -- for _, wall in ipairs( Scene.walls ) do
  --   wall:draw()
  -- end

  -- movement preview
  if love.keyboard.isDown( "space" ) then
    local x1, y1 = getRelativeCursor()
    local x2, y2 = players[ active_player ]:getLastNodePos()
    if players[ active_player ]:isValidMovementNode( x1, y1 ) then
      love.graphics.setColor( 1, 1, 1 )
    else
      love.graphics.setColor( 1, 0, 0 )
    end
    love.graphics.circle( "line", x1, y1, players[ active_player ].size, 50 )
    love.graphics.line( x1, y1, x2, y2 )
  end

  love.graphics.setCanvas()
  love.graphics.setColor( 1, 1, 1 )
  local cam_transform = love.math.newTransform( Camera.x, Camera.y, 0, Camera.zoom, Camera.zoom )
  love.graphics.draw( Scene.background, cam_transform )
  love.graphics.draw( canvas, cam_transform )
  love.graphics.rectangle( "line", Camera.x, Camera.y, Scene.width * Camera.zoom, Scene.height * Camera.zoom )
  Camera:renderUI()
end

function love.update( dt )

  if love.keyboard.isScancodeDown( "escape" ) then
    love.event.quit()
  end
  -- update player
  for _, player in pairs( players ) do
    player:update( dt )
  end

  players[ active_player ]:shadowUpdate( dt )  

  -- update enemies
  for _, enemy in pairs( enemies ) do
    enemy:update(dt)
  end

  Camera:buttonCooling(dt)
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
