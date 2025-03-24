require( "Units.Ally" )
require( "Scenes.LevelLoader" )

Lad = {}
Lad.__index = Lad
setmetatable(Lad, Ally)

SHOOT_COOLDOWN = 0.5

function Lad:new(...)
  local lad = Ally:new(...)
  lad.rotation_speed = 10
  lad.AbilityA = "Shoot"
  lad.AbilityAIndex = {}
  --lad.AbilityB = "Distract"
  lad.AbilityBIndex = 0
  lad.portrait = Loader.images.portraits.soldier
  setmetatable(lad, self)
  lad.name = "Operative"
  lad.speed = 200
  lad.bullets = {}
  lad.cooldown = 0
  return lad
end

function Lad:draw()
    -- Draw Bullets
    for _, bullet in pairs( self.bullets ) do
      bullet:draw()
    end

  if mouseInRadius(self, self.size) then
    love.graphics.setColor( 1, 0, 0 )
  else
    love.graphics.setColor( 1, 1, 1 )
  end
  love.graphics.circle("fill", self.x, self.y, self.size, 50)
  local x2 = math.cos(self.rotation) * self.size
  local y2 = math.sin(self.rotation) * self.size
  love.graphics.setColor(0, 0, 0)
  love.graphics.line(self.x, self.y, self.x + x2, self.y + y2)

  if next(self.movement_nodes) then
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.line(self.x, self.y, self.movement_nodes[1].x, self.movement_nodes[1].y)
    for i = 1, #self.movement_nodes - 1 do
      local x1, y1 = self.movement_nodes[i].x, self.movement_nodes[i].y
      local x2, y2 = self.movement_nodes[i + 1].x, self.movement_nodes[i + 1].y
      love.graphics.line(x1, y1, x2, y2)
    end
    if not love.keyboard.isDown("space") then
      love.graphics.setColor( 1, 1, 1 )
      local x, y = self.movement_nodes[ #self.movement_nodes ].x, self.movement_nodes[ #self.movement_nodes ].y
      love.graphics.circle("line", x, y, self.size, 50)
    end
  end
end

function Lad:update( dt )
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

  if self.AbilityAIndex[1] == 1 then -- Shoot
    table.insert(self.bullets, Bullet:new(self.x, self.y, 5, 700, self.rotation, self))
    table.remove(self.AbilityAIndex, 1)
    self.cooldown = SHOOT_COOLDOWN
  elseif self.AbilityBIndex == 1 then -- Distract
  
  elseif self.movement_nodes[1] then
    -- rotates Operative to face movement node
    if self.cooldown > 0 then
      self.cooldown = self.cooldown - dt
      return
    end
    local x1, y1 = self.x, self.y
    local x2, y2 = self.movement_nodes[ 1 ].x, self.movement_nodes[ 1 ].y
    local angle_diff = math.atan2(( y2 - y1 ), ( x2 - x1 )) - self.rotation
    angle_diff = ( angle_diff + math.pi ) % ( 2 * math.pi ) - math.pi
    self.rotation = self.rotation + dt * self.rotation_speed * sign( angle_diff )
    self.rotation = self.rotation % ( 2 * math.pi )

    if self.movement_nodes[2] then
      while self.movement_nodes[2] and vectorDist(self.x, self.y, self.movement_nodes[1].x, self.movement_nodes[1].y) <= (self.size * 1.1)  do
        if self.AbilityAIndex[1] == 1 then break end
        table.remove(self.movement_nodes, 1)
        for i = 1,#self.AbilityAIndex do
          self.AbilityAIndex[i] = self.AbilityAIndex[i] - 1
        end
        self.AbilityBIndex = self.AbilityBIndex - 1
      end
    else
      if vectorDist(self.x, self.y, self.shadowx, self.shadowy) <= (self.size * 0.05) then
        self.movement_nodes = {}
      end
    end

    -- move operative
    self.x = self.x + math.cos( self.rotation ) * dt * self.speed
    self.y = self.y + math.sin( self.rotation ) * dt * self.speed
  else 
    self.x = self.shadowx
    self.y = self.shadowy
  end
end

function Lad:AbilityAFunction()
  self.time_budget = self.time_budget - (100 * (SHOOT_COOLDOWN)/TurnTime)
  self:addMovementNode(self.shadowx, self.shadowy)
  table.insert(self.AbilityAIndex, #self.movement_nodes)
end