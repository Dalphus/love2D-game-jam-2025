require( "Units.Ally" )
require( "Scenes.LevelLoader" )

Lad = {}
Lad.__index = Lad
setmetatable(Lad, Ally)

function Lad:new(...)
  local lad = Ally:new(...)
  lad.rotation_speed = 10
  --lad.AbilityA = "Shoot"
  --lad.AbilityB = "Distract"
  lad.portrait = Loader.images.portraits.soldier
  setmetatable(lad, self)
  lad.name = "Operative"
  lad.speed = 200
  return lad
end

function Lad:draw()
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
  if TurnEndFlag then
    if self.AbilityAIndex == 1 then -- Shoot

    elseif self.AbilityBIndex == 1 then -- Distract
    
    elseif self.movement_nodes[1] then
      -- rotates Operative to face movement node
      local x1, y1 = self.x, self.y
      local x2, y2 = self.movement_nodes[ 1 ].x, self.movement_nodes[ 1 ].y
      local angle_diff = math.atan2(( y2 - y1 ), ( x2 - x1 )) - self.rotation
      angle_diff = ( angle_diff + math.pi ) % ( 2 * math.pi ) - math.pi
      self.rotation = self.rotation + dt * self.rotation_speed * sign( angle_diff )
      self.rotation = self.rotation % ( 2 * math.pi )

      if self.movement_nodes[2] then
        while self.movement_nodes[2] and vectorDist(self.x, self.y, self.movement_nodes[1].x, self.movement_nodes[1].y) <= (self.size * 1.1)  do
          table.remove(self.movement_nodes, 1)
          self.AbilityAIndex = self.AbilityAIndex - 1
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
end