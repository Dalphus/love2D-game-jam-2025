require("Unit")

Ally = Unit:new()

function Ally:new(o, _x, _y, _size, _rotation, _speed)
    self.__index = self
    setmetatable(self, {__index = Unit})
    local o = o or Unit:new(o, _x, _y, _size, _rotation, _speed)
    setmetatable(o, self)
    return o
end
