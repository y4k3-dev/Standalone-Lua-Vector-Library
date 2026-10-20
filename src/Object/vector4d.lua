local Vector4D = {}
Vector4D.__index = Vector4D

--- Default threshold used when comparing vectors
Vector4D.EPSILON = 0.00001

---@class Vector4D
---@field x number
---@field y number
---@field z number
---@field w number

--- Creates a new 4D vector
---@param x number
---@param y number
---@param z number
---@param w number
---@return Vector4D
function Vector4D.new(x, y, z, w)
    local v = setmetatable({x = x or 0, y = y or 0, z = z or 0, w = w or 0}, Vector4D)
    return v
end

--- Returns a new vector with the same values
---@param a Vector4D
---@return Vector4D
function Vector4D.clone(a)
    return Vector4D.new(a.x, a.y, a.z, a.w)
end

--- Adds two vectors together
---@param a Vector4D
---@param b Vector4D
---@return Vector4D
function Vector4D.__add(a, b)
    return Vector4D.new(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
end

--- Subtracts two vectors
---@param a Vector4D
---@param b Vector4D
---@return Vector4D
function Vector4D.__sub(a, b)
    return Vector4D.new(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
end

--- Multiplication of a vector by a scalar, or element-wise by another vector
---@param a Vector4D|number
---@param b Vector4D|number
---@return Vector4D
function Vector4D.__mul(a, b)
    if type(a) == "number" then
        return Vector4D.new(a * b.x, a * b.y, a * b.z, a * b.w)
    elseif type(b) == "number" then
        return Vector4D.new(b * a.x, b * a.y, b * a.z, b * a.w)
    else
        return Vector4D.new(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w)
    end
end

--- Division of a vector by a scalar, or element-wise by another vector
---@param a Vector4D|number
---@param b Vector4D|number
---@return Vector4D
function Vector4D.__div(a, b)
    if type(a) == "number" then
        return Vector4D.new(a / b.x, a / b.y, a / b.z, a / b.w)
    elseif type(b) == "number" then
        return Vector4D.new(a.x / b, a.y / b, a.z / b, a.w / b)
    else
        return Vector4D.new(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w)
    end
end

--- Negates a vector
---@param a Vector4D
---@return Vector4D
function Vector4D.__unm(a)
    return Vector4D.new(-a.x, -a.y, -a.z, -a.w)
end

--- Compares two vectors using the default epsilon
---@param a Vector4D
---@param b Vector4D
---@return boolean
function Vector4D.__eq(a, b)
    return Vector4D.equals(a, b)
end

--- String representation of the vector
---@param a Vector4D
---@return string
function Vector4D.__tostring(a)
    return "Vector4D(" .. a.x .. ", " .. a.y .. ", " .. a.z .. ", " .. a.w .. ")"
end

Vector4D.add = Vector4D.__add
Vector4D.sub = Vector4D.__sub
Vector4D.mul = Vector4D.__mul
Vector4D.div = Vector4D.__div
Vector4D.negate = Vector4D.__unm
Vector4D.tostring = Vector4D.__tostring

--- magnitude of the vector
---@param a Vector4D
---@return number
function Vector4D.magnitude(a)
    return math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w)
end

--- squared magnitude of the vector, cheaper than magnitude for comparisons
---@param a Vector4D
---@return number
function Vector4D.magnitudeSq(a)
    return a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w
end

--- Returns a vector with the same direction and a length of 1
--- A zero vector returns a zero vector
---@param a Vector4D
---@return Vector4D
function Vector4D.normalize(a)
    local mag = Vector4D.magnitude(a)
    if mag == 0 then
        return Vector4D.new(0, 0, 0, 0)
    end
    return Vector4D.new(a.x / mag, a.y / mag, a.z / mag, a.w / mag)
end

--- Dot product of two vectors
---@param a Vector4D
---@param b Vector4D
---@return number
function Vector4D.dot(a, b)
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
end

--- Distance between two points
---@param a Vector4D
---@param b Vector4D
---@return number
function Vector4D.dist(a, b)
    return math.sqrt(Vector4D.distSq(a, b))
end

--- Squared distance between two points, cheaper than dist for comparisons
---@param a Vector4D
---@param b Vector4D
---@return number
function Vector4D.distSq(a, b)
    local dx, dy, dz, dw = b.x - a.x, b.y - a.y, b.z - a.z, b.w - a.w
    return dx * dx + dy * dy + dz * dz + dw * dw
end

--- Linear interpolation between two vectors
---@param a Vector4D
---@param b Vector4D
---@param t number 0 returns a, 1 returns b
---@return Vector4D
function Vector4D.lerp(a, b, t)
    return Vector4D.new(
        a.x + (b.x - a.x) * t,
        a.y + (b.y - a.y) * t,
        a.z + (b.z - a.z) * t,
        a.w + (b.w - a.w) * t
    )
end

--- Compares two vectors within a tolerance to handle floating-point error
---@param a Vector4D
---@param b Vector4D
---@param epsilon? number defaults to Vector4D.EPSILON
---@return boolean
function Vector4D.equals(a, b, epsilon)
    epsilon = epsilon or Vector4D.EPSILON
    return math.abs(a.x - b.x) <= epsilon
        and math.abs(a.y - b.y) <= epsilon
        and math.abs(a.z - b.z) <= epsilon
        and math.abs(a.w - b.w) <= epsilon
end

return Vector4D
