package.path = "./src/?.lua;" .. package.path

local TOLERANCE = 1e-9

local implementations = {
    {name = "Object", Vector3D = require("Object.vector3d")},
    {name = "Pure", Vector3D = require("Pure.vector3d")},
}

--- Asserts a vector's components match within floating-point tolerance
---@param v Vector3D
---@param x number
---@param y number
---@param z number
local function assertVector(v, x, y, z)
    assert.is_true(math.abs(v.x - x) < TOLERANCE, "expected x " .. x .. ", got " .. v.x)
    assert.is_true(math.abs(v.y - y) < TOLERANCE, "expected y " .. y .. ", got " .. v.y)
    assert.is_true(math.abs(v.z - z) < TOLERANCE, "expected z " .. z .. ", got " .. v.z)
end

--- Asserts a number matches within floating-point tolerance
---@param actual number
---@param expected number
local function assertNear(actual, expected)
    assert.is_true(math.abs(actual - expected) < TOLERANCE, "expected " .. expected .. ", got " .. actual)
end

for _, impl in ipairs(implementations) do
    local Vector3D = impl.Vector3D

    describe(impl.name .. " Vector3D", function()
        describe("new", function()
            it("stores the given components", function()
                assertVector(Vector3D.new(1, 2, 3), 1, 2, 3)
            end)

            it("defaults missing components to 0", function()
                assertVector(Vector3D.new(), 0, 0, 0)
                assertVector(Vector3D.new(5, 6), 5, 6, 0)
            end)
        end)

        describe("clone", function()
            it("copies the values", function()
                assertVector(Vector3D.clone(Vector3D.new(1, 2, 3)), 1, 2, 3)
            end)

            it("returns a separate table", function()
                local a = Vector3D.new(1, 2, 3)
                local b = Vector3D.clone(a)
                b.z = 99
                assert.are.equal(3, a.z)
            end)
        end)

        describe("add", function()
            it("adds each component", function()
                assertVector(Vector3D.add(Vector3D.new(1, 2, 3), Vector3D.new(4, 5, 6)), 5, 7, 9)
            end)

            it("does not mutate its inputs", function()
                local a, b = Vector3D.new(1, 2, 3), Vector3D.new(4, 5, 6)
                Vector3D.add(a, b)
                assertVector(a, 1, 2, 3)
                assertVector(b, 4, 5, 6)
            end)
        end)

        describe("sub", function()
            it("subtracts each component", function()
                assertVector(Vector3D.sub(Vector3D.new(4, 5, 6), Vector3D.new(1, 2, 3)), 3, 3, 3)
            end)
        end)

        describe("mul", function()
            it("multiplies by a scalar on the right", function()
                assertVector(Vector3D.mul(Vector3D.new(1, 2, 3), 2), 2, 4, 6)
            end)

            it("multiplies by a scalar on the left", function()
                assertVector(Vector3D.mul(2, Vector3D.new(1, 2, 3)), 2, 4, 6)
            end)

            it("multiplies element-wise by another vector", function()
                assertVector(Vector3D.mul(Vector3D.new(1, 2, 3), Vector3D.new(4, 5, 6)), 4, 10, 18)
            end)
        end)

        describe("div", function()
            it("divides by a scalar", function()
                assertVector(Vector3D.div(Vector3D.new(1, 2, 3), 2), 0.5, 1, 1.5)
            end)

            it("divides a scalar by each component", function()
                assertVector(Vector3D.div(12, Vector3D.new(1, 2, 3)), 12, 6, 4)
            end)

            it("divides element-wise by another vector", function()
                assertVector(Vector3D.div(Vector3D.new(4, 10, 18), Vector3D.new(4, 5, 6)), 1, 2, 3)
            end)
        end)

        describe("negate", function()
            it("inverts each component's sign", function()
                assertVector(Vector3D.negate(Vector3D.new(1, -2, 3)), -1, 2, -3)
            end)
        end)

        describe("magnitude", function()
            it("returns the length of the vector", function()
                assertNear(Vector3D.magnitude(Vector3D.new(1, 2, 2)), 3)
            end)

            it("returns 0 for a zero vector", function()
                assert.are.equal(0, Vector3D.magnitude(Vector3D.new()))
            end)
        end)

        describe("magnitudeSq", function()
            it("returns the squared length of the vector", function()
                assert.are.equal(9, Vector3D.magnitudeSq(Vector3D.new(1, 2, 2)))
            end)
        end)

        describe("normalize", function()
            it("returns a vector with a length of 1 in the same direction", function()
                local v = Vector3D.normalize(Vector3D.new(1, 2, 2))
                assertVector(v, 1 / 3, 2 / 3, 2 / 3)
                assertNear(Vector3D.magnitude(v), 1)
            end)

            it("returns a zero vector for a zero vector", function()
                assertVector(Vector3D.normalize(Vector3D.new()), 0, 0, 0)
            end)
        end)

        describe("dot", function()
            it("returns the dot product", function()
                assert.are.equal(32, Vector3D.dot(Vector3D.new(1, 2, 3), Vector3D.new(4, 5, 6)))
            end)

            it("returns 0 for perpendicular vectors", function()
                assert.are.equal(0, Vector3D.dot(Vector3D.new(1, 0, 0), Vector3D.new(0, 0, 1)))
            end)

            it("is negative for opposite directions", function()
                assert.is_true(Vector3D.dot(Vector3D.new(0, 1, 0), Vector3D.new(0, -1, 0)) < 0)
            end)
        end)

        describe("cross", function()
            it("follows the right-hand rule", function()
                assertVector(Vector3D.cross(Vector3D.new(1, 0, 0), Vector3D.new(0, 1, 0)), 0, 0, 1)
                assertVector(Vector3D.cross(Vector3D.new(0, 1, 0), Vector3D.new(0, 0, 1)), 1, 0, 0)
                assertVector(Vector3D.cross(Vector3D.new(0, 0, 1), Vector3D.new(1, 0, 0)), 0, 1, 0)
            end)

            it("reverses direction when the inputs are swapped", function()
                assertVector(Vector3D.cross(Vector3D.new(0, 1, 0), Vector3D.new(1, 0, 0)), 0, 0, -1)
            end)

            it("is perpendicular to both inputs", function()
                local a, b = Vector3D.new(1, 2, 3), Vector3D.new(4, 5, 6)
                local c = Vector3D.cross(a, b)
                assert.are.equal(0, Vector3D.dot(c, a))
                assert.are.equal(0, Vector3D.dot(c, b))
            end)

            it("returns a zero vector for parallel vectors", function()
                assertVector(Vector3D.cross(Vector3D.new(1, 2, 3), Vector3D.new(2, 4, 6)), 0, 0, 0)
            end)
        end)

        describe("dist", function()
            it("returns the distance between two points", function()
                assertNear(Vector3D.dist(Vector3D.new(1, 1, 1), Vector3D.new(2, 3, 3)), 3)
            end)
        end)

        describe("distSq", function()
            it("returns the squared distance between two points", function()
                assert.are.equal(9, Vector3D.distSq(Vector3D.new(1, 1, 1), Vector3D.new(2, 3, 3)))
            end)
        end)

        describe("lerp", function()
            local a, b = Vector3D.new(0, 0, 0), Vector3D.new(10, 20, 30)

            it("returns a at t = 0", function()
                assertVector(Vector3D.lerp(a, b, 0), 0, 0, 0)
            end)

            it("returns b at t = 1", function()
                assertVector(Vector3D.lerp(a, b, 1), 10, 20, 30)
            end)

            it("returns the midpoint at t = 0.5", function()
                assertVector(Vector3D.lerp(a, b, 0.5), 5, 10, 15)
            end)
        end)

        describe("equals", function()
            it("is true for identical vectors", function()
                assert.is_true(Vector3D.equals(Vector3D.new(1, 2, 3), Vector3D.new(1, 2, 3)))
            end)

            it("is true within the default epsilon", function()
                assert.is_true(Vector3D.equals(Vector3D.new(1, 2, 3), Vector3D.new(1, 2, 3 + 1e-7)))
            end)

            it("handles floating-point error", function()
                assert.is_true(Vector3D.equals(Vector3D.new(0, 0, 0.1 + 0.2), Vector3D.new(0, 0, 0.3)))
            end)

            it("is false outside the default epsilon", function()
                assert.is_false(Vector3D.equals(Vector3D.new(1, 2, 3), Vector3D.new(1, 2, 3.1)))
            end)

            it("accepts a custom epsilon", function()
                assert.is_true(Vector3D.equals(Vector3D.new(1, 2, 3), Vector3D.new(1, 2, 3.1), 0.2))
            end)
        end)

        describe("tostring", function()
            it("formats the components", function()
                assert.are.equal("Vector3D(1, 2, 3)", Vector3D.tostring(Vector3D.new(1, 2, 3)))
            end)
        end)
    end)
end

describe("Object Vector3D operators", function()
    local Vector3D = require("Object.vector3d")
    local a, b = Vector3D.new(1, 2, 3), Vector3D.new(4, 5, 6)

    it("supports +", function()
        assertVector(a + b, 5, 7, 9)
    end)

    it("supports -", function()
        assertVector(b - a, 3, 3, 3)
    end)

    it("supports * with scalars on either side and vectors", function()
        assertVector(a * 2, 2, 4, 6)
        assertVector(2 * a, 2, 4, 6)
        assertVector(a * b, 4, 10, 18)
    end)

    it("supports / with scalars on either side and vectors", function()
        assertVector(a / 2, 0.5, 1, 1.5)
        assertVector(12 / a, 12, 6, 4)
        assertVector(b / a, 4, 2.5, 2)
    end)

    it("supports unary -", function()
        assertVector(-a, -1, -2, -3)
    end)

    it("supports == and ~= using epsilon", function()
        assert.is_true(a == Vector3D.new(1, 2, 3 + 1e-7))
        assert.is_true(a ~= b)
    end)

    it("supports tostring()", function()
        assert.are.equal("Vector3D(1, 2, 3)", tostring(a))
    end)

    it("supports method syntax", function()
        assertNear(Vector3D.new(1, 2, 2):magnitude(), 3)
        assertVector(Vector3D.new(1, 0, 0):cross(Vector3D.new(0, 1, 0)), 0, 0, 1)
    end)

    it("returns Vector3D instances from operations", function()
        assert.are.equal(Vector3D, getmetatable(a + b))
        assert.are.equal(Vector3D, getmetatable(a:cross(b)))
    end)
end)

describe("Pure Vector3D", function()
    local Vector3D = require("Pure.vector3d")

    it("returns plain tables with no metatable", function()
        assert.is_nil(getmetatable(Vector3D.new(1, 2, 3)))
        assert.is_nil(getmetatable(Vector3D.cross(Vector3D.new(), Vector3D.new())))
    end)

    it("accepts table literals", function()
        assertVector(Vector3D.add({x = 1, y = 2, z = 3}, {x = 4, y = 5, z = 6}), 5, 7, 9)
    end)

    it("loads in a sandbox without setmetatable", function()
        local env = {math = math, type = type}
        local chunk
        if setfenv then
            chunk = assert(loadfile("./src/Pure/vector3d.lua"))
            setfenv(chunk, env)
        else
            chunk = assert(loadfile("./src/Pure/vector3d.lua", "t", env))
        end
        local Sandboxed = chunk()
        assertVector(Sandboxed.normalize(Sandboxed.new(1, 2, 2)), 1 / 3, 2 / 3, 2 / 3)
    end)
end)
