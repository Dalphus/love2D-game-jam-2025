
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
  love.graphics.setColor( 1, 1, 1 )
  love.graphics.rectangle( "fill", self.x, self.y, self.width, self.height )
end

function Wall:collides( x1, y1, x2, y2, radius )
  radius = radius or 0
  local x3, y3 = self.x - radius, self.y - radius
  local x4, y4 = self.x + self.width + radius, self.y + self.height + radius
  -- each wall has 4 faces, so do 4 line intersection checks
  return lineIntersectsLine( x1, y1, x2, y2, x3, y3, x4, y3 ) or
         lineIntersectsLine( x1, y1, x2, y2, x3, y3, x3, y4 ) or
         lineIntersectsLine( x1, y1, x2, y2, x4, y3, x4, y4 ) or
         lineIntersectsLine( x1, y1, x2, y2, x3, y4, x4, y4 )
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
