local Vector2D = {}
Vector2D.__index = Vector2D

local atan2 = math.atan2 or math.atan

--- Default threshold used when comparing vectors
Vector2D.EPSILON = 0.00001

---@class Vector2D
---@field x number
---@field y number

--- Creates a new 2D vector
---@param x number
---@param y number
---@return Vector2D
function Vector2D.new(x, y)
    local v = setmetatable({x = x or 0, y = y or 0}, Vector2D)
    return v
end

--- Creates a normalized vector pointing in the given direction
---@param angle number angle in radians
---@return Vector2D
function Vector2D.fromAngle(angle)
    return Vector2D.new(math.cos(angle), math.sin(angle))
end

--- Returns a new vector with the same values
---@param a Vector2D
---@return Vector2D
function Vector2D.clone(a)
    return Vector2D.new(a.x, a.y)
end

--- Adds two vectors together
---@param a Vector2D
---@param b Vector2D
---@return Vector2D
function Vector2D.__add(a, b)
    return Vector2D.new(a.x + b.x, a.y + b.y)
end

--- Subtracts two vectors
---@param a Vector2D
---@param b Vector2D
---@return Vector2D
function Vector2D.__sub(a, b)
    return Vector2D.new(a.x - b.x, a.y - b.y)
end

--- Multiplication of a vector by a scalar, or element-wise by another vector
---@param a Vector2D|number
---@param b Vector2D|number
---@return Vector2D
function Vector2D.__mul(a, b)
    if type(a) == "number" then
        return Vector2D.new(a * b.x, a * b.y)
    elseif type(b) == "number" then
        return Vector2D.new(b * a.x, b * a.y)
    else
        return Vector2D.new(a.x * b.x, a.y * b.y)
    end
end

--- Division of a vector by a scalar, or element-wise by another vector
---@param a Vector2D|number
---@param b Vector2D|number
---@return Vector2D
function Vector2D.__div(a, b)
    if type(a) == "number" then
        return Vector2D.new(a / b.x, a / b.y)
    elseif type(b) == "number" then
        return Vector2D.new(a.x / b, a.y / b)
    else
        return Vector2D.new(a.x / b.x, a.y / b.y)
    end
end

--- Negates a vector
---@param a Vector2D
---@return Vector2D
function Vector2D.__unm(a)
    return Vector2D.new(-a.x, -a.y)
end

--- Compares two vectors using the default epsilon
---@param a Vector2D
---@param b Vector2D
---@return boolean
function Vector2D.__eq(a, b)
    return Vector2D.equals(a, b)
end

--- String representation of the vector
---@param a Vector2D
---@return string
function Vector2D.__tostring(a)
    return "Vector2D(" .. a.x .. ", " .. a.y .. ")"
end

Vector2D.add = Vector2D.__add
Vector2D.sub = Vector2D.__sub
Vector2D.mul = Vector2D.__mul
Vector2D.div = Vector2D.__div
Vector2D.negate = Vector2D.__unm
Vector2D.tostring = Vector2D.__tostring

--- magnitude of the vector
---@param a Vector2D
---@return number
function Vector2D.magnitude(a)
    return math.sqrt(a.x * a.x + a.y * a.y)
end

--- squared magnitude of the vector, cheaper than magnitude for comparisons
---@return number
---@param a Vector2D
function Vector2D.magnitudeSq(a)
    return a.x * a.x + a.y * a.y
end

--- Returns a vector with the same direction and a length of 1
--- A zero vector returns a zero vector
---@param a Vector2D
---@return Vector2D
function Vector2D.normalize(a)
    local mag = Vector2D.magnitude(a)
    if mag == 0 then
        return Vector2D.new(0, 0)
    end
    return Vector2D.new(a.x / mag, a.y / mag)
end

--- Dot product of two vectors
---@param a Vector2D
---@param b Vector2D
---@return number
function Vector2D.dot(a, b)
    return a.x * b.x + a.y * b.y
end

--- Distance between two points
---@param a Vector2D
---@param b Vector2D
---@return number
function Vector2D.dist(a, b)
    return math.sqrt(Vector2D.distSq(a, b))
end

--- Squared distance between two points, cheaper than dist for comparisons
---@param a Vector2D
---@param b Vector2D
---@return number
function Vector2D.distSq(a, b)
    local dx, dy = b.x - a.x, b.y - a.y
    return dx * dx + dy * dy
end

--- Linear interpolation between two vectors
---@param a Vector2D
---@param b Vector2D
---@param t number 0 returns a, 1 returns b
---@return Vector2D
function Vector2D.lerp(a, b, t)
    return Vector2D.new(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t)
end

--- Compares two vectors within a tolerance to handle floating-point error
---@param a Vector2D
---@param b Vector2D
---@param epsilon? number defaults to Vector2D.EPSILON
---@return boolean
function Vector2D.equals(a, b, epsilon)
    epsilon = epsilon or Vector2D.EPSILON
    return math.abs(a.x - b.x) <= epsilon and math.abs(a.y - b.y) <= epsilon
end

--- Rotation of the vector in radians
---@param a Vector2D
---@return number
function Vector2D.angle(a)
    return atan2(a.y, a.x)
end

--- Returns the vector rotated 90 degrees counter-clockwise
---@param a Vector2D
---@return Vector2D
function Vector2D.perpendicular(a)
    return Vector2D.new(-a.y, a.x)
end

return Vector2D
