require("Units.Ally")

Dummy = {}
Dummy.__index = Dummy

function Dummy:new(...)
  local dummy = Ally:new(...)
  setmetatable(dummy, self)
  return dummy
end
