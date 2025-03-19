Walls = {}

function Walls:load()
  -- Scene1 is 2000x800
  table.insert( self, { x = 250, y = 350, width = 50, height = 320 } )
  table.insert( self, { x = 600, y = 5, width = 50, height = 160 } )
  table.insert( self, { x = 600, y = 300, width = 900, height = 50 } )
  table.insert( self, { x = 500, y = 490, width = 200, height = 50 } )
  table.insert( self, { x = 1700, y = 150, width = 50, height = 500 } )
end

function Walls:draw()
  for i = 1, #self, 1 do
    local wall = self[i]
    love.graphics.setColor( 255, 255, 255 )
    love.graphics.rectangle( "fill", wall.x, wall.y, wall.width, wall.height )
  end
end
