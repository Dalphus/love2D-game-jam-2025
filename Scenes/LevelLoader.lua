LevelLoader = {}

currentLevel = nil

function LevelLoader:draw()
  if currentLevel then
    currentLevel:draw()
  end
end

function LevelLoader:setCurrentLevel(setLevel)
  players = {
    ["Francis"] = Dummy:new( 400, 200, 30 ),
    ["Geraldo"] = Dummy:new( 100, 100, 50 )
  }
  currentLevel = setLevel
  setLevel:load()
end