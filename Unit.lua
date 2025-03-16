Unit = {
    ["x"]          = nil,
    ["y"]          = nil,
    ["size"]       = nil,
    ["rotation"]   = nil,
    ["speed"]      = nil,
}
function Unit:new(o, _x, _y, _size, _rotation, _speed)
    self.__index = self
    local o = o or {}
    setmetatable(o, self)
    o.x = _x or 0
    o.y = _y or 0
    o.size = _size or 100
    o.rotation = _rotation or 0
    o.speed = _speed or 0
    return o
end