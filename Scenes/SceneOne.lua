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
  BackgroundZero = love.graphics.newImage( "Assets/Backgrounds/Bad.png")
end

function SceneOne:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(BackgroundZero, 0, 0)
end