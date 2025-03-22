require("Scenes.Scene")

SceneOne = {}
SceneOne.__index = SceneOne
setmetatable(SceneOne, Scene)

function SceneOne:new()
  local scene = {}
  setmetatable(scene, self)
  return scene
end

function SceneOne:load()
  players = {
    ["Francis"] = Dummy:new( 400, 200, 30 ),
    ["Geraldo"] = Dummy:new( 100, 100, 50 )
  }
end

function SceneOne:draw()
  love.graphics.setColor(1, 1, 1)
end
