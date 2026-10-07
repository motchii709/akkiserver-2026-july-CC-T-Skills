# その他アドオン (jar実測)

## Create: Tweaked Controllers (`tweaked_controller`)

操縦桿コントローラ (Tweaked Lectern Controller) の CC 連携。
型は jar 実測 `tweaked_controller`。ボタン [1,15]・軸 [1,6] (範囲外は LuaException)。

```lua
local c = peripheral.find("tweaked_controller")
print(c.hasUser(), c.getUserUUID())
print(c.getButton(1))   -- 1..15
print(c.getAxis(1))     -- 1..6
c.setFullPrecision(true); print(c.isFullPrecision())
local ev, using, player = os.pullEvent("controller_start_using")  -- / controller_stop_using
```

## CC: Deep Seas (潜水艦)

Create Submarine 側ブロックの CC 連携3種。型は jar 実測。
潜水艦 Mod (`create_submarine` 2.x) はこのパックに同梱あり。

```lua
-- oxygenator (= Hull Controller。型名注意: hull ではない)
local h = peripheral.find("oxygenator")
print(h.getCurrentSubLevelID())
for _, comp in ipairs(h.getCompartments()) do print(comp.name or comp.id) end

-- ballast_vent (流体タンク付き。generic inventory/fluid メソッド併用可)
local b = peripheral.find("ballast_vent")
print(b.tanks())
b.pushFluid("left", 1000)          -- (面, 量, 流体名省略可)
b.pullFluid("left", 1000)
print(b.isAnyHolesFaceSubmerged())

-- water_thruster (同上 + 推力系)
local t = peripheral.find("water_thruster")
print(t.tanks())
t.pushFluid("left", 500); t.pullFluid("left", 500)
print(t.getThrust(), t.getScaledThrust())
print(t.getAirflow(), t.getAirflowScaling(), t.getCurrentAirPressure())
print(t.isActive())
```

## CC: Sable (Lua API 形式)

周辺機器ではなく **Lua API** (`aero`/`aerodynamics`・`sublevel`) として提供されます。
Sable 本体 (`sable` 1.x) はこのパックに同梱あり。

```lua
-- 空力 (高度 x,y,z 位置の気圧・重力・磁北など)
print(aero.getAirPressure(0, 64, 0))
print(aero.getGravity().y)
print(aero.getMagneticNorth().x)
print(aero.getUniversalDrag())
print(aero.getRaw(), aero.getDefault())

-- 所属 SubLevel (船・潜水艦などの物理単位)
print(sublevel.isInPlotGrid())
print(sublevel.getUniqueId(), sublevel.getName())
sublevel.setName("ferry-1")
print(sublevel.getMass(), sublevel.getInverseMass())
print(sublevel.getVelocity(), sublevel.getLinearVelocity(), sublevel.getAngularVelocity())
print(sublevel.getCenterOfMass())
print(sublevel.getLogicalPose(), sublevel.getLastPose())
print(sublevel.getInertiaTensor())
```

## DebugBridge (CC ではない)

`debugbridge` 2.0.0 はクライアント側 WebSocket REPL (Groovy-Java ブリッジ)。
CC の peripheral ではないので本スキルでは扱わない。
使う場合は Mod 側の README (jar 内 `assets/debugbridge/`) を参照。
