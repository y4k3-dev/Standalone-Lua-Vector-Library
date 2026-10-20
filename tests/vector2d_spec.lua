package.path = "./src/?.lua;" .. package.path

local TOLERANCE = 1e-9

local implementations = {
    {name = "Object", Vector2D = require("Object.vector2d")},
    {name = "Pure", Vector2D = require("Pure.vector2d")},
}

--- Asserts a vector's components match within floating-point tolerance
---@param v Vector2D
---@param x number
---@param y number
local function assertVector(v, x, y)
    assert.is_true(math.abs(v.x - x) < TOLERANCE, "expected x " .. x .. ", got " .. v.x)
    assert.is_true(math.abs(v.y - y) < TOLERANCE, "expected y " .. y .. ", got " .. v.y)
end

--- Asserts a number matches within floating-point tolerance
---@param actual number
---@param expected number
local function assertNear(actual, expected)
    assert.is_true(math.abs(actual - expected) < TOLERANCE, "expected " .. expected .. ", got " .. actual)
end

for _, impl in ipairs(implementations) do
    local Vector2D = impl.Vector2D

    describe(impl.name .. " Vector2D", function()
        describe("new", function()
            it("stores the given components", function()
                assertVector(Vector2D.new(3, 4), 3, 4)
            end)

            it("defaults missing components to 0", function()
                assertVector(Vector2D.new(), 0, 0)
                assertVector(Vector2D.new(5), 5, 0)
            end)
        end)

        describe("fromAngle", function()
            it("creates a unit vector pointing at the angle", function()
                assertVector(Vector2D.fromAngle(0), 1, 0)
                assertVector(Vector2D.fromAngle(math.pi / 2), 0, 1)
                assertVector(Vector2D.fromAngle(math.pi), -1, 0)
            end)

            it("always has a length of 1", function()
                assertNear(Vector2D.magnitude(Vector2D.fromAngle(1.234)), 1)
            end)
        end)

        describe("clone", function()
            it("copies the values", function()
                assertVector(Vector2D.clone(Vector2D.new(3, 4)), 3, 4)
            end)

            it("returns a separate table", function()
                local a = Vector2D.new(3, 4)
                local b = Vector2D.clone(a)
                b.x = 99
                assert.are.equal(3, a.x)
            end)
        end)

        describe("add", function()
            it("adds each component", function()
                assertVector(Vector2D.add(Vector2D.new(3, 4), Vector2D.new(1, 2)), 4, 6)
            end)

            it("does not mutate its inputs", function()
                local a, b = Vector2D.new(3, 4), Vector2D.new(1, 2)
                Vector2D.add(a, b)
                assertVector(a, 3, 4)
                assertVector(b, 1, 2)
            end)
        end)

        describe("sub", function()
            it("subtracts each component", function()
                assertVector(Vector2D.sub(Vector2D.new(3, 4), Vector2D.new(1, 2)), 2, 2)
            end)
        end)

        describe("mul", function()
            it("multiplies by a scalar on the right", function()
                assertVector(Vector2D.mul(Vector2D.new(3, 4), 2), 6, 8)
            end)

            it("multiplies by a scalar on the left", function()
                assertVector(Vector2D.mul(2, Vector2D.new(3, 4)), 6, 8)
            end)

            it("multiplies element-wise by another vector", function()
                assertVector(Vector2D.mul(Vector2D.new(3, 4), Vector2D.new(2, 3)), 6, 12)
            end)
        end)

        describe("div", function()
            it("divides by a scalar", function()
                assertVector(Vector2D.div(Vector2D.new(3, 4), 2), 1.5, 2)
            end)

            it("divides a scalar by each component", function()
                assertVector(Vector2D.div(12, Vector2D.new(3, 4)), 4, 3)
            end)

            it("divides element-wise by another vector", function()
                assertVector(Vector2D.div(Vector2D.new(6, 12), Vector2D.new(2, 3)), 3, 4)
            end)
        end)

        describe("negate", function()
            it("inverts each component's sign", function()
                assertVector(Vector2D.negate(Vector2D.new(3, -4)), -3, 4)
            end)
        end)

        describe("magnitude", function()
            it("returns the length of the vector", function()
                assertNear(Vector2D.magnitude(Vector2D.new(3, 4)), 5)
            end)

            it("returns 0 for a zero vector", function()
                assert.are.equal(0, Vector2D.magnitude(Vector2D.new()))
            end)
        end)

        describe("magnitudeSq", function()
            it("returns the squared length of the vector", function()
                assert.are.equal(25, Vector2D.magnitudeSq(Vector2D.new(3, 4)))
            end)
        end)

        describe("normalize", function()
            it("returns a vector with a length of 1 in the same direction", function()
                local v = Vector2D.normalize(Vector2D.new(3, 4))
                assertVector(v, 0.6, 0.8)
                assertNear(Vector2D.magnitude(v), 1)
            end)

            it("returns a zero vector for a zero vector", function()
                assertVector(Vector2D.normalize(Vector2D.new()), 0, 0)
            end)
        end)

        describe("dot", function()
            it("returns the dot product", function()
                assert.are.equal(11, Vector2D.dot(Vector2D.new(3, 4), Vector2D.new(1, 2)))
            end)

            it("returns 0 for perpendicular vectors", function()
                assert.are.equal(0, Vector2D.dot(Vector2D.new(1, 0), Vector2D.new(0, 1)))
            end)

            it("is negative for opposite directions", function()
                assert.is_true(Vector2D.dot(Vector2D.new(1, 0), Vector2D.new(-1, 0)) < 0)
            end)
        end)

        describe("dist", function()
            it("returns the distance between two points", function()
                assertNear(Vector2D.dist(Vector2D.new(1, 1), Vector2D.new(4, 5)), 5)
            end)
        end)

        describe("distSq", function()
            it("returns the squared distance between two points", function()
                assert.are.equal(25, Vector2D.distSq(Vector2D.new(1, 1), Vector2D.new(4, 5)))
            end)
        end)

        describe("lerp", function()
            local a, b = Vector2D.new(0, 0), Vector2D.new(10, 20)

            it("returns a at t = 0", function()
                assertVector(Vector2D.lerp(a, b, 0), 0, 0)
            end)

            it("returns b at t = 1", function()
                assertVector(Vector2D.lerp(a, b, 1), 10, 20)
            end)

            it("returns the midpoint at t = 0.5", function()
                assertVector(Vector2D.lerp(a, b, 0.5), 5, 10)
            end)
        end)

        describe("equals", function()
            it("is true for identical vectors", function()
                assert.is_true(Vector2D.equals(Vector2D.new(1, 2), Vector2D.new(1, 2)))
            end)

            it("is true within the default epsilon", function()
                assert.is_true(Vector2D.equals(Vector2D.new(1, 2), Vector2D.new(1 + 1e-7, 2)))
            end)

            it("handles floating-point error", function()
                assert.is_true(Vector2D.equals(Vector2D.new(0.1 + 0.2, 0), Vector2D.new(0.3, 0)))
            end)

            it("is false outside the default epsilon", function()
                assert.is_false(Vector2D.equals(Vector2D.new(1, 2), Vector2D.new(1.1, 2)))
            end)

            it("accepts a custom epsilon", function()
                assert.is_true(Vector2D.equals(Vector2D.new(1, 2), Vector2D.new(1.1, 2), 0.2))
            end)
        end)

        describe("tostring", function()
            it("formats the components", function()
                assert.are.equal("Vector2D(3, 4)", Vector2D.tostring(Vector2D.new(3, 4)))
            end)
        end)

        describe("angle", function()
            it("returns the rotation in radians", function()
                assertNear(Vector2D.angle(Vector2D.new(1, 0)), 0)
                assertNear(Vector2D.angle(Vector2D.new(0, 1)), math.pi / 2)
                assertNear(Vector2D.angle(Vector2D.new(-1, 0)), math.pi)
                assertNear(Vector2D.angle(Vector2D.new(0, -1)), -math.pi / 2)
            end)

            it("reverses fromAngle", function()
                assertNear(Vector2D.angle(Vector2D.fromAngle(0.75)), 0.75)
            end)
        end)

        describe("perpendicular", function()
            it("rotates the vector 90 degrees counter-clockwise", function()
                assertVector(Vector2D.perpendicular(Vector2D.new(1, 0)), 0, 1)
                assertVector(Vector2D.perpendicular(Vector2D.new(3, 4)), -4, 3)
            end)

            it("is perpendicular to the original", function()
                local v = Vector2D.new(3, 4)
                assert.are.equal(0, Vector2D.dot(v, Vector2D.perpendicular(v)))
            end)
        end)
    end)
end

describe("Object Vector2D operators", function()
    local Vector2D = require("Object.vector2d")
    local a, b = Vector2D.new(3, 4), Vector2D.new(1, 2)

    it("supports +", function()
        assertVector(a + b, 4, 6)
    end)

    it("supports -", function()
        assertVector(a - b, 2, 2)
    end)

    it("supports * with scalars on either side and vectors", function()
        assertVector(a * 2, 6, 8)
        assertVector(2 * a, 6, 8)
        assertVector(a * b, 3, 8)
    end)

    it("supports / with scalars on either side and vectors", function()
        assertVector(a / 2, 1.5, 2)
        assertVector(12 / a, 4, 3)
        assertVector(a / b, 3, 2)
    end)

    it("supports unary -", function()
        assertVector(-a, -3, -4)
    end)

    it("supports == and ~= using epsilon", function()
        assert.is_true(a == Vector2D.new(3 + 1e-7, 4))
        assert.is_true(a ~= b)
    end)

    it("supports tostring()", function()
        assert.are.equal("Vector2D(3, 4)", tostring(a))
    end)

    it("supports method syntax", function()
        assertNear(a:magnitude(), 5)
        assertVector(a:add(b), 4, 6)
    end)

    it("returns Vector2D instances from operations", function()
        assert.are.equal(Vector2D, getmetatable(a + b))
        assert.are.equal(Vector2D, getmetatable(a:normalize()))
    end)
end)

describe("Pure Vector2D", function()
    local Vector2D = require("Pure.vector2d")

    it("returns plain tables with no metatable", function()
        assert.is_nil(getmetatable(Vector2D.new(3, 4)))
        assert.is_nil(getmetatable(Vector2D.add(Vector2D.new(), Vector2D.new())))
    end)

    it("accepts table literals", function()
        assertVector(Vector2D.add({x = 3, y = 4}, {x = 1, y = 2}), 4, 6)
    end)

    it("loads in a sandbox without setmetatable", function()
        local env = {math = math, type = type}
        local chunk
        if setfenv then
            chunk = assert(loadfile("./src/Pure/vector2d.lua"))
            setfenv(chunk, env)
        else
            chunk = assert(loadfile("./src/Pure/vector2d.lua", "t", env))
        end
        local Sandboxed = chunk()
        assertVector(Sandboxed.normalize(Sandboxed.new(3, 4)), 0.6, 0.8)
        assertNear(Sandboxed.angle(Sandboxed.new(0, 1)), math.pi / 2)
    end)
end)
