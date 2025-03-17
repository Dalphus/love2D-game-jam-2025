Scene = {}

function Scene:new()
  local scene = {}
  setmetatable(scene, self)
  return scene
end

function Scene:load()
  print("Called abstract function")
end

function Scene:draw()
  print("Called abstract function")
end

