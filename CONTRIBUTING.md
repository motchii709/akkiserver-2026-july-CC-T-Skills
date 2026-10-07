# Contributing

Issues and PRs are welcome — first-timers too.

## Welcome contributions

- **Corrections**: a type name, method name, or arity that does not work or
  differs from the official docs
- **Multi-model verification reports**: model name, scenario, result
  (working / non-working examples appreciated)
- **Gap filling**: undocumented peripherals, event names, Lua examples
- **Language improvements**: unclear wording, typos (English or Japanese)

## How

1. Open an issue first, or send a PR directly (either is fine; when in doubt,
   start with an issue).
2. For PRs: edit under `skills/cc-tweaked-addons/` and state in the PR body how
   you verified it (javap / config / official-doc URL / in-game test).
3. No guesswork. Mark unverified statements `unconfirmed`.

## Writing rules

- Type strings and method names: the bundled jars' javap output wins. When the
  official docs disagree, document both and say which to prefer.
- Write in English (skill body and references). Japanese questions, issues, and
  PRs are welcome; see [CONTRIBUTING.ja.md](CONTRIBUTING.ja.md).
- State versions. For new mods / new-version PRs, attach the in-jar version
  (`version` in `META-INF/neoforge.mods.toml`).
- Never put credentials or secret tokens in code meant to live in-game
  (keep API keys and personal tokens on the PC / agent side, never in-game Lua,
  NBT storage, disks, monitors, or chat). In-game files ship with the world
  save and rednet/modem traffic is sniffable — the game is not a vault.
  Also never commit secrets to git or POST them via http/chat; rotate if leaked.
- The vendored `types/class_set.d.lua` is third-party licensed code — note changes
  to it in your PR; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the
  source and upstreaming.

## License

Contributions are handled under MIT ([LICENSE](LICENSE)).
