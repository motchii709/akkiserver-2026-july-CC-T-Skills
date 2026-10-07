# CC:C Bridge (cccbridge 1.7.3 / jar-measured + official wiki)

Five types for driving Create displays, redstone, and misc from CC.
Type strings and method names are jar-measured with javap; usage is backed by the
[official Peripherals page](https://cccbridge.kleinbox.dev/peripherals/) and the
[wiki](https://github.com/tweaked-programs/cccbridge/wiki).

## `scroller` — number picker pane

```lua
local sc = peripheral.find("scroller")
sc.setLock(true)  -- edit lock while changing values (see also: isLocked/setLock)
print(sc.isLocked())
print(sc.getValue())  -- current value (-limit..limit)
sc.setValue(32)
print(sc.getLimit())
sc.setLimit(64)  -- cap. With minus spectrum enabled: -limit..limit, else 0..limit
-- (toggle the minus spectrum with toggleMinusSpectrum below)
print(sc.hasMinusSpectrum())
sc.toggleMinusSpectrum(true)
sc.setLock(false)
os.pullEvent("scroller_changed")  -- wait until a player changes the value
```

## `create_source` — display sender block (term-compatible)

Sends text to Create displays. Behaves like the Window API.

```lua
local src = peripheral.find("create_source")
local w, h = src.getSize()
src.clear()
src.setCursorPos(math.floor(w/2 - #"Hello World"/2), math.floor(h/2))
src.write("Hello World")
print(src.getLine(math.floor(h/2)))  -- read back the written line (text only)
src.setSize(51, 19)
print(table.unpack(src.getContent()))
-- scroll(yDiff) / clearLine() / getCursorPos() work like term
```

## `create_target` — mock display target

Receives data from Create display sources for Lua to read.

```lua
local t = peripheral.find("create_target")
t.resize(32, 8)
for _, line in ipairs(t.dump()) do print(line) end
print(t.getLine(1))  -- e.g. read just the stress-value line
print(table.unpack(t.getSize()))
```

## `animatronic` — posable figure

```lua
local a = peripheral.find("animatronic")
a.setFace("happy")  -- normal / happy / question / sad
a.setTransition("rusty")  -- linear / none / rusty (default rusty)
a.setHeadRot(0, 0, 0)  -- each -180..180 (body X allows full 360)
a.setBodyRot(0, 180, 0)
a.setLeftArmRot(0, 0, 0)
a.setRightArmRot(0, 0, 90)
a.push()  -- apply (nothing renders until called; stored values reset after)
local x, y, z = a.getStoredHeadRot()
local x2, y2, z2 = a.getAppliedHeadRot()
-- getStoredBodyRot / getStoredLeftArmRot / getStoredRightArmRot and
-- getAppliedBodyRot / getAppliedLeftArmRot / getAppliedRightArmRot likewise
```

## `redrouter` — 6-sided redstone router

For more sides than a computer offers.
Side names (computer-relative) are `front/back/left/right/top/bottom` (jar-measured).

```lua
local r = peripheral.find("redrouter")
r.setOutput("left", true)
print(r.getOutput("left"), r.getInput("front"))
r.setAnalogOutput("back", 10)  -- 0..15, out of range throws LuaException
print(r.getAnalogOutput("back"), r.getAnalogInput("back"))
os.pullEvent("redstone")
```

## Note: no `train_station` in this jar

The old wiki documents `train_station` (assemble/disassemble/getBogeys etc.), but
the 1.7.3 jar contains only the 5 peripheral classes above — no station class.
For trains, use Create's built-in `Create_Station` (→ [create.md](create.md)).
