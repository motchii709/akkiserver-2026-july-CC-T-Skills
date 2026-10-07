# LuaLS type definitions (`types/`)

Machine-readable signatures for editors and agents, vendored from the shared
community file with permission-compatible licensing (MIT on both sides).

## Files

| File | Source |
|---|---|
| [class_set.d.lua](../types/class_set.d.lua) | [manmen2414/AKKI-Server-MameeennArea `types/class_set.d.lua`](https://github.com/manmen2414/AKKI-Server-MameeennArea/blob/main/types/class_set.d.lua) (MIT), same-modpack environment |

## Covered classes

Modem, PlayerDetector, ChatBox, ReadStream/WriteStream, Inventory (generic
`pushItems`/`pullItems`), TrainStation (`Create_Station`), Frogport
(`Create_Frogport`, incl. `"send_recieve"\|"send"` config union), StockTicker
(`Create_StockTicker`), InventoryManager, ItemInterface, DisplayLink
(`Create_DisplayLink`), ColonyIntegrator + ColonyCitizen/Visitor/Building/
Research/Request/WorkOrder shapes, NixieTube + NixieTubeSignal, TrainSignal
(`Create_Signal`).

## Usage

Point your Lua language server at `types/` (e.g. `workspace.library` in
`lua-language-server`, or `@meta` require in-repo). The `.md` references in this
skill remain the human-readable source of truth for behavior, limits, and events;
use the `.d.lua` for arity and field names while writing code.

## Caveats (where the .d.lua disagrees with jar measurement)

- `stockTicker.requestFiltered(address, ...)` — matches jar (`requestFiltered(String, IArguments)`).
- `frogport.setConfiguration` union `"send_recieve"|"send"` matches jar-measured values.
- `nbt_storage` / `energy_detector` / `block_reader` / `geo_scanner` /
  `environment_detector` / turtle upgrades are **not** in the .d.lua; see
  [advanced-peripherals.md](advanced-peripherals.md) for those.
- `colonyIntegrator.getBuilderResources()` takes no listed param in the .d.lua;
  the jar signature takes a position table — call
  `getBuilderResources({x=0, y=64, z=0})`.
- `displayLink.writeBytes(content: string|number[])` in the .d.lua takes a single
  packed argument, while [create.md](create.md) shows a varargs-style call.
  Confirm the working shape in-game (`peripheral.getMethods` + a trial call)
  and align both; the jar wins on disagreement.
- When jar measurement and the .d.lua disagree, the jar wins; please file an
  issue so both can be fixed (upstream fix goes to
  [AKKI-Server-MameeennArea](https://github.com/manmen2414/AKKI-Server-MameeennArea)).

## Attribution

`types/class_set.d.lua` is © manmen2414 (MIT), vendored here under the same
license. See [THIRD_PARTY_NOTICES.md](../../../THIRD_PARTY_NOTICES.md).
