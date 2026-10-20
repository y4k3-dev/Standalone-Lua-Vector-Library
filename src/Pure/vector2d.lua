local Vector2D = {}

local atan2 = math.atan2 or math.atan

--- Default threshold used when comparing vectors
Vector2D.EPSILON = 0.00001

---@class Vector2D
---@field x number
---@field y number

--- Creates a new 2D vector
---@param x? number
---@param y? number
---@return Vector2D
function Vector2D.new(x, y)
    return {x = x or 0, y = y or 0}
end

--- Creates a normalized vector pointing in the given direction
---@param angle number angle in radians
---@return Vector2D
function Vector2D.fromAngle(angle)
    return {x = math.cos(angle), y = math.sin(angle)}
end

--- Returns a new vector with the same values
---@param a Vector2D
---@return Vector2D
function Vector2D.clone(a)
    return {x = a.x, y = a.y}
end

---@param a Vector2D
---@param b Vector2D
---@return Vector2D
function Vector2D.add(a, b)
    return {x = a.x + b.x, y = a.y + b.y}
end

---@param a Vector2D
---@param b Vector2D
---@return Vector2D
function Vector2D.sub(a, b)
    return {x = a.x - b.x, y = a.y - b.y}
end

--- Multiplies by a scalar, or element-wise by another vector
---@param a Vector2D|number
---@param b Vector2D|number
---@return Vector2D
function Vector2D.mul(a, b)
    if type(a) == "number" then
        return {x = a * b.x, y = a * b.y}
    elseif type(b) == "number" then
        return {x = a.x * b, y = a.y * b}
    end
    return {x = a.x * b.x, y = a.y * b.y}
end

--- Divides by a scalar, or element-wise by another vector
---@param a Vector2D|number
---@param b Vector2D|number
---@return Vector2D
function Vector2D.div(a, b)
    if type(a) == "number" then
        return {x = a / b.x, y = a / b.y}
    elseif type(b) == "number" then
        return {x = a.x / b, y = a.y / b}
    end
    return {x = a.x / b.x, y = a.y / b.y}
end

---@param a Vector2D
---@return Vector2D
function Vector2D.negate(a)
    return {x = -a.x, y = -a.y}
end

---@param a Vector2D
---@return number
function Vector2D.magnitude(a)
    return math.sqrt(a.x * a.x + a.y * a.y)
end

--- Cheaper than magnitude for comparisons
---@param a Vector2D
---@return number
function Vector2D.magnitudeSq(a)
    return a.x * a.x + a.y * a.y
end

--- A zero vector returns a zero vector
---@param a Vector2D
---@return Vector2D
function Vector2D.normalize(a)
    local mag = math.sqrt(a.x * a.x + a.y * a.y)
    if mag == 0 then
        return {x = 0, y = 0}
    end
    return {x = a.x / mag, y = a.y / mag}
end

---@param a Vector2D
---@param b Vector2D
---@return number
function Vector2D.dot(a, b)
    return a.x * b.x + a.y * b.y
end

---@param a Vector2D
---@param b Vector2D
---@return number
function Vector2D.dist(a, b)
    return math.sqrt(Vector2D.distSq(a, b))
end

--- Cheaper than dist for comparisons
---@param a Vector2D
---@param b Vector2D
---@return number
function Vector2D.distSq(a, b)
    local dx, dy = b.x - a.x, b.y - a.y
    return dx * dx + dy * dy
end

---@param a Vector2D
---@param b Vector2D
---@param t number 0 returns a, 1 returns b
---@return Vector2D
function Vector2D.lerp(a, b, t)
    return {x = a.x + (b.x - a.x) * t, y = a.y + (b.y - a.y) * t}
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

---@param a Vector2D
---@return string
function Vector2D.tostring(a)
    return "Vector2D(" .. a.x .. ", " .. a.y .. ")"
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
    return {x = -a.y, y = a.x}
end

return Vector2D
