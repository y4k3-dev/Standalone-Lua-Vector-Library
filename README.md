# Lua Vector Library

A testing ground for learning, implementing and proving the core 2D and 3D mathematics used in game development.

It provides standalone, drag-and-drop vector libraries for 2D, 3D and 4D, written in plain Lua with no external dependencies. The aim is to show clean architecture, thorough testing and game-loop-friendly optimisations without a bloated framework.

## Two Flavours: Object and Pure

Some heavily sandboxed Lua environments, such as certain game engines and modding APIs, block `setmetatable` for security or performance reasons. To work everywhere, every vector comes in two versions that share the same maths and the same function names.

| | `src/Object/` | `src/Pure/` |
| --- | --- | --- |
| Vectors are | Instances with a metatable | Plain tables, e.g. `{x = 1, y = 2}` |
| Operators (`+ - * / ==`, unary `-`) | Yes | No |
| Method syntax (`v:normalize()`) | Yes | No |
| `tostring(v)` | Yes | Use `Vector2D.tostring(v)` |
| Needs `setmetatable` | Yes | No |

Both versions expose the functional form, `Vector2D.add(a, b)`, so code written against it runs with either library. If a sandbox rejects metatables, swap the `require` path from `Object` to `Pure` and keep going.

## Installation

Copy the file you need into your project. Each file is self-contained.

```
src/
├── Object/
│   ├── vector2d.lua
│   ├── vector3d.lua
│   └── vector4d.lua
└── Pure/
    ├── vector2d.lua
    ├── vector3d.lua
    └── vector4d.lua
```

Works with Lua 5.1, 5.2, 5.3, 5.4 and LuaJIT.

## Usage

### Object

```lua
local Vector2D = require("Object.vector2d")

local position = Vector2D.new(10, 20)
local velocity = Vector2D.new(3, -4)

position = position + velocity * dt
print(position)                        --> Vector2D(...)
print(velocity:magnitude())            --> 5

if position:distSq(enemy) <= range * range then
    -- in range, no square root needed
end
```

### Pure

```lua
local Vector2D = require("Pure.vector2d")

local position = Vector2D.new(10, 20)
local velocity = {x = 3, y = -4}       -- any table with x and y works

position = Vector2D.add(position, Vector2D.mul(velocity, dt))
print(Vector2D.tostring(position))     --> Vector2D(...)
print(Vector2D.magnitude(velocity))    --> 5
```

## API

All functions return new vectors and never change their inputs. Examples use `Vector2D`; `Vector3D` and `Vector4D` work the same way, with `z` and `w` added.

### Creation

| Function | Description |
| --- | --- |
| `new(x, y)` | Creates a vector. Missing components default to `0`. |
| `clone(v)` | Returns a copy, so changing it won't affect the original. |

### Arithmetic

| Function | Operator (Object) | Description |
| --- | --- | --- |
| `add(a, b)` | `a + b` | Adds each component. |
| `sub(a, b)` | `a - b` | Subtracts each component. |
| `mul(a, b)` | `a * b` | Multiplies by a number on either side, or component by component with another vector. |
| `div(a, b)` | `a / b` | Divides by a number, divides a number by each component, or divides component by component. |
| `negate(v)` | `-v` | Flips the sign of each component. |

### Vector Maths

| Function | Description |
| --- | --- |
| `magnitude(v)` | Length of the vector. |
| `magnitudeSq(v)` | Squared length. Much cheaper than `magnitude` when you only need to compare lengths. |
| `normalize(v)` | Same direction with a length of 1. A zero vector returns a zero vector instead of `NaN`. |
| `dot(a, b)` | Dot product. Positive when facing the same way, `0` when perpendicular, negative when facing away. |
| `dist(a, b)` | Distance between two points. |
| `distSq(a, b)` | Squared distance. Use it for range and collision checks to skip the square root. |

### Utilities

| Function | Description |
| --- | --- |
| `lerp(a, b, t)` | Linear interpolation: `t = 0` returns `a`, `t = 1` returns `b`. Useful for smooth movement, camera follow and animation. |
| `equals(a, b, epsilon?)` | Compares with a tolerance to handle floating-point error. Defaults to `Vector2D.EPSILON` (`0.00001`). In the Object version, `==` uses this too. |
| `tostring(v)` | Formats the vector, e.g. `Vector2D(3, 4)`. |

### 2D Only

| Function | Description |
| --- | --- |
| `fromAngle(radians)` | Creates a vector of length 1 pointing in that direction. |
| `angle(v)` | Direction of the vector in radians. |
| `perpendicular(v)` | Rotates the vector 90° anticlockwise: `(x, y)` becomes `(-y, x)`. |

### 3D Only

| Function | Description |
| --- | --- |
| `cross(a, b)` | Cross product, a vector perpendicular to both inputs. Used for surface normals and building orientation axes. |

## Examples

Runnable examples for each dimension live in `examples/`, covering both versions with game-dev scenarios: moving towards a target, range checks, camera smoothing, lighting, triangle normals and colour fades. Run them from the project root:

```
lua examples/vector2d_example.lua
lua examples/vector3d_example.lua
lua examples/vector4d_example.lua
```

## Tests

The specs in `tests/` use [busted](https://lunarmodules.github.io/busted/). Every shared function is tested against both the Object and Pure versions. There are also checks that the Object operators work, and that the Pure versions load in a sandbox without `setmetatable`.

```
luarocks install busted
busted tests
```

## License

MIT. See [LICENSE](LICENSE).
