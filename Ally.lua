require("Unit")

Ally = {}

function Ally:new(_x, _y, _size, _rotation, _speed)
    local ally = Unit:new(_x, _y, _size, _rotation, _speed)
    return ally
end
