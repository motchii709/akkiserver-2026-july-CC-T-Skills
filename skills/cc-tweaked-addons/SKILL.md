---
name: cc-tweaked-addons
description: Operation guide for ComputerCraft: Tweaked and its addon mods on Minecraft 1.21.1/NeoForge. Covers peripheral types and Lua methods for Create built-ins, CC:C Bridge, Advanced Peripherals, Tom's Peripherals, Tweaked Controllers, Deep Seas, and Sable. Read when writing in-game Lua, operating peripherals, or building logistics orders.
---

# cc-tweaked-addons — ComputerCraft: Tweaked + Addons

Target: Minecraft 1.21.1 / NeoForge with CC: Tweaked 1.120.0 and the addons below.
**All API tables are backed by javap inspection of the bundled jars plus official docs**
(no guesswork).

## 0. Mod set (jar-measured versions)

| Mod | In-jar version | Role |
|---|---|---|
| CC: Tweaked | 1.120.0 (`computercraft`) | Core. Computers/turtles/monitors/modems |
| Create | 6.0.10 | 18 built-in CC-compatible peripherals |
| CC:C Bridge | 1.7.3 (`cccbridge`) | Create display / redstone / misc, 5 types |
| Advanced Peripherals | 0.7.62b | General-purpose peripheral set (below) |
| Tom's Peripherals | 1.3.1 (`toms_peripherals`) | GPU drawing, keyboard, hi-res monitors, etc. |
| Create: Tweaked Controllers | 1.21.1-1.2.7 | Joystick controller integration |
| CC: Deep Seas | 1.1.1 (`cc_deepseas`) | Create Submarine integration |
| CC: Sable | 1.3.4 (`cc_sable`) | Sable (VS-style physics) integration, **Lua API form** |
| DebugBridge | 2.0.0 | Not CC. Client-side WebSocket REPL, out of scope |

Note: Advanced Peripherals ships `me_bridge` / `rs_bridge` classes, but they have
nothing to connect to unless AE2 / Refined Storage / Mekanism are also installed.
`colony_integrator` works when MineColonies is present.

## 1. Basic pattern

```lua
-- list -> find by type -> wrap
for _, n in ipairs(peripheral.getNames()) do print(n, peripheral.getType(n)) end
local ticker = peripheral.find("Create_StockTicker")  -- find by type name
local p = peripheral.wrap("right")                    -- or by attached side
```

Use exact type strings (`chat_box` family is snake_case on 1.21.1, not legacy `chatBox`).
Details live in `references/`:

- 18 Create built-ins → [create.md](references/create.md) (logistics core: StockTicker/Requester/Frogport)
- 5 CC:C Bridge types → [cccbridge.md](references/cccbridge.md)
- Advanced Peripherals → [advanced-peripherals.md](references/advanced-peripherals.md)
- Tom's (GPU etc.) → [toms.md](references/toms.md)
- Tweaked Controllers / Deep Seas / Sable → [misc-addons.md](references/misc-addons.md)
- Standard logistics recipe (materials → orders → shortfall report) → [logistics.md](references/logistics.md)
- LuaLS type definitions (`types/`) → [types.md](references/types.md)

## 2. Pack-level constraints (measured from configs)

- CC `http` API is enabled, but `$private` (localhost, 192.168.x, etc.) is denied
  while `"*"` is allowed. No inbound connections from in-game computers.
  External HTTPS works (send a browser-like User-Agent if the server's bot
  detection blocks you).
- Turtles need fuel (`need_fuel=true`). Advanced pocket upgrades consume no fuel.
- ChatBox: message cooldown 100 ticks (~5s), max 1024 chars, unlimited range,
  multidimensional. `/execute /op /give /summon` and friends are banned from
  `run_command` (config).
- RedstoneRequester `setRequest` takes **max 9 item types per call, count<=256 each**
  (jar-measured). Slice larger orders into repeated `setRequest` + `request()` calls.
- Frogport addresses: right-click the block to type one, or call
  `setAddress("Generated")`.

## 3. Logistics recipe

The standard procedure for gathering Schematicannon materials through the Create
package logistics network is in [logistics.md](references/logistics.md).
Stock check → order firing → arrival check → shortfall report to a human:
the same Lua runs from any agent environment.
