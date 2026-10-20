-- Run from the project root: lua examples/vector4d_example.lua
package.path = "./src/?.lua;" .. package.path

local Vector4D = require("Object.vector4d")
local PureVector4D = require("Pure.vector4d")

print("== Object Vector4D ==")

-- Basic arithmetic with operators
local a = Vector4D.new(1, 2, 3, 4)
local b = Vector4D.new(5, 6, 7, 8)
print("a + b              ", a + b)
print("b - a              ", b - a)
print("a * 2              ", a * 2)
print("a . b              ", a:dot(b))
print("length of a        ", a:magnitude())

-- RGBA colours: fade from opaque red to transparent blue
local red = Vector4D.new(1, 0, 0, 1)
local clearBlue = Vector4D.new(0, 0, 1, 0)
for _, t in ipairs({0, 0.25, 0.5, 0.75, 1}) do
    print(string.format("fade t = %-10s", t), red:lerp(clearBlue, t))
end

-- Tint a colour with element-wise multiplication
local white = Vector4D.new(1, 1, 1, 1)
local tint = Vector4D.new(1, 0.5, 0.5, 1)
print("tinted white       ", white * tint)

-- Homogeneous coordinates: w = 1 is a point, w = 0 is a direction
local point = Vector4D.new(2, 3, 4, 1)
local perspective = point / point.w
print("perspective divide ", perspective)

-- == compares with an epsilon
print("equal?             ", Vector4D.new(0.1 + 0.2, 0, 0, 0) == Vector4D.new(0.3, 0, 0, 0))

print()
print("== Pure Vector4D ==")

-- The same maths through plain functions and plain tables
local from = PureVector4D.new(1, 0, 0, 1)
local to = {x = 0, y = 1, z = 0, w = 1}
print("halfway colour     ", PureVector4D.tostring(PureVector4D.lerp(from, to, 0.5)))
print("difference         ", PureVector4D.tostring(PureVector4D.sub(to, from)))
print("distance           ", PureVector4D.dist(from, to))
print("normalized         ", PureVector4D.tostring(PureVector4D.normalize(from)))
