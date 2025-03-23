require("Scenes.Scene")
require("Units.Turret")
require("Units.Patrol")

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
    [1] = Turret:new(500, 500, 25, -math.pi/2, 0, 3, math.pi/2, 500),
    [2] = Patrol:new(600, 600, 15, -math.pi/2, 0, 3, math.pi/2, 300)
  }
  enemies[2]:addMovementNode(600, 600)
  enemies[2]:addMovementNode(600, 700)
  enemies[2]:addMovementNode(700, 700)
  enemies[2]:addMovementNode(700, 600)
end
