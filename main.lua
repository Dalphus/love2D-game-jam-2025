-- the debugger causes a lot of lag, so we only want to load it when debugging
if arg[2] == "vsc_debug" then
  require("lldebugger").start()
end

function love.load()
  print("Hello World!")

  -- set up the window
  love.window.setMode(800, 600, {resizable = true, vsync = false})
  love.graphics.setBackgroundColor(0, 0, 0)
  love.graphics.setColor(255, 255, 255)

  -- set up some game variables
  player = {x = 400, y = 300, rotation = 0, speed = 0, fire_timer = 0}
  projectiles = {}
  -- set up some game constants
  top_speed = 400
  acceleration = 200
  fire_delay = 0.1
  rotation_speed = 2.5
  player_size = 30
end

function love.draw()
  -- draw player
  love.graphics.circle("fill", player.x, player.y, player_size, 50)
  -- draw player pointer
  local x2 = math.cos(player.rotation) * player_size
  local y2 = math.sin(player.rotation) * player_size
  love.graphics.setColor(0, 0, 0)
  love.graphics.line(player.x, player.y, player.x + x2, player.y + y2)
  love.graphics.setColor(255, 255, 255)
  -- draw projectiles
  for _, projectile in pairs(projectiles) do
    love.graphics.circle("fill", projectile.x, projectile.y, 5, 10)
  end
end

function love.update(dt)
  -- update player
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
  player.x = (player.x + player_size) % (love.graphics.getWidth() + player_size * 2) - player_size
  player.y = (player.y + player_size) % (love.graphics.getHeight() + player_size * 2) - player_size

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
