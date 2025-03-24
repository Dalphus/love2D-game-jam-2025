require("Units.Enemy")
require( "Scenes.LevelLoader" )

Turret = {}
Turret.__index = Turret
setmetatable(Turret, Enemy)

local RELOAD_TIMER = 0.25

function Turret:new(_x, _y, _size, _rotation, _speed, _health, _fov, _sight_dist)
  local turret = Enemy:new(_x, _y, _size, _rotation, _speed, _health, _fov, _sight_dist)
  turret.portrait = Loader.images.portraits.turret
  turret.bullets = {}
  turret.name = "Turret"
  turret.firing = false
  turret.reload = RELOAD_TIMER
  setmetatable(turret, self)
  return turret
end

function Turret:update(dt)
  if not TurnEndFlag then return end
  
  -- Move Bullets
  for i=#self.bullets,1,-1 do 
    if self.bullets[i].needs_cleanup then
      table.remove(self.bullets, i)
    end
  end
  for _, bullet in pairs( self.bullets ) do 
    bullet:update(dt)
  end
  
  -- Rotate Self
  local closest = nil
  local closestDist = self.sight_dist
  for i, player in pairs( players ) do
    local dist = vectorDist(self.x, self.y, player.x, player.y)
    if dist < closestDist then
      closestDist = dist
      closest = player
    end
    if closest then
      if math.abs(self:angleDiff(closest.x, closest.y)) <= self.fov/2 then 
        self:face(closest.x, closest.y, dt)
        if closestDist < (0.8 * self.sight_dist) then
          self:shoot(dt)
          self.firing = true
        else 
          self.firing = false
        end
      end
    end
  end
end

function Turret:draw()
  -- Draw Bullets
  for _, bullet in pairs( self.bullets ) do
    bullet:draw()
  end

  -- Draw Self
  love.graphics.setColor(1, 1, 1)
  local sprite_transform_head = love.math.newTransform(self.x , self.y, self.rotation, self.size/50, self.size/50, (self.size) * 3/2, (self.size) * 3/2 + 10)
  love.graphics.draw(Loader.images.units.turret_head, sprite_transform_head)
  love.graphics.setColor(1, 0, 0)
  local x2 = math.cos(self.rotation) * self.size
  local y2 = math.sin(self.rotation) * self.size
  local x3 = math.cos(self.rotation - (self.fov/2)) * self.sight_dist
  local y3 = math.sin(self.rotation - (self.fov/2)) * self.sight_dist
  local x4 = math.cos(self.rotation + (self.fov/2)) * self.sight_dist
  local y4 = math.sin(self.rotation + (self.fov/2)) * self.sight_dist
  love.graphics.line(self.x, self.y, self.x + x3, self.y + y3)
  love.graphics.line(self.x, self.y, self.x + x4, self.y + y4)
  love.graphics.setColor(1, 1, 1)
  love.graphics.line(self.x, self.y, self.x + x2, self.y + y2)
end

function Turret:shoot(dt)
  if self.reload <= 0 then
    table.insert(self.bullets, Bullet:new(self.x, self.y, 5, 700, self.rotation, self))
    self.reload = RELOAD_TIMER
  else
    self.reload = self.reload - dt
  end
end

function Turret:face(x2, y2, dt)
  local x1, y1 = self.x, self.y
  local angle_diff = math.atan2(( y2 - y1 ), ( x2 - x1 )) - self.rotation
  angle_diff = ( angle_diff + math.pi ) % ( 2 * math.pi ) - math.pi
  local rts = self.firing and (self.rotation_speed*0.2) or self.rotation_speed
  self.rotation = self.rotation + dt * rts * sign( angle_diff )
  self.rotation = self.rotation % ( 2 * math.pi )
end