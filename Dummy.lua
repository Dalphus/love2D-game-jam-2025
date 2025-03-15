require("Ally")

Dummy = {}

function Dummy:new(_x, _y, _size, _rotation, _speed, _fire_timer)
    local dummy = Ally:new(_x, _y, _size, _rotation, _speed)
    dummy.fire_timer = _fire_timer or 0
    return dummy
end