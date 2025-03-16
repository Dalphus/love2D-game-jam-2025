require("Ally")

Dummy = Ally:new()

function Dummy:new(o, _x, _y, _size, _rotation, _speed, _fire_timer)
    self.__index = self
    setmetatable(self, {__index = Ally})
    local o = o or Ally:new(o, _x, _y, _size, _rotation, _speed)
    setmetatable(o, self)
    o.fire_timer = _fire_timer or 0
    return o
end