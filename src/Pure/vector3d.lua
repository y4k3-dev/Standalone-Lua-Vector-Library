local Vector3D = {}

--- Default threshold used when comparing vectors
Vector3D.EPSILON = 0.00001

---@class Vector3D
---@field x number
---@field y number
---@field z number

--- Creates a new 3D vector
---@param x? number
---@param y? number
---@param z? number
---@return Vector3D
function Vector3D.new(x, y, z)
    return {x = x or 0, y = y or 0, z = z or 0}
end

--- Returns a new vector with the same values
---@param a Vector3D
---@return Vector3D
function Vector3D.clone(a)
    return {x = a.x, y = a.y, z = a.z}
end

---@param a Vector3D
---@param b Vector3D
---@return Vector3D
function Vector3D.add(a, b)
    return {x = a.x + b.x, y = a.y + b.y, z = a.z + b.z}
end

---@param a Vector3D
---@param b Vector3D
---@return Vector3D
function Vector3D.sub(a, b)
    return {x = a.x - b.x, y = a.y - b.y, z = a.z - b.z}
end

--- Multiplies by a scalar, or element-wise by another vector
---@param a Vector3D|number
---@param b Vector3D|number
---@return Vector3D
function Vector3D.mul(a, b)
    if type(a) == "number" then
        return {x = a * b.x, y = a * b.y, z = a * b.z}
    elseif type(b) == "number" then
        return {x = a.x * b, y = a.y * b, z = a.z * b}
    end
    return {x = a.x * b.x, y = a.y * b.y, z = a.z * b.z}
end

--- Divides by a scalar, or element-wise by another vector
---@param a Vector3D|number
---@param b Vector3D|number
---@return Vector3D
function Vector3D.div(a, b)
    if type(a) == "number" then
        return {x = a / b.x, y = a / b.y, z = a / b.z}
    elseif type(b) == "number" then
        return {x = a.x / b, y = a.y / b, z = a.z / b}
    end
    return {x = a.x / b.x, y = a.y / b.y, z = a.z / b.z}
end

---@param a Vector3D
---@return Vector3D
function Vector3D.negate(a)
    return {x = -a.x, y = -a.y, z = -a.z}
end

---@param a Vector3D
---@return number
function Vector3D.magnitude(a)
    return math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
end

--- Cheaper than magnitude for comparisons
---@param a Vector3D
---@return number
function Vector3D.magnitudeSq(a)
    return a.x * a.x + a.y * a.y + a.z * a.z
end

--- A zero vector returns a zero vector
---@param a Vector3D
---@return Vector3D
function Vector3D.normalize(a)
    local mag = math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
    if mag == 0 then
        return {x = 0, y = 0, z = 0}
    end
    return {x = a.x / mag, y = a.y / mag, z = a.z / mag}
end

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
    return {
        x = a.y * b.z - a.z * b.y,
        y = a.z * b.x - a.x * b.z,
        z = a.x * b.y - a.y * b.x
    }
end

---@param a Vector3D
---@param b Vector3D
---@return number
function Vector3D.dist(a, b)
    return math.sqrt(Vector3D.distSq(a, b))
end

--- Cheaper than dist for comparisons
---@param a Vector3D
---@param b Vector3D
---@return number
function Vector3D.distSq(a, b)
    local dx, dy, dz = b.x - a.x, b.y - a.y, b.z - a.z
    return dx * dx + dy * dy + dz * dz
end

---@param a Vector3D
---@param b Vector3D
---@param t number 0 returns a, 1 returns b
---@return Vector3D
function Vector3D.lerp(a, b, t)
    return {
        x = a.x + (b.x - a.x) * t,
        y = a.y + (b.y - a.y) * t,
        z = a.z + (b.z - a.z) * t
    }
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

---@param a Vector3D
---@return string
function Vector3D.tostring(a)
    return "Vector3D(" .. a.x .. ", " .. a.y .. ", " .. a.z .. ")"
end

return Vector3D
