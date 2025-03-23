require("Scenes.Scene")
require("Units.Turret")

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
  enemies = {
    [1] = Turret:new(500, 500, 25, -math.pi/2, 0, math.pi/2, 500)
  }
end
