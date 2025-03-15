-- the debugger causes a lot of lag, so we only want to load it when debugging
if arg[2] == "vsc_debug" then
  require("lldebugger").start()
end

require("helpers")
require("Dummy")


function love.load()
  -- Unit Globals
  projectiles = {}
  players = {}
  players[1] = Dummy:new(400, 200, 30)
  players[2] = Dummy:new(100, 100, 50)
  active_player = 1
  top_speed = 200
  rotation_speed = 2.5
  acceleration = 100
  fire_delay = 0.2

  -- Camera Globals
  camera = {x = 0, y = 0, zoom = 1, min_zoom = 0.5, max_zoom = 10}

  -- Scene Globals
  scene = {width = 800, height = 800}
  
  -- set up the window
  love.window.setMode(3000, 1500, {resizable = true, vsync = false})
  love.graphics.setBackgroundColor(0, 0, 0)
  love.graphics.setColor(255, 255, 255)

  -- make the mouse visible
  love.mouse.setVisible(true)

end

function love.mousepressed( mouseX, mouseY, button, istouch )
  if button == 1 then
    for i = 1, #players, 1 do
      if (mouseInRadius(players[i], players[i].size)) then
        active_player = i
        break
      end
    end
  end
end

function love.mousemoved( mouseX, mouseY, dx, dy )
  if love.mouse.isDown(2) then
    camera.x = camera.x - dx
    camera.y = camera.y - dy
  end
end

function love.wheelmoved( x, y )
  camera.zoom = camera.zoom + y * 0.05
  camera.zoom = math.max(camera.min_zoom, camera.zoom)
  camera.zoom = math.min(camera.max_zoom, camera.zoom)
end

function love.draw()
  -- draw bounding box for scene
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", 0 - camera.x, 0 - camera.y, scene.width * camera.zoom, scene.height * camera.zoom)


  -- draw players
  for _, player in pairs(players) do
    -- calculate camera offset
    local x = player.x * camera.zoom - camera.x
    local y = player.y * camera.zoom - camera.y
    local size = player.size * camera.zoom
    love.graphics.circle("fill", x, y, size, 50)
    local x2 = math.cos(player.rotation) * size
    local y2 = math.sin(player.rotation) * size
    love.graphics.setColor(0, 0, 0)
    love.graphics.line(x, y, x + x2, y + y2)
    love.graphics.setColor(255, 255, 255)
  end

  -- draw projectiles
  for _, projectile in pairs(projectiles) do
    love.graphics.circle("fill", projectile.x, projectile.y, 5, 10)
  end
end

function love.update(dt)
  -- update player
  local player = players[active_player]
  
  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
    player.speed = player.speed < top_speed and (player.speed + acceleration * dt) or top_speed
  else
    player.speed = player.speed > 0 and (player.speed - acceleration * dt * 0.5) or 0
  end

  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    player.rotation = player.rotation - dt * rotation_speed
  elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    player.rotation = player.rotation + dt * rotation_speed
  end

  -- move player
  player.x = player.x + math.cos(player.rotation) * dt * player.speed
  player.y = player.y + math.sin(player.rotation) * dt * player.speed

  -- keep player on screen
  player.x = (player.x + player.size) % (love.graphics.getWidth() + player.size * 2) - player.size
  player.y = (player.y + player.size) % (love.graphics.getHeight() + player.size * 2) - player.size

  -- fire projectile
  player.fire_timer = player.fire_timer - dt
  if love.keyboard.isDown("space") and player.fire_timer <= 0 then
    table.insert(projectiles, {x = player.x, y = player.y, rotation = player.rotation})
    player.fire_timer = fire_delay
  end

  -- update projectiles
  for i, projectile in pairs(projectiles) do
    -- remove projectile if it goes off screen
    if projectile.x < 0 or projectile.x > love.graphics.getWidth() or
       projectile.y < 0 or projectile.y > love.graphics.getHeight() then
        table.remove(projectiles, i)
    else
      -- move projectile
      projectile.x = projectile.x + math.cos(projectile.rotation) * dt * 1000
      projectile.y = projectile.y + math.sin(projectile.rotation) * dt * 1000
    end
  end
end

-- Love catches errors to show the nice error screen,
-- but we want the program to actually throw an error when one occurs
local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
