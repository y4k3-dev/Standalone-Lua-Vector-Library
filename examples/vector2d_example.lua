-- Run from the project root: lua examples/vector2d_example.lua
package.path = "./src/?.lua;" .. package.path

local Vector2D = require("Object.vector2d")
local PureVector2D = require("Pure.vector2d")

print("== Object Vector2D ==")

-- Basic arithmetic with operators
local position = Vector2D.new(10, 20)
local velocity = Vector2D.new(3, -4)
print("position:          ", position)
print("velocity:          ", velocity)
print("position + velocity", position + velocity)
print("velocity * 2       ", velocity * 2)
print("-velocity          ", -velocity)
print("speed              ", velocity:magnitude())

-- Move towards a target at a fixed speed each frame
local player = Vector2D.new(0, 0)
local target = Vector2D.new(100, 50)
local speed, dt = 60, 1 / 30

for frame = 1, 3 do
    local direction = (target - player):normalize()
    player = player + direction * speed * dt
    print("frame " .. frame .. " player:     ", player)
end

-- Range checks with distSq avoid a square root every frame
local attackRange = 10
local enemy = Vector2D.new(6, 8)
if player:distSq(enemy) <= attackRange * attackRange then
    print("enemy in range at distance", player:dist(enemy))
else
    print("enemy out of range at distance", player:dist(enemy))
end

-- Smooth camera follow with lerp
local camera = Vector2D.new(0, 0)
for _ = 1, 3 do
    camera = camera:lerp(target, 0.25)
end
print("camera after 3 lerps", camera)

-- Facing checks with dot: positive means the target is in front
local facing = Vector2D.fromAngle(0)
local toTarget = (target - player):normalize()
print("target in front?   ", facing:dot(toTarget) > 0)

-- Angles and perpendiculars
print("angle of (0, 1)    ", Vector2D.new(0, 1):angle(), "radians")
print("fromAngle(pi / 2)  ", Vector2D.fromAngle(math.pi / 2))
print("wall normal        ", Vector2D.new(1, 0):perpendicular())

-- Clone before mutating so the original stays intact
local spawn = Vector2D.new(5, 5)
local copy = spawn:clone()
copy.x = 99
print("spawn unchanged    ", spawn)

-- == compares with an epsilon, so floating-point error does not matter
print("(0.1 + 0.2, 0) == (0.3, 0)?", Vector2D.new(0.1 + 0.2, 0) == Vector2D.new(0.3, 0))

print()
print("== Pure Vector2D ==")

-- The same maths through plain functions and plain tables
local pos = PureVector2D.new(10, 20)
local vel = {x = 3, y = -4}
print("pos + vel          ", PureVector2D.tostring(PureVector2D.add(pos, vel)))
print("vel * 2            ", PureVector2D.tostring(PureVector2D.mul(vel, 2)))
print("speed              ", PureVector2D.magnitude(vel))
print("normalized vel     ", PureVector2D.tostring(PureVector2D.normalize(vel)))
print("distance           ", PureVector2D.dist(pos, PureVector2D.new(13, 24)))
print("lerp halfway       ", PureVector2D.tostring(PureVector2D.lerp(pos, PureVector2D.new(20, 40), 0.5)))
print("equal?             ", PureVector2D.equals(PureVector2D.new(0.1 + 0.2, 0), PureVector2D.new(0.3, 0)))
