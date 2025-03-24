Loader = {
  scenes = {},

  -- there's probably a better place to put the sprites, but it lives here for now
  images = {
    tiles = {
      wall1   = love.graphics.newImage( "Assets/wall1.png"   ),
      blanck1 = love.graphics.newImage( "Assets/blank1.png"  ),
    },
    portraits = {
      tank    = love.graphics.newImage( "Assets/big guy.png" ),
      turret  = love.graphics.newImage( "Assets/gun.png"     ),
      soldier = love.graphics.newImage( "Assets/shroomo.png" )
    },
    units = {
      tank    = love.graphics.newImage( "Assets/big guy token.png" ),
    },
    title = love.graphics.newImage( "Assets/plam.png" )
  }
}

function Loader:addScene( scene, id )
  if self.scenes[id] then
    return
  end
  self.scenes[id] = scene
  return self:load( id )
end

function Loader:load( id )

  if not self.scenes[ id ] then
    print( "Scene \"" .. id .. "\" not found" )

  elseif self.scenes[ id ].isLoaded then
    self.activeScene = self.scenes[ id ]

  else
    local scene = self.scenes[ id ]
    scene.background = love.graphics.newCanvas( scene.width * 50, scene.height * 50 )

    -- each value in the tile map matrix represents a png that will be drawn to the background canvas
    local tile_map = {}
    for i = 1, scene.width do
      tile_map[i] = {}
      for j = 1, scene.height do
        tile_map[i][j] = 0
      end
    end

    -- set the position of every wall tile to -1
    for _, wall in ipairs( scene.walls ) do
      for i = wall.x + 1, wall.x + wall.width do
        for j = wall.y + 1, wall.y + wall.height do
          tile_map[i][j] = -1
        end
      end
      -- convert wall coordinates to #pixels to make drawing easier
      wall.x = wall.x * 50
      wall.y = wall.y * 50
      wall.width = wall.width * 50
      wall.height = wall.height * 50
    end

    -- print tiles onto canvas
    love.graphics.setCanvas( scene.background )
    love.graphics.setColor( 1, 1, 1 )
    for i = 1, scene.width do
      for j = 1, scene.height do
        if tile_map[i][j] == -1 then
          love.graphics.draw( self.images.tiles.wall1, (i - 1) * 50, (j - 1) * 50, 0, .5, 0.5 )
        else
          love.graphics.draw( self.images.tiles.blanck1, (i - 1) * 50 , (j - 1) * 50, 0, .5, 0.5 )
        end
      end
    end
    love.graphics.setCanvas()

    scene.width = scene.width * 50
    scene.height = scene.height * 50

    -- save background image to AppData folder
    scene.background:newImageData():encode("png", id..".png")
  end

  return self.scenes[ id ]
end

function Loader:updateBackground( id, x, y, tile )
  local scene = self.scenes[ id ]
  love.graphics.setCanvas( scene.background )
  love.graphics.setColor( 1, 1, 1 )
  love.graphics.draw( self.images.tiles[ tile ], (x + 1) * 50, (y + 1) * 50, 0, .5, 0.5 )
end
