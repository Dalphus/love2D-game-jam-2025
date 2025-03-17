MovementNode = {}

function MovementNode:new(x, y, parent)
    local node = {}
    setmetatable(node, self)
    self.__index = self

    node.x = x
    node.y = y
    node.parent = parent

    return node
end

function MovementNode:addNode(x, y)
    return MovementNode:new(x, y, self)
end
