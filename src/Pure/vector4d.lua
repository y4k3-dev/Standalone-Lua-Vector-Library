local Vector4D = {}

--- Default threshold used when comparing vectors
Vector4D.EPSILON = 0.00001

---@class Vector4D
---@field x number
---@field y number
---@field z number
---@field w number

--- Creates a new 4D vector
---@param x? number
---@param y? number
---@param z? number
---@param w? number
---@return Vector4D
function Vector4D.new(x, y, z, w)
    return {x = x or 0, y = y or 0, z = z or 0, w = w or 0}
end

--- Returns a new vector with the same values
---@param a Vector4D
---@return Vector4D
function Vector4D.clone(a)
    return {x = a.x, y = a.y, z = a.z, w = a.w}
end

---@param a Vector4D
---@param b Vector4D
---@return Vector4D
function Vector4D.add(a, b)
    return {x = a.x + b.x, y = a.y + b.y, z = a.z + b.z, w = a.w + b.w}
end

---@param a Vector4D
---@param b Vector4D
---@return Vector4D
function Vector4D.sub(a, b)
    return {x = a.x - b.x, y = a.y - b.y, z = a.z - b.z, w = a.w - b.w}
end

--- Multiplies by a scalar, or element-wise by another vector
---@param a Vector4D|number
---@param b Vector4D|number
---@return Vector4D
function Vector4D.mul(a, b)
    if type(a) == "number" then
        return {x = a * b.x, y = a * b.y, z = a * b.z, w = a * b.w}
    elseif type(b) == "number" then
        return {x = a.x * b, y = a.y * b, z = a.z * b, w = a.w * b}
    end
    return {x = a.x * b.x, y = a.y * b.y, z = a.z * b.z, w = a.w * b.w}
end

--- Divides by a scalar, or element-wise by another vector
---@param a Vector4D|number
---@param b Vector4D|number
---@return Vector4D
function Vector4D.div(a, b)
    if type(a) == "number" then
        return {x = a / b.x, y = a / b.y, z = a / b.z, w = a / b.w}
    elseif type(b) == "number" then
        return {x = a.x / b, y = a.y / b, z = a.z / b, w = a.w / b}
    end
    return {x = a.x / b.x, y = a.y / b.y, z = a.z / b.z, w = a.w / b.w}
end

---@param a Vector4D
---@return Vector4D
function Vector4D.negate(a)
    return {x = -a.x, y = -a.y, z = -a.z, w = -a.w}
end

---@param a Vector4D
---@return number
function Vector4D.magnitude(a)
    return math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w)
end

--- Cheaper than magnitude for comparisons
---@param a Vector4D
---@return number
function Vector4D.magnitudeSq(a)
    return a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w
end

--- A zero vector returns a zero vector
---@param a Vector4D
---@return Vector4D
function Vector4D.normalize(a)
    local mag = math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w)
    if mag == 0 then
        return {x = 0, y = 0, z = 0, w = 0}
    end
    return {x = a.x / mag, y = a.y / mag, z = a.z / mag, w = a.w / mag}
end

---@param a Vector4D
---@param b Vector4D
---@return number
function Vector4D.dot(a, b)
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
end

---@param a Vector4D
---@param b Vector4D
---@return number
function Vector4D.dist(a, b)
    return math.sqrt(Vector4D.distSq(a, b))
end

--- Cheaper than dist for comparisons
---@param a Vector4D
---@param b Vector4D
---@return number
function Vector4D.distSq(a, b)
    local dx, dy, dz, dw = b.x - a.x, b.y - a.y, b.z - a.z, b.w - a.w
    return dx * dx + dy * dy + dz * dz + dw * dw
end

---@param a Vector4D
---@param b Vector4D
---@param t number 0 returns a, 1 returns b
---@return Vector4D
function Vector4D.lerp(a, b, t)
    return {
        x = a.x + (b.x - a.x) * t,
        y = a.y + (b.y - a.y) * t,
        z = a.z + (b.z - a.z) * t,
        w = a.w + (b.w - a.w) * t
    }
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

---@param a Vector4D
---@return string
function Vector4D.tostring(a)
    return "Vector4D(" .. a.x .. ", " .. a.y .. ", " .. a.z .. ", " .. a.w .. ")"
end

return Vector4D
