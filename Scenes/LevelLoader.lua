Loader = {
  scenes = {},

  -- there's probably a better place to put the sprites, but it lives here for now
  images = {
    tiles = {
      love.graphics.newImage( "Assets/tile2.png" ),
      love.graphics.newImage( "Assets/wallcenter.png" ),
      love.graphics.newImage( "Assets/walldown.png"   ),
      love.graphics.newImage( "Assets/wallleft.png"   ),
      love.graphics.newImage( "Assets/wallcorner.png"      ),
      ["turret base"] = love.graphics.newImage( "Assets/turretbase.png" ),
    },
    portraits = {
      tank    = love.graphics.newImage( "Assets/big guy.png" ),
      turret  = love.graphics.newImage( "Assets/gun.png"     ),
      soldier = love.graphics.newImage( "Assets/shroomo.png" )
    },
    units = {
      tank    = love.graphics.newImage( "Assets/big guy token.png" ),
      turret_base = love.graphics.newImage( "Assets/turretbase.png" ),
      turret_head = love.graphics.newImage( "Assets/gunsprite.png" ),
      patrol = love.graphics.newImage( "Assets/patrol.png" )
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
        tile_map[i][j] = 1
      end
    end

    -- set the position of every wall tile to -1
    for _, wall in ipairs( scene.walls ) do
      for i = wall.x + 1, wall.x + wall.width do
        for j = wall.y + 1, wall.y + wall.height do
          tile_map[i][j] = 2
        end
      end
      -- convert wall coordinates to #pixels to make drawing easier
      wall.x = wall.x * 50
      wall.y = wall.y * 50
      wall.width = wall.width * 50
      wall.height = wall.height * 50
    end

    for i = 1, scene.width do
      for j = 1, scene.height do
        if tile_map[i][j] == 2 then
          -- check if the wall tile is a corner
          if tile_map[i] and tile_map[i - 1][j] == 1 and tile_map[i][j + 1] == 1 then
            tile_map[i][j] = 5
          -- check if the wall tile is a left edge
          elseif tile_map[i] and tile_map[i - 1][j] == 1 then
            tile_map[i][j] = 4
          -- check if the wall tile is a bottom edge
          elseif tile_map[i] and tile_map[i][j + 1] == 1 then
            tile_map[i][j] = 3
          end
        end
      end
    end

    -- print tiles onto canvas
    love.graphics.setCanvas( scene.background )
    love.graphics.setColor( 1, 1, 1 )
    for i = 1, scene.width do
      for j = 1, scene.height do
        love.graphics.draw( self.images.tiles[tile_map[i][j]], (i - 1) * 50, (j - 1) * 50, 0, .5, 0.5 )
      end
    end
    love.graphics.draw( self.images.tiles["turret base"], TURRET_X, TURRET_Y, 0, .5, 0.5, 50, 50 )

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
