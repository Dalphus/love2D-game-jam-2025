require("Units.Unit")

Ally = {}
Ally.__index = Ally
function Ally:new(_x, _y, _size, _rotation, _speed)
    local ally = Unit:new(_x, _y, _size, _rotation, _speed)
    ally.movement_nodes = {}
    setmetatable(ally, self)

    return ally
end
