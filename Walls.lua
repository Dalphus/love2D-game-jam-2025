
Wall = {}
Wall.__index = Wall

function Wall:new( _x, _y, _width, _height )
  local wall = {}
  setmetatable( wall, self )
  wall.x = _x
  wall.y = _y
  wall.width = _width
  wall.height = _height
  return wall
end

function Wall:draw()
  love.graphics.setColor( 255, 255, 255 )
  love.graphics.rectangle( "fill", self.x, self.y, self.width, self.height )
end

function Wall:collides( x1, y1, x2, y2 )
  local x3, y3, x4, y4 = self.x, self.y, self.x + self.width, self.y
  local x5, y5, x6, y6 = self.x, self.y + self.height, self.x + self.width, self.y + self.height
  -- each wall has 4 faces, so do 4 line intersection checks
  return lineIntersectsLine( x1, y1, x2, y2, x3, y3, x4, y4 ) or
         lineIntersectsLine( x1, y1, x2, y2, x4, y4, x6, y6 ) or
         lineIntersectsLine( x1, y1, x2, y2, x6, y6, x5, y5 ) or
         lineIntersectsLine( x1, y1, x2, y2, x5, y5, x3, y3 )
end

function temporaryWallInserter()
  -- Scene1 is 2000x800
  local walls = {
    --------- x     y    width  height
    Wall:new( 250,  350, 50,    320 ),
    Wall:new( 600,  5,   50,    160 ),
    Wall:new( 600,  300, 900,   50 ),
    Wall:new( 500,  490, 200,   50 ),
    Wall:new( 1700, 150, 50,    500 ),
  }

  return walls
end
