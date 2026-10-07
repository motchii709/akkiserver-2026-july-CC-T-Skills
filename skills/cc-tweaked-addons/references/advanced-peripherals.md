# Advanced Peripherals (0.7.62b / jar-measured + official docs)

General-purpose peripheral set. `PERIPHERAL_TYPE` constants and method signatures
are jar-measured with javap. On 1.21.1 the type names are **snake_case**
(`chat_box`, not legacy `chatBox`). Lua arities and event names are backed by the
[official 0.7 docs](https://docs.advanced-peripherals.de/0.7/).

## Availability matrix

Whether each type is usable depends on companion mods being installed:

| Type | Needs | Notes |
|---|---|---|
| `chat_box` | — | Cooldown 100 ticks, max 1024 chars, unlimited range, multidimensional |
| `player_detector` | — | Unlimited range, multidimensional, extended `getPlayerPos` info |
| `environment_detector` | — | |
| `geo_scanner` | — | Fuel-costed (see below) |
| `inventory_manager` | — | Owner is bound to the placer |
| `nbt_storage` | — | Stores up to 1 MiB strings |
| `energy_detector` | — | |
| `block_reader` | — | |
| `colony_integrator` | MineColonies | |
| `compass` (turtle) | — | `getFacing()` |
| `chunky` (turtle) | — | Chunk-loading upgrade |
| automata cores (turtle) | — | weak/end/husbandry + 3 overpowered tiers |
| `me_bridge` / `rs_bridge` | AE2 / RS / Mekanism | Classes exist but connect nowhere without those mods |
| redstone integrator | — | **Removed** in 1.21.1-0.7.50b; use CC:T's own redstone relay |

## `chat_box`

```lua
local c = peripheral.find("chat_box")
c.sendMessage("Hello world!")  -- "[AP] Hello world!"
os.sleep(1)  -- leave room for the ~100-tick cooldown
c.sendMessage("I am dave", "Dave")  -- "[Dave] I am dave"
c.sendMessage("Welcome!", "Box", "<>", "&b", 30)  -- range 30, light-blue <> brackets
c.sendMessageToPlayer("Hi", "Player123")
c.sendToastToPlayer("Body text", "Title", "Player123")
local jsonText = textutils.serialiseJSON({{text="Hello", color="aqua"}})
c.sendFormattedMessage(jsonText)  -- JSON text component
local jsonForPlayer = textutils.serialiseJSON({{text="Hi", color="green"}})
c.sendFormattedMessageToPlayer(jsonForPlayer, "Player123")
local toastMsg = textutils.serialiseJSON({{text="Boxed!"}})
local toastTitle = textutils.serialiseJSON({{text="Notice"}})
c.sendFormattedToastToPlayer(toastMsg, toastTitle, "Player123")
local ev, user, msg, uuid, hidden = os.pullEvent("chat")
```

- A leading `$` suppresses the broadcast but still fires the event (hidden message).
- `run_command`-style actions are restricted by config (e.g. `/execute /op /give
  /summon` banned); `chatBoxWrapCommand=true` keeps them privilege-safe.

## `player_detector`

```lua
local d = peripheral.find("player_detector")
local all = d.getOnlinePlayers()
local pos = d.getPlayerPos("Player123")  -- x/y/z/yaw/pitch/health/dimension/uuid etc.
local near = d.getPlayersInRange(30)
local inBox = d.getPlayersInCoords({x=0,y=60,z=0}, {x=16,y=80,z=16})
local inCube = d.getPlayersInCubic(10, 10, 10)  -- centered on detector, w/h/d
print(d.isPlayerInRange(30, "Player123"))
print(d.isPlayersInRange(30))
-- isPlayerInCoords / isPlayerInCubic / isPlayersInCoords / isPlayersInCubic likewise
local ev, user, dev = os.pullEvent("playerClick")
local ev2, user2, dim = os.pullEvent("playerJoin")  -- playerLeave / playerChangedDimension too
```

`getPlayersInCoords` uses a half-open `[x1,x2)` box (x2 side excluded).
Same start and end coordinates always return empty.

## `environment_detector`

```lua
local e = peripheral.find("environment_detector")
print(e.getBiome(), e.getDimension(), e.getTime())
print(e.getSkyLightLevel(), e.getBlockLightLevel(), e.getDayLightLevel())
print(e.isRaining(), e.isThunder(), e.isSunny())
print(e.isSlimeChunk())
print(e.getMoonName(), e.getMoonId())
print(e.listDimensions())
print(e.scanCost(8))  -- fuel-cost estimate for radius
local r = e.scanEntities({"minecraft:zombie"})  -- async MethodResult, result arrives as event
print(e.canSleepHere())
```

## `geo_scanner`

```lua
local g = peripheral.find("geo_scanner")
print(g.cost(8))  -- fuel-cost estimate for radius
local r = g.scan(8)  -- async MethodResult for radius 8, result arrives as event
local c = g.chunkAnalyze()
```

## `inventory_manager` (owner is bound to the placer)

```lua
local m = peripheral.find("inventory_manager")
print(m.getOwner())
local items = m.getItems()
print(m.getItemsChest("left"))  -- list an adjacent chest by side name
print(m.getArmor())
print(m.isPlayerEquipped(), m.isWearing(1))
print(m.getEmptySpace(), m.isSpaceAvailable(), m.getFreeSlot())
print(m.getItemInHand(), m.getItemInOffHand())
m.addItemToPlayer("left", {name="minecraft:torch", count=16})
m.removeItemFromPlayer("left", {name="minecraft:torch", count=16})
```

## `nbt_storage`

```lua
local n = peripheral.find("nbt_storage")
local data = n.read()  -- MethodResult
n.writeTable({key="value"})  -- pass the table to store
n.writeJson('{"a":1}')
```

## `energy_detector`

```lua
local e = peripheral.find("energy_detector")
print(e.getTransferRate())
print(e.getTransferRateLimit())
e.setTransferRateLimit(10000)
```

## `block_reader`

```lua
local b = peripheral.find("block_reader")
print(b.getBlockName())
print(b.getBlockData())  -- tile-entity NBT data
print(b.getBlockStates())
print(b.isTileEntity())
```

## `colony_integrator` (MineColonies)

```lua
local c = peripheral.find("colony_integrator")
print(c.isInColony(), c.getColonyID(), c.getColonyName(), c.getColonyStyle())
print(c.isActive(), c.getHappiness(), c.isUnderAttack(), c.isUnderRaid())
print(c.amountOfCitizens(), c.maxOfCitizens(), c.amountOfGraves())
print(c.amountOfConstructionSites())
print(c.getCitizens(), c.getVisitors(), c.getBuildings())
print(c.getWorkOrders(), c.getResearch(), c.getRequests())
print(c.getWorkOrderResources(1))
print(c.getBuilderResources({x=0, y=64, z=0}))
print(c.isWithin({x=0, y=64, z=0}), c.getLocation())
```

See [types.md](types.md) for LuaLS-annotated colony shapes
(`ColonyCitizen`, `ColonyBuilding`, `ColonyWorkOrder`, ...) from the shared
`class_set.d.lua`.

## Turtle upgrades: `compass` / `chunky` / automata cores

```lua
print(peripheral.find("compass").getFacing())  -- equipped turtle's facing
-- chunky: attach keeps the chunk loaded (radius from config)
-- automata cores (weak/end/husbandry + 3 overpowered tiers) run
-- dig/suck/useOnBlock/useOnAnimal/captureAnimal/warp/accurePlace etc.
-- through withOperation under fuel constraints.
-- Check cooldowns and costs in the config [Operations] section.
```
