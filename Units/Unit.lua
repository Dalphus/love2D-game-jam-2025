Unit = {}
-- Unit.__index = Unit

function Unit:new(_x, _y, _size, _rotation, _speed)
  local unit = {
    ["x"]        = _x        or 100,
    ["y"]        = _y        or 100,
    ["size"]     = _size     or 50,
    ["rotation"] = _rotation or 0,
    ["speed"]    = _speed    or 0,
    ["name"]     = "Unit"
  }
  return unit
end
