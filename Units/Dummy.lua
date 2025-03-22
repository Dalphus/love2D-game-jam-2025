require("Units.Ally")
require( "Particles.ParticleGenerator" )


Dummy = {}
Dummy.__index = Dummy
setmetatable(Dummy, Ally)

CHARGE_TIME = 1
CHARGE_PREP_TIME = 1
CHARGE_SPEED = 500

function Dummy:new(...)
  local dummy = Ally:new(...)
  dummy.rotation_speed = 10
  dummy.AbilityA = "Charge"
  dummy.AbilityAIndex = 0
  dummy.AbilityATime = 0
  dummy.AbilityB = "Stun"
  dummy.AbilityBIndex = 0
  setmetatable(dummy, self)
  dummy.name = "Dummy"
  dummy.speed = 200
  return dummy
end

function Dummy:draw()
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

function Dummy:update( dt )
  if TurnEndFlag then
    if self.AbilityAIndex == 1 then -- Charge
      if self.AbilityATime > CHARGE_PREP_TIME then
      elseif self.AbilityATime > 0 then
        local x1, y1 = self.x, self.y
        local x2, y2 = self.movement_nodes[ 1 ].x, self.movement_nodes[ 1 ].y
        local angle_diff = math.atan2(( y2 - y1 ), ( x2 - x1 )) - self.rotation
        angle_diff = ( angle_diff + math.pi ) % ( 2 * math.pi ) - math.pi
        self.rotation = self.rotation + dt * self.rotation_speed * sign( angle_diff )
        self.rotation = self.rotation % ( 2 * math.pi )

        -- move dummy
        self.x = self.x + math.cos( self.rotation ) * dt * CHARGE_SPEED
        self.y = self.y + math.sin( self.rotation ) * dt * CHARGE_SPEED
      else
        self.AbilityAIndex = 0
      end
      self.AbilityATime = self.AbilityATime - dt
    elseif self.AbilityBIndex == 1 then -- Stun
    
    elseif self.movement_nodes[1] then
      -- rotates Dummy to face movement node
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

      -- move dummy
      self.x = self.x + math.cos( self.rotation ) * dt * self.speed
      self.y = self.y + math.sin( self.rotation ) * dt * self.speed
    else 
      self.x = self.shadowx
      self.y = self.shadowy
    end
  end
end

function Dummy:AbilityAFunction()
  if self.time_budget > (CHARGE_PREP_TIME + CHARGE_TIME)/TurnTime then
      -- move self
    self.shadowx = self.shadowx + math.cos(self.rotation) * CHARGE_TIME * CHARGE_SPEED
    self.shadowy = self.shadowy + math.sin(self.rotation) * CHARGE_TIME * CHARGE_SPEED
    
    self.time_budget = self.time_budget - 50
    self:addMovementNode(self.shadowx, self.shadowy)
    self.AbilityAIndex = #self.movement_nodes
    self.AbilityATime = 2
  end
end
