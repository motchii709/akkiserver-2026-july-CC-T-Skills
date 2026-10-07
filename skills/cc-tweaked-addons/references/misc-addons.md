# Other addons (jar-measured)

## Create: Tweaked Controllers (`tweaked_controller`)

CC integration for the Tweaked Lectern Controller (joystick controller).
Type is jar-measured `tweaked_controller`. Buttons [1,15], axes [1,6]
(out of range throws LuaException).

```lua
local c = peripheral.find("tweaked_controller")
print(c.hasUser(), c.getUserUUID())
print(c.getButton(1))  -- 1..15
print(c.getAxis(1))  -- 1..6
c.setFullPrecision(true); print(c.isFullPrecision())
-- wiki/doc-backed event names; confirm in-game with an os.pullEvent() capture loop
local ev, using, player = os.pullEvent("controller_start_using")  -- / controller_stop_using
```

## CC: Deep Seas (submarines)

CC integration for three Create Submarine blocks. Types are jar-measured.

```lua
-- oxygenator (= Hull Controller. Note the type name: not "hull")
local h = peripheral.find("oxygenator")
print(h.getCurrentSubLevelID())
for _, comp in ipairs(h.getCompartments()) do print(comp.name or comp.id) end

-- ballast_vent (has fluid tanks; generic inventory/fluid methods apply too)
local b = peripheral.find("ballast_vent")
print(b.tanks())
b.pushFluid("left", 1000)  -- (side, amount, fluid name optional)
b.pullFluid("left", 1000)
print(b.isAnyHolesFaceSubmerged())

-- water_thruster (same as above, plus thrust)
local t = peripheral.find("water_thruster")
print(t.tanks())
t.pushFluid("left", 500); t.pullFluid("left", 500)
print(t.getThrust(), t.getScaledThrust())
print(t.getAirflow(), t.getAirflowScaling(), t.getCurrentAirPressure())
print(t.isActive())
```

## CC: Sable (Lua API form)

Exposed as **Lua APIs** (`aero`/`aerodynamics`, `sublevel`), not peripherals.

```lua
-- aerodynamics (air pressure at x,y,z, gravity, magnetic north, ...)
print(aero.getAirPressure(0, 64, 0))
print(aero.getGravity().y)
print(aero.getMagneticNorth().x)
print(aero.getUniversalDrag())
print(aero.getRaw(), aero.getDefault())

-- owning SubLevel (the physical unit: ship, submarine, ...)
print(sublevel.isInPlotGrid())
print(sublevel.getUniqueId(), sublevel.getName())
sublevel.setName("ferry-1")
print(sublevel.getMass(), sublevel.getInverseMass())
print(sublevel.getVelocity(), sublevel.getLinearVelocity(), sublevel.getAngularVelocity())
print(sublevel.getCenterOfMass())
print(sublevel.getLogicalPose(), sublevel.getLastPose())
print(sublevel.getInertiaTensor())
```

## DebugBridge (not CC)

`debugbridge` 2.0.0 is a client-side WebSocket REPL (Groovy-Java bridge).
It is not a CC peripheral, so this skill does not cover it.
See the mod's own README (inside the jar under `assets/debugbridge/`).
