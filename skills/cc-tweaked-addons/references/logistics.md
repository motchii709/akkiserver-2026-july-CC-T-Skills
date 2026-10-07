# Logistics recipe — gathering Schematicannon materials via Create package logistics

Standard in-game-Lua-only procedure that works from any agent environment.
All you need is an advanced computer wired as below.

## Required blocks (in-game placement)

Wire an advanced computer with cable to a StockTicker / RedstoneRequester /
Frogport (address `Generated` + adjacent crate) / monitor. Attach a network link
to the storage crate. The logistics link means StockTicker, Requester, packager,
and network-link-attached storage all sit on the same logistics network.
Set the Frogport address by right-clicking the block, or with
`setAddress("Generated")`.

```lua
-- sanity check: list type names
for _, n in ipairs(peripheral.getNames()) do print(n, peripheral.getType(n)) end
```

## Standard loop (materials → orders → shortfall report)

```lua
local ticker = peripheral.find("Create_StockTicker")
local req = peripheral.find("Create_RedstoneRequester")

-- 1. Read stock (accurate rollup of actual stock, in-transit excluded)
local stock = ticker.stock()  -- e.g. { { name="minecraft:oak_log", count=64 } }

-- 2. Diff against the materials list.
--    materials = block rollup of the schematic (.nbt), parsed outside the game
--    and brought in (fluid blocks excluded, solids only).
--    The Schematicannon itself has no peripheral, hence the .nbt workaround.

-- 3. Order what is in stock, 9 types at a time (max 9/call, count<=256 each)
req.setAddress("Generated")
local batch = {
  {name="minecraft:oak_log", count=64},
  {name="minecraft:iron_ingot", count=32},
}
req.setRequest(table.unpack(batch))
req.request()  -- fires immediately from Lua; no redstone signal needed
-- for craftable gaps (leading int count first — jar-measured signature):
-- req.setCraftingRequest(1, {name="minecraft:oak_planks", count=16}); req.request()

-- 4. Check arrival: look inside the Generated port
local frog = peripheral.find("Create_Frogport")
for slot, item in pairs(frog.list()) do print(slot, item.name, item.count) end

-- 5. Show only raw materials missing from the whole network on the monitor
local mon = peripheral.find("monitor")
mon.clear(); mon.setCursorPos(1, 1)
mon.write("Bring minecraft:oak_log x2 to storage")
```

## Waiting for events

```lua
-- wait for a package arrival (confirm exact event names with os.pullEvent())
local ev = {os.pullEvent()}
print(textutils.serialise(ev))
```

## Notes

- `stock()` excludes in-transit packages. Do the anti-double-order diff on the agent side.
- `setRequest` takes max 9 types per call, each count<=256. Slice and repeat.
- `setConfiguration("send_recieve")` is that exact spelling (not "receive").
- The Schematicannon auto-loads from the adjacent storage, so once materials are
  complete at Generated, just fire the cannon.
