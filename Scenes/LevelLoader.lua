LevelLoader = {}

currentLevel = nil

function LevelLoader:draw()
  if currentLevel then
    currentLevel:draw()
  end
end

function LevelLoader:setCurrentLevel(setLevel)
  currentLevel = setLevel
  setLevel:load()
end
