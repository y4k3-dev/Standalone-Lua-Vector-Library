package.path = "./src/?.lua;" .. package.path

local TOLERANCE = 1e-9

local implementations = {
    {name = "Object", Vector4D = require("Object.vector4d")},
    {name = "Pure", Vector4D = require("Pure.vector4d")},
}

--- Asserts a vector's components match within floating-point tolerance
---@param v Vector4D
---@param x number
---@param y number
---@param z number
---@param w number
local function assertVector(v, x, y, z, w)
    assert.is_true(math.abs(v.x - x) < TOLERANCE, "expected x " .. x .. ", got " .. v.x)
    assert.is_true(math.abs(v.y - y) < TOLERANCE, "expected y " .. y .. ", got " .. v.y)
    assert.is_true(math.abs(v.z - z) < TOLERANCE, "expected z " .. z .. ", got " .. v.z)
    assert.is_true(math.abs(v.w - w) < TOLERANCE, "expected w " .. w .. ", got " .. v.w)
end

--- Asserts a number matches within floating-point tolerance
---@param actual number
---@param expected number
local function assertNear(actual, expected)
    assert.is_true(math.abs(actual - expected) < TOLERANCE, "expected " .. expected .. ", got " .. actual)
end

for _, impl in ipairs(implementations) do
    local Vector4D = impl.Vector4D

    describe(impl.name .. " Vector4D", function()
        describe("new", function()
            it("stores the given components", function()
                assertVector(Vector4D.new(1, 2, 3, 4), 1, 2, 3, 4)
            end)

            it("defaults missing components to 0", function()
                assertVector(Vector4D.new(), 0, 0, 0, 0)
                assertVector(Vector4D.new(5, 6, 7), 5, 6, 7, 0)
            end)
        end)

        describe("clone", function()
            it("copies the values", function()
                assertVector(Vector4D.clone(Vector4D.new(1, 2, 3, 4)), 1, 2, 3, 4)
            end)

            it("returns a separate table", function()
                local a = Vector4D.new(1, 2, 3, 4)
                local b = Vector4D.clone(a)
                b.w = 99
                assert.are.equal(4, a.w)
            end)
        end)

        describe("add", function()
            it("adds each component", function()
                assertVector(Vector4D.add(Vector4D.new(1, 2, 3, 4), Vector4D.new(5, 6, 7, 8)), 6, 8, 10, 12)
            end)

            it("does not mutate its inputs", function()
                local a, b = Vector4D.new(1, 2, 3, 4), Vector4D.new(5, 6, 7, 8)
                Vector4D.add(a, b)
                assertVector(a, 1, 2, 3, 4)
                assertVector(b, 5, 6, 7, 8)
            end)
        end)

        describe("sub", function()
            it("subtracts each component", function()
                assertVector(Vector4D.sub(Vector4D.new(5, 6, 7, 8), Vector4D.new(1, 2, 3, 4)), 4, 4, 4, 4)
            end)
        end)

        describe("mul", function()
            it("multiplies by a scalar on the right", function()
                assertVector(Vector4D.mul(Vector4D.new(1, 2, 3, 4), 2), 2, 4, 6, 8)
            end)

            it("multiplies by a scalar on the left", function()
                assertVector(Vector4D.mul(2, Vector4D.new(1, 2, 3, 4)), 2, 4, 6, 8)
            end)

            it("multiplies element-wise by another vector", function()
                assertVector(Vector4D.mul(Vector4D.new(1, 2, 3, 4), Vector4D.new(5, 6, 7, 8)), 5, 12, 21, 32)
            end)
        end)

        describe("div", function()
            it("divides by a scalar", function()
                assertVector(Vector4D.div(Vector4D.new(1, 2, 3, 4), 2), 0.5, 1, 1.5, 2)
            end)

            it("divides a scalar by each component", function()
                assertVector(Vector4D.div(12, Vector4D.new(1, 2, 3, 4)), 12, 6, 4, 3)
            end)

            it("divides element-wise by another vector", function()
                assertVector(Vector4D.div(Vector4D.new(5, 12, 21, 32), Vector4D.new(5, 6, 7, 8)), 1, 2, 3, 4)
            end)
        end)

        describe("negate", function()
            it("inverts each component's sign", function()
                assertVector(Vector4D.negate(Vector4D.new(1, -2, 3, -4)), -1, 2, -3, 4)
            end)
        end)

        describe("magnitude", function()
            it("returns the length of the vector", function()
                assertNear(Vector4D.magnitude(Vector4D.new(1, 1, 1, 1)), 2)
            end)

            it("returns 0 for a zero vector", function()
                assert.are.equal(0, Vector4D.magnitude(Vector4D.new()))
            end)
        end)

        describe("magnitudeSq", function()
            it("returns the squared length of the vector", function()
                assert.are.equal(30, Vector4D.magnitudeSq(Vector4D.new(1, 2, 3, 4)))
            end)
        end)

        describe("normalize", function()
            it("returns a vector with a length of 1 in the same direction", function()
                local v = Vector4D.normalize(Vector4D.new(1, 1, 1, 1))
                assertVector(v, 0.5, 0.5, 0.5, 0.5)
                assertNear(Vector4D.magnitude(v), 1)
            end)

            it("returns a zero vector for a zero vector", function()
                assertVector(Vector4D.normalize(Vector4D.new()), 0, 0, 0, 0)
            end)
        end)

        describe("dot", function()
            it("returns the dot product", function()
                assert.are.equal(70, Vector4D.dot(Vector4D.new(1, 2, 3, 4), Vector4D.new(5, 6, 7, 8)))
            end)

            it("returns 0 for perpendicular vectors", function()
                assert.are.equal(0, Vector4D.dot(Vector4D.new(1, 0, 0, 0), Vector4D.new(0, 0, 0, 1)))
            end)
        end)

        describe("dist", function()
            it("returns the distance between two points", function()
                assertNear(Vector4D.dist(Vector4D.new(1, 1, 1, 1), Vector4D.new(2, 2, 2, 2)), 2)
            end)
        end)

        describe("distSq", function()
            it("returns the squared distance between two points", function()
                assert.are.equal(4, Vector4D.distSq(Vector4D.new(1, 1, 1, 1), Vector4D.new(2, 2, 2, 2)))
            end)
        end)

        describe("lerp", function()
            local a, b = Vector4D.new(0, 0, 0, 0), Vector4D.new(10, 20, 30, 40)

            it("returns a at t = 0", function()
                assertVector(Vector4D.lerp(a, b, 0), 0, 0, 0, 0)
            end)

            it("returns b at t = 1", function()
                assertVector(Vector4D.lerp(a, b, 1), 10, 20, 30, 40)
            end)

            it("returns the midpoint at t = 0.5", function()
                assertVector(Vector4D.lerp(a, b, 0.5), 5, 10, 15, 20)
            end)
        end)

        describe("equals", function()
            it("is true for identical vectors", function()
                assert.is_true(Vector4D.equals(Vector4D.new(1, 2, 3, 4), Vector4D.new(1, 2, 3, 4)))
            end)

            it("is true within the default epsilon", function()
                assert.is_true(Vector4D.equals(Vector4D.new(1, 2, 3, 4), Vector4D.new(1, 2, 3, 4 + 1e-7)))
            end)

            it("handles floating-point error", function()
                assert.is_true(Vector4D.equals(Vector4D.new(0, 0, 0, 0.1 + 0.2), Vector4D.new(0, 0, 0, 0.3)))
            end)

            it("is false outside the default epsilon", function()
                assert.is_false(Vector4D.equals(Vector4D.new(1, 2, 3, 4), Vector4D.new(1, 2, 3, 4.1)))
            end)

            it("accepts a custom epsilon", function()
                assert.is_true(Vector4D.equals(Vector4D.new(1, 2, 3, 4), Vector4D.new(1, 2, 3, 4.1), 0.2))
            end)
        end)

        describe("tostring", function()
            it("formats the components", function()
                assert.are.equal("Vector4D(1, 2, 3, 4)", Vector4D.tostring(Vector4D.new(1, 2, 3, 4)))
            end)
        end)
    end)
end

describe("Object Vector4D operators", function()
    local Vector4D = require("Object.vector4d")
    local a, b = Vector4D.new(1, 2, 3, 4), Vector4D.new(5, 6, 7, 8)

    it("supports +", function()
        assertVector(a + b, 6, 8, 10, 12)
    end)

    it("supports -", function()
        assertVector(b - a, 4, 4, 4, 4)
    end)

    it("supports * with scalars on either side and vectors", function()
        assertVector(a * 2, 2, 4, 6, 8)
        assertVector(2 * a, 2, 4, 6, 8)
        assertVector(a * b, 5, 12, 21, 32)
    end)

    it("supports / with scalars on either side and vectors", function()
        assertVector(a / 2, 0.5, 1, 1.5, 2)
        assertVector(12 / a, 12, 6, 4, 3)
        assertVector(b / a, 5, 3, 7 / 3, 2)
    end)

    it("supports unary -", function()
        assertVector(-a, -1, -2, -3, -4)
    end)

    it("supports == and ~= using epsilon", function()
        assert.is_true(a == Vector4D.new(1, 2, 3, 4 + 1e-7))
        assert.is_true(a ~= b)
    end)

    it("supports tostring()", function()
        assert.are.equal("Vector4D(1, 2, 3, 4)", tostring(a))
    end)

    it("supports method syntax", function()
        assertNear(Vector4D.new(1, 1, 1, 1):magnitude(), 2)
        assertVector(a:add(b), 6, 8, 10, 12)
    end)

    it("returns Vector4D instances from operations", function()
        assert.are.equal(Vector4D, getmetatable(a + b))
        assert.are.equal(Vector4D, getmetatable(a:lerp(b, 0.5)))
    end)
end)

describe("Pure Vector4D", function()
    local Vector4D = require("Pure.vector4d")

    it("returns plain tables with no metatable", function()
        assert.is_nil(getmetatable(Vector4D.new(1, 2, 3, 4)))
        assert.is_nil(getmetatable(Vector4D.lerp(Vector4D.new(), Vector4D.new(), 0.5)))
    end)

    it("accepts table literals", function()
        assertVector(Vector4D.add({x = 1, y = 2, z = 3, w = 4}, {x = 5, y = 6, z = 7, w = 8}), 6, 8, 10, 12)
    end)

    it("loads in a sandbox without setmetatable", function()
        local env = {math = math, type = type}
        local chunk
        if setfenv then
            chunk = assert(loadfile("./src/Pure/vector4d.lua"))
            setfenv(chunk, env)
        else
            chunk = assert(loadfile("./src/Pure/vector4d.lua", "t", env))
        end
        local Sandboxed = chunk()
        assertVector(Sandboxed.normalize(Sandboxed.new(1, 1, 1, 1)), 0.5, 0.5, 0.5, 0.5)
    end)
end)
