Node = {}
Node.__index = Node

function Node:new(_x, _y)
  local node = {
    ["x"] = _x,
    ["y"] = _y
  }
  return node
end