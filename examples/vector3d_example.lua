-- Run from the project root: lua examples/vector3d_example.lua
package.path = "./src/?.lua;" .. package.path

local Vector3D = require("Object.vector3d")
local PureVector3D = require("Pure.vector3d")

print("== Object Vector3D ==")

-- Basic arithmetic with operators
local a = Vector3D.new(1, 2, 3)
local b = Vector3D.new(4, 5, 6)
print("a + b              ", a + b)
print("b - a              ", b - a)
print("a * 2              ", a * 2)
print("a * b (element)    ", a * b)
print("length of a        ", a:magnitude())

-- Gravity and velocity integration
local position = Vector3D.new(0, 10, 0)
local velocity = Vector3D.new(2, 5, 0)
local gravity = Vector3D.new(0, -9.81, 0)
local dt = 0.1

for step = 1, 3 do
    velocity = velocity + gravity * dt
    position = position + velocity * dt
    print("step " .. step .. " position:     ", position)
end

-- Simple diffuse lighting: brightness is the dot of the surface normal and light direction
local normal = Vector3D.new(0, 1, 0)
local toLight = Vector3D.new(1, 1, 0):normalize()
local brightness = math.max(0, normal:dot(toLight))
print("diffuse brightness ", brightness)

-- Surface normal of a triangle from the cross product of two edges
local p1 = Vector3D.new(0, 0, 0)
local p2 = Vector3D.new(1, 0, 0)
local p3 = Vector3D.new(0, 0, -1)
local triangleNormal = (p2 - p1):cross(p3 - p1):normalize()
print("triangle normal    ", triangleNormal)

-- Proximity check with distSq avoids a square root
local pickupRadius = 2
local pickup = Vector3D.new(1, 9, 0)
print("can pick up?       ", position:distSq(pickup) <= pickupRadius * pickupRadius)

-- Smooth camera follow with lerp
local camera = Vector3D.new(0, 5, -10)
camera = camera:lerp(position + Vector3D.new(0, 5, -10), 0.5)
print("camera             ", camera)

-- == compares with an epsilon
print("equal?             ", Vector3D.new(0.1 + 0.2, 0, 0) == Vector3D.new(0.3, 0, 0))

print()
print("== Pure Vector3D ==")

-- The same maths through plain functions and plain tables
local up = PureVector3D.new(0, 1, 0)
local right = {x = 1, y = 0, z = 0}
print("right x up         ", PureVector3D.tostring(PureVector3D.cross(right, up)))
print("up . right         ", PureVector3D.dot(up, right))
print("sum                ", PureVector3D.tostring(PureVector3D.add(up, right)))
print("normalized sum     ", PureVector3D.tostring(PureVector3D.normalize(PureVector3D.add(up, right))))
print("distance           ", PureVector3D.dist(up, right))
