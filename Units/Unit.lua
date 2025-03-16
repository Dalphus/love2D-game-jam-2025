Unit = {}
Unit.__index = Unit
function Unit:new(_x, _y, _size, _rotation, _speed)
  local unit = {
    ["x"]          = _x          or 300,
    ["y"]          = _y          or 400,
    ["size"]       = _size       or 50,
    ["rotation"]   = _rotation   or 0,
    ["speed"]      = _speed      or 0,
  }
  setmetatable(unit, self)

  return unit
end
