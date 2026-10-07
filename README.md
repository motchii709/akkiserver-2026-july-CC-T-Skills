# cc-tweaked-addons

Agent skills for [ComputerCraft: Tweaked](https://tweaked.cc/) (CC:T) and its
addon mods on Minecraft 1.21.1 / NeoForge: peripheral type names and Lua methods
backed by javap inspection of the mod jars plus official docs. No guesswork.

> Verification welcome: try it with different models and agents, and report
> mistakes, gaps, or non-working examples via Issue / PR. Contributions welcome
> (→ [CONTRIBUTING.md](CONTRIBUTING.md)). 日本語版は [README.ja.md](README.ja.md)。

## Skills

| Skill | Contents |
|---|---|
| [cc-tweaked-addons](skills/cc-tweaked-addons/SKILL.md) | Router: mod set, basic patterns, environment constraints, logistics recipe entry |

References under `cc-tweaked-addons`:

| File | Contents |
|---|---|
| [create.md](skills/cc-tweaked-addons/references/create.md) | 18 Create 6.0.10 built-ins (StockTicker/Requester/Frogport…). The logistics core |
| [cccbridge.md](skills/cc-tweaked-addons/references/cccbridge.md) | 5 CC:C Bridge 1.7.3 types (scroller/source/target/animatronic/redrouter) |
| [advanced-peripherals.md](skills/cc-tweaked-addons/references/advanced-peripherals.md) | Advanced Peripherals 0.7.62b (chat_box/player_detector/…/colony_integrator) |
| [toms.md](skills/cc-tweaked-addons/references/toms.md) | Tom's Peripherals 1.3.1 (GPU/keyboard/multi-sided redstone/watchdog) |
| [misc-addons.md](skills/cc-tweaked-addons/references/misc-addons.md) | Tweaked Controllers / Deep Seas / Sable / DebugBridge |
| [logistics.md](skills/cc-tweaked-addons/references/logistics.md) | Logistics recipe (Schematicannon materials: stock → orders → arrival → shortfall) |
| [types.md](skills/cc-tweaked-addons/references/types.md) | LuaLS type definitions (`types/class_set.d.lua`, vendored MIT) |

## Usage

Point your agent's skill directory at `skills/`. Load `cc-tweaked-addons/SKILL.md`
first, then follow references as needed.

### In-game (Minecraft)

Skills are a knowledge base, not an in-game mod. Call
`peripheral.find("<type>")` from an in-game computer. The standard
Schematicannon-material procedure is in
[logistics.md](skills/cc-tweaked-addons/references/logistics.md).

### Adapting to your own pack

The jar-measured versions are CC: Tweaked 1.120.0, Create 6.0.10,
CC:C Bridge 1.7.3, Advanced Peripherals 0.7.62b, Tom's Peripherals 1.3.1,
Tweaked Controllers 1.21.1-1.2.7, Deep Seas 1.1.1, Sable 1.3.4.
If your versions differ, re-check type strings with
`peripheral.getNames()` / `peripheral.getType()` in-game and file an issue or PR.

## Verification status

- [x] javap measurement: type strings and method names for Create 18, CCC Bridge 5,
  AP 13+, Tom's 4, Tweaked Controllers, Deep Seas 3, Sable 2 APIs
- [x] config measurement: computercraft-server.toml (http allow/deny, fuel),
  AP peripherals.toml (chatbox/ME/RS/detector enablement), cccbridge client.toml
- [x] Official-doc cross-check: CC:C Bridge wiki, AP 0.7 docs
  (chat_box/player_detector/redstone_integrator)
- [x] Multi-model review rounds (facts / Lua / readability / consistency)
- [ ] **In-game verification on more packs — wanted.** Share model + results in issues

Known pitfalls (details in each reference):

- AP 1.21.1 type names are snake_case (`chat_box`, not legacy `chatBox`)
- AP redstone integrator was removed in 0.7.50b; use CC:T's own redstone relay
- CCC Bridge 1.7.3 has no `train_station`; use Create's built-in `Create_Station`
- Requester `setRequest`: max 9 types per call, count<=256 each
- Frogport `setConfiguration("send_recieve")` is that exact spelling (not "receive")
- Deep Seas Hull Controller type is `oxygenator` (not "hull")

## License

[MIT](LICENSE). Contributions welcome — [CONTRIBUTING.md](CONTRIBUTING.md).
Third-party attributions: [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
