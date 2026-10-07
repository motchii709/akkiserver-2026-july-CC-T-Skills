---
name: cc-tweaked-addons
description: Operation guide for ComputerCraft: Tweaked and its addon mods on Minecraft 1.21.1/NeoForge. Covers peripheral types and Lua methods for Create built-ins, CC:C Bridge, Advanced Peripherals, Tom's Peripherals, Tweaked Controllers, Deep Seas, and Sable. Read when writing in-game Lua, operating peripherals, or building logistics orders.
---

# cc-tweaked-addons — ComputerCraft: Tweaked + Addons

Target: Minecraft 1.21.1 / NeoForge with CC: Tweaked 1.120.0 and the addons below.
**All API tables are backed by `javap` inspection of the bundled jars plus official docs**
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
-- list -> find by type -> wrap (ALWAYS nil-guard: find returns nil when absent)
for _, n in ipairs(peripheral.getNames()) do print(n, peripheral.getType(n)) end
local ticker = peripheral.find("Create_StockTicker")
assert(ticker, "Create_StockTicker not attached — check wiring/modem attach + getNames()")
local p = peripheral.wrap("right")
assert(p, "nothing wrapped on the right side")
```

### CC:T core survival kit (assumed everywhere below)

- **Wiring first.** Place a Wired Modem against the computer AND against each
  peripheral, join them with Networking Cable, then right-click every modem
  (chat prints the network name). Cable alone does nothing — until clicked,
  `getNames()` is empty and `find`/`wrap` return nil. Side names
  (`left/right/front/...`) are computer-relative. Details: [setup.md](references/setup.md).
- **Globals need no require.** `peripheral`, `term`, `colors`/`colours`, `textutils`,
  `os`, `redstone`/`rs`, `turtle` are auto-loaded. `require("colors")` fails.
- **Monitors need redirect.** `print()` stays on the computer terminal.
  `term.redirect(mon)` sends output to the monitor; restore with
  `term.redirect(term.native())`. Set `mon.setTextScale(0.5)` first and
  `mon.clear()` + `setCursorPos(1,1)` before each redraw.
- **`os.pullEvent` blocks forever** until a matching event (a wrong filter string
  hangs with no error; Ctrl+T raises `terminate`). Discover exact event names
  with the unfiltered capture loop, and add a timeout via `os.startTimer`:
  ```lua
  local ev = {os.pullEvent()}  -- no filter: see what actually fires
  print(textutils.serialise(ev))
  ```
- **Async results arrive as later events.** `MethodResult` calls
  (`geo_scanner.scan`, `scanEntities`, `canTrainReach`, `distanceTo`,
  `nbt_storage.read`) return immediately; await the follow-up event, don't use
  the return value as the answer.
- **Print tables with `textutils.serialise`.** `print(pos)` shows a table
  address; `print(textutils.serialise(pos))` shows fields. Use `serialise()`
  for debug output, `serialiseJSON()` for wire formats like
  `sendFormattedMessage` (empty list → `textutils.empty_json_array`).
- **APIs vs peripherals.** Sable `aero`/`sublevel` (and `colors`/`textutils`/
  `term`/`os`/`redstone`) are global APIs: no wiring, no `peripheral.find`,
  no `require`. Guard with `assert(aero, "not on a Sable vessel")`.
- **Probe unknown shapes in-game.** Wherever docs say `IArguments (concrete
  shape TBD)`, list real methods and trial-call safely:
  ```lua
  for _, m in ipairs(peripheral.getMethods(peripheral.getName(p))) do print(m) end
  local ok, err = pcall(function() return p.someMethod({}) end)
  print(ok, err)
  ```
- **Sides are peripheral-relative** for `getItemsChest("left")`,
  `addItemToPlayer`, `pushFluid`/`pullFluid` (face of that block, not of the
  computer). Wrong side gives silent empty/nil, not an error.
- **Three redstone paths.** Computer faces use the global `redstone.setOutput("left",
  true)` API (no peripheral to find). More than 6 faces use `redrouter`
  (CC:C Bridge) or `tm_rsPort` (Tom's).

Use exact type strings (`chat_box` family is snake_case on 1.21.1, not legacy `chatBox`).
Details live in `references/`:

- 18 Create built-ins → [create.md](references/create.md) (logistics core: StockTicker/Requester/Frogport)
- Physical setup (wiring, wireless, monitors, turtles, chunks) → [setup.md](references/setup.md)
- 5 CC:C Bridge types → [cccbridge.md](references/cccbridge.md)
- Advanced Peripherals → [advanced-peripherals.md](references/advanced-peripherals.md)
- Tom's (GPU etc.) → [toms.md](references/toms.md)
- Tweaked Controllers / Deep Seas / Sable → [misc-addons.md](references/misc-addons.md)
- Standard logistics recipe (materials → orders → shortfall report) → [logistics.md](references/logistics.md)
- LuaLS type definitions (`types/`) → [types.md](references/types.md)

## 2. Pack-level constraints (measured from configs)

- CC `http` API is enabled, but `$private` (localhost, 192.168.x, etc.) requests
  are denied while `"*"` is allowed (measured in `computercraft-server.toml`:
  `[[http.rules]]` deny `$private`, allow `*`). Computers cannot reach
  private-network services. External HTTPS is allowed by default; if a server's
  bot detection blocks a request, sending a browser-like User-Agent may help
  (unconfirmed — depends on the server). Any computer can exfiltrate world
  data (player positions, colony intel, stock) or fetch remote code (16 MiB
  down / 4 MiB up per request). On public servers, replace allow-`*` with an
  allowlist and consider `websocket_enabled=false`.
- Turtles need fuel (`need_fuel=true` in `computercraft-server.toml`).
  Advanced Peripherals pockets consume no fuel
  (`disablePocketFuelConsumption=true` in AP `peripherals.toml`).
- ChatBox `run_command` EXECUTES server commands here
  (`chatBoxPreventRunCommand=false`). Banned: `/execute /op /deop /gamemode /
  gamerule /stop /give /fill /setblock /summon /whitelist /ban-ip /pardon-ip /
  save-on / save-off` only — `/tp /kill /kick /clear /ban /time /weather /function`
  and friends STILL RUN (at zero permission via WrapCommand). Message cooldown
  100 ticks (~5s), max 1024 chars, unlimited range, multidimensional. On public
  servers set `chatBoxPreventRunCommand=true`.
- Command computers need creative + OP; the command-block peripheral is disabled
  in this pack (`command_block_enabled=false`).
- RedstoneRequester `setRequest` takes **max 9 item types per call, count <= 256 each**
  (jar-measured). Slice larger orders into repeated `setRequest` + `request()` calls.
- Frogport addresses: right-click the block to type one, or call
  `setAddress("Generated")`.

## 3. Logistics recipe

The standard procedure for gathering Schematicannon materials through the Create
package logistics network is in [logistics.md](references/logistics.md).
Stock check → order firing → arrival check → shortfall report to a human:
the same Lua runs from any agent environment.
