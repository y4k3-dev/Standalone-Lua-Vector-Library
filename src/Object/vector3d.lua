local Vector3D = {}
Vector3D.__index = Vector3D

--- Default threshold used when comparing vectors
Vector3D.EPSILON = 0.00001

---@class Vector3D
---@field x number
---@field y number
---@field z number

--- Creates a new 3D vector
---@param x number
---@param y number
---@param z number
---@return Vector3D
function Vector3D.new(x, y, z)
    local v = setmetatable({x = x or 0, y = y or 0, z = z or 0}, Vector3D)
    return v
end

--- Returns a new vector with the same values
---@param a Vector3D
---@return Vector3D
function Vector3D.clone(a)
    return Vector3D.new(a.x, a.y, a.z)
end

--- Adds two vectors together
---@param a Vector3D
---@param b Vector3D
---@return Vector3D
function Vector3D.__add(a, b)
    return Vector3D.new(a.x + b.x, a.y + b.y, a.z + b.z)
end

--- Subtracts two vectors
---@param a Vector3D
---@param b Vector3D
---@return Vector3D
function Vector3D.__sub(a, b)
    return Vector3D.new(a.x - b.x, a.y - b.y, a.z - b.z)
end

--- Multiplication of a vector by a scalar, or element-wise by another vector
---@param a Vector3D|number
---@param b Vector3D|number
---@return Vector3D
function Vector3D.__mul(a, b)
    if type(a) == "number" then
        return Vector3D.new(a * b.x, a * b.y, a * b.z)
    elseif type(b) == "number" then
        return Vector3D.new(b * a.x, b * a.y, b * a.z)
    else
        return Vector3D.new(a.x * b.x, a.y * b.y, a.z * b.z)
    end
end

--- Division of a vector by a scalar, or element-wise by another vector
---@param a Vector3D|number
---@param b Vector3D|number
---@return Vector3D
function Vector3D.__div(a, b)
    if type(a) == "number" then
        return Vector3D.new(a / b.x, a / b.y, a / b.z)
    elseif type(b) == "number" then
        return Vector3D.new(a.x / b, a.y / b, a.z / b)
    else
        return Vector3D.new(a.x / b.x, a.y / b.y, a.z / b.z)
    end
end

--- Negates a vector
---@param a Vector3D
---@return Vector3D
function Vector3D.__unm(a)
    return Vector3D.new(-a.x, -a.y, -a.z)
end

--- Compares two vectors using the default epsilon
---@param a Vector3D
---@param b Vector3D
---@return boolean
function Vector3D.__eq(a, b)
    return Vector3D.equals(a, b)
end

--- String representation of the vector
---@param a Vector3D
---@return string
function Vector3D.__tostring(a)
    return "Vector3D(" .. a.x .. ", " .. a.y .. ", " .. a.z .. ")"
end

Vector3D.add = Vector3D.__add
Vector3D.sub = Vector3D.__sub
Vector3D.mul = Vector3D.__mul
Vector3D.div = Vector3D.__div
Vector3D.negate = Vector3D.__unm
Vector3D.tostring = Vector3D.__tostring

--- magnitude of the vector
---@param a Vector3D
---@return number
function Vector3D.magnitude(a)
    return math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
end

--- squared magnitude of the vector, cheaper than magnitude for comparisons
---@param a Vector3D
---@return number
function Vector3D.magnitudeSq(a)
    return a.x * a.x + a.y * a.y + a.z * a.z
end

--- Returns a vector with the same direction and a length of 1
--- A zero vector returns a zero vector
---@param a Vector3D
---@return Vector3D
function Vector3D.normalize(a)
    local mag = Vector3D.magnitude(a)
    if mag == 0 then
        return Vector3D.new(0, 0, 0)
    end
    return Vector3D.new(a.x / mag, a.y / mag, a.z / mag)
end

--- Dot product of two vectors
---@param a Vector3D
---@param b Vector3D
---@return number
function Vector3D.dot(a, b)
    return a.x * b.x + a.y * b.y + a.z * b.z
end

--- Cross product of two vectors, perpendicular to both
---@param a Vector3D
---@param b Vector3D
---@return Vector3D
function Vector3D.cross(a, b)
    return Vector3D.new(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    )
end

--- Distance between two points
---@param a Vector3D
---@param b Vector3D
---@return number
function Vector3D.dist(a, b)
    return math.sqrt(Vector3D.distSq(a, b))
end

--- Squared distance between two points, cheaper than dist for comparisons
---@param a Vector3D
---@param b Vector3D
---@return number
function Vector3D.distSq(a, b)
    local dx, dy, dz = b.x - a.x, b.y - a.y, b.z - a.z
    return dx * dx + dy * dy + dz * dz
end

--- Linear interpolation between two vectors
---@param a Vector3D
---@param b Vector3D
---@param t number 0 returns a, 1 returns b
---@return Vector3D
function Vector3D.lerp(a, b, t)
    return Vector3D.new(
        a.x + (b.x - a.x) * t,
        a.y + (b.y - a.y) * t,
        a.z + (b.z - a.z) * t
    )
end

--- Compares two vectors within a tolerance to handle floating-point error
---@param a Vector3D
---@param b Vector3D
---@param epsilon? number defaults to Vector3D.EPSILON
---@return boolean
function Vector3D.equals(a, b, epsilon)
    epsilon = epsilon or Vector3D.EPSILON
    return math.abs(a.x - b.x) <= epsilon
        and math.abs(a.y - b.y) <= epsilon
        and math.abs(a.z - b.z) <= epsilon
end

return Vector3D
