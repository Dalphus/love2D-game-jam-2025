-- load all images
-- read wall data and generate position matrix
-- iterate through matrix and update distance from wall field
-- generat canvas with wall data

Scene = {}

function Scene:load()
  self.width = 40 -- 2000 / 50
  self.height = 16 -- 800 / 50
  self.walls = temporaryWallInserter()
  self.background = love.graphics.newCanvas( self.width * 50, self.height * 50 )

  local tile_map = {}
  for i = 1, self.width do
    tile_map[i] = {}
    for j = 1, self.height do
      tile_map[i][j] = 0
    end
  end

  for _, wall in ipairs( self.walls ) do
    for i = wall.x + 1, wall.x + wall.width do
      for j = wall.y + 1, wall.y + wall.height do
        tile_map[i][j] = -1
      end
    end
    wall.x = wall.x * 50
    wall.y = wall.y * 50
    wall.width = wall.width * 50
    wall.height = wall.height * 50
  end

  -- load images into sprite sheet
  local wall1 = love.graphics.newImage( "Assets/wall1.png" )
  local blanck1 = love.graphics.newImage( "Assets/blank1.png" )

  -- print tiles onto canvas
  love.graphics.setCanvas( self.background )
  love.graphics.clear()
  love.graphics.setColor( 1, 1, 1 )
  for i = 1, self.width do
    for j = 1, self.height do
      if tile_map[i][j] == -1 then
        love.graphics.draw( wall1, (i - 1) * 50, (j - 1) * 50, 0, 0.5, 0.5 )
      else
        love.graphics.draw( blanck1, (i - 1) * 50, (j - 1) * 50, 0, 0.5, 0.5 )
      end
    end
  end

  love.graphics.setCanvas()
  self.background:newImageData():encode("png", "background.png")
  self.width = self.width * 50
  self.height = self.height * 50
end
Scene = {}

function Scene:new()
  local scene = {}
  setmetatable(scene, self)
  return scene
end

-- function Scene:load()
--   print("Called abstract function")
-- end

function Scene:draw()
  print("Called abstract function")
end
