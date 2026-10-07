# Create built-in peripherals (Create 6.0.10 / jar-measured)

Create itself bundles CC: Tweaked integration. Type strings and method names below
are javap-measured from
`<jar-root>/com/simibubi/create/compat/computercraft/implementation/peripherals/*.class`
in `create-1.21.1-6.0.10.jar`. Lua type names match `peripheral.getType()` returns.

## Logistics

### `Create_StockTicker` — stock ledger

```lua
local t = peripheral.find("Create_StockTicker")
local summary = t.stock()  -- e.g. { { name="minecraft:oak_log", count=64 } }
local full = t.stock(true)  -- with details (argument is Optional<Boolean>)
local d = t.getStockItemDetail(1)  -- index into stock()
t.requestFiltered("minecraft:oak_log", {name="minecraft:oak_log", count=64})
-- address is REQUIRED and the call auto-fires as a RESTOCK broadcast
-- (no separate request() step). Returns total matched item count.
-- Each filter table supports _requestCount cap + _op any/all/not/type and
-- glob/regex operators (deep-match per ComputerUtil); verify shapes in-game.
```

- `stock()` returns an accurate rollup of actual stock (in-transit packages excluded).
- `requestFiltered(address, ...filterTables)` returns an int (requested count).

### `Create_RedstoneRequester` — order launcher

```lua
local r = peripheral.find("Create_RedstoneRequester")
r.setAddress("Generated")
r.setRequest({name="minecraft:oak_log", count=64}, {name="minecraft:iron_ingot", count=32})
r.request()
r.setCraftingRequest(1, {name="minecraft:oak_planks", count=16})  -- crafting order
-- NOTE: leading int count first, then item tables (jar-measured signature
-- setCraftingRequest(count:int, ...items); the gameplay meaning of the leading
-- count is unconfirmed — verify in-game before relying on it)
local cur = r.getRequest()  -- 1-based keys; empty (air) slots omitted; {} = nothing staged
print(r.getAddress(), r.getConfiguration())
-- Configuration is exactly "allow_partial" or "strict" (anything else throws):
-- r.setConfiguration("allow_partial")
```

- **`setRequest` takes max 9 item types per call, each count <= 256** (jar-measured).
  Slice larger orders into repeated `setRequest` + `request()` calls.
  Bare-string args mean count 1; missing args pad with air placeholders.
- `getRequest()` shows the pending request before firing.
- `request()` fires immediately from Lua — no redstone signal needed (the name
  is historical). Strict mode (`"strict"`) aborts the whole request on any
  shortfall; `"allow_partial"` ships what is available.

### `Create_Frogport` / `Create_Postbox` — addressed package ports

```lua
local f = peripheral.find("Create_Frogport")
f.setAddress("Generated")
print(f.getAddress())
f.setConfiguration("send_recieve")  -- send/receive mode (spelling as measured, not "receive")
local items = f.list()  -- e.g. { [1]={ name="minecraft:oak_log", count=64 } }
local d = f.getItemDetail(1)
```

- Fires `package_received` / `package_sent` events (confirm exact strings in-game
  with an `os.pullEvent()` capture loop; the jar's event classes are named
  `PackageEvent` / `RepackageEvent` / ... and peripherals queue dynamic
  status strings, not class names).
- Postbox has the same shape
  (`setAddress/getAddress/getConfiguration/setConfiguration/list/getItemDetail`).
- `setConfiguration` accepts only `"send_recieve" | "send"` (else LuaException)
  and returns boolean.

### `Create_Packager` / `Create_Repackager` — packagers

```lua
local pk = peripheral.find("Create_Packager")
pk.setAddress("Generated")  -- Optional<String>, may be omitted
local ok = pk.makePackage()  -- packs contents, returns boolean;
  -- false means both "already holding a box" and "nothing to pack"
local box = pk.getPackage()  -- PackageLuaObject, or nil when no package present
assert(box, "no package — nothing packed?")
print(box.getAddress())
box.setAddress("Generated")
local items = box.list()
if box.hasOrderData() then
  local o = box.getOrderData()
  print(o.getOrderID(), o.getIndex(), o.isFinal(), o.getLinkIndex(), o.isFinalLink())
  local list = o.list()  -- order lines
  local crafts = o.getCrafts()  -- crafting lines
end
```

## Trains

### `Create_Station`

```lua
local s = peripheral.find("Create_Station")
s.assemble()
-- s.disassemble()  -- disassemble
s.setAssemblyMode(true); print(s.isInAssemblyMode())
s.setStationName("depot"); print(s.getStationName())
s.setTrainName("freight-1"); print(s.getTrainName())
print(s.isTrainPresent(), s.isTrainImminent(), s.isTrainEnroute())
print(s.hasSchedule())
local sch = s.getSchedule()
s.setSchedule(sch)  -- round-trip; edit the table to change it
-- Async (MethodResult): results arrive as events
s.canTrainReach("north-depot")
s.distanceTo("north-depot")
```

### `Create_TrainObserver`

```lua
local o = peripheral.find("Create_TrainObserver")
print(o.isTrainPassing())
print(o.getPassingTrainName())
```

### `Create_Signal`

```lua
local sg = peripheral.find("Create_Signal")
print(sg.getState(), sg.getSignalType())
print(sg.isForcedRed()); sg.setForcedRed(true)
sg.cycleSignalType()
local trains = sg.listBlockingTrainNames()
```

## Rotation / kinetics

### `Create_RotationSpeedController`

```lua
local c = peripheral.find("Create_RotationSpeedController")
c.setTargetSpeed(64); print(c.getTargetSpeed())
```

### `Create_CreativeMotor`

```lua
local m = peripheral.find("Create_CreativeMotor")
m.setGeneratedSpeed(256); print(m.getGeneratedSpeed())
```

### `Create_SequencedGearshift`

```lua
local g = peripheral.find("Create_SequencedGearshift")
-- IArguments (concrete shape TBD in-game; verify with peripheral.getMethods)
g.rotate({direction="clockwise", angle=90})
g.move({distance=1})
print(g.isRunning())
```

### `Create_Sticker`

```lua
local st = peripheral.find("Create_Sticker")
print(st.isExtended(), st.isAttachedToBlock())
st.extend()
-- st.retract()  -- retract
-- st.toggle()   -- toggle
```

## Display / gauges / shop

### `Create_NixieTube`

```lua
local n = peripheral.find("Create_NixieTube")
n.setText("0123")  -- IArguments (text + color etc.)
n.setTextColour("red")  -- setTextColor is an alias
-- setSignal takes IArguments (concrete shape TBD in-game)
```

See [types.md](types.md) for the LuaLS-annotated `setSignal(led1, led2)` /
`setText` / `setTextColor` signatures from the shared `class_set.d.lua`.

### `Create_DisplayLink` — direct panel writing (term subset)

```lua
local d = peripheral.find("Create_DisplayLink")
d.setCursorPos(1, 1)
print(table.unpack(d.getCursorPos()))
print(table.unpack(d.getSize()))
print(d.isColor())  -- isColour is an alias
d.write("hello")
d.writeBytes(72, 101, 108, 108, 111)  -- IArguments ("Hello" as bytes)
d.clearLine(); d.clear(); d.update()
```

### `Create_Stressometer` / `Create_Speedometer`

```lua
print(peripheral.find("Create_Stressometer").getStress())
print(peripheral.find("Create_Stressometer").getStressCapacity())
print(peripheral.find("Create_Speedometer").getSpeed())
```

### `Create_TableClothShop`

```lua
local sh = peripheral.find("Create_TableClothShop")
print(sh.isShop())
sh.setAddress("shop-1"); print(sh.getAddress())
print(sh.getPriceTagCount()); sh.setPriceTagCount(5)
local wares = sh.getWares()
sh.setWares(sh.getWares())  -- round-trip; edit the table to change it
local price = sh.getPriceTagItem()
sh.setPriceTagItem("minecraft:diamond")  -- Optional<String>
```

## Events

Create peripherals raise computer events via `prepareComputerEvent`.
Jar-measured event classes: `PackageEvent` / `RepackageEvent` /
`StationTrainPresenceEvent` / `TrainPassEvent` / `SignalStateChangeEvent` /
`KineticsChangeEvent`. Wait with `os.pullEvent()`; confirm the exact event-name
strings in-game with a capture loop.
