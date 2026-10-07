# akkiserver-2026-july-CC-T-Skills

Minecraft 1.21.1 / NeoForge Modpack 「7m-dshtest」用の
[ComputerCraft: Tweaked](https://tweaked.cc/) (CC:T) スキル集。
同梱 jar の javap 実測 + 公式ドキュメントで裏付けたペリフェラル型名・Lua メソッド表が中心。
推測による記述はありません。

> 検証歓迎: さまざまなモデルやエージェントでお試しいただき、間違い・不足・動かない例を見つけたら
> Issue / PR で教えてください。寄稿も歓迎します (→ [CONTRIBUTING.md](CONTRIBUTING.md))。

## スキル一覧

| スキル | 内容 |
|---|---|
| [cc-7m](skills/cc-7m/SKILL.md) | ルータ。Mod構成・基本パターン・パック固有制約・DSH運用への入口 |

`cc-7m` の references:

| ファイル | 内容 |
|---|---|
| [create.md](skills/cc-7m/references/create.md) | Create 6.0.10 内蔵18種 (StockTicker/Requester/Frogport…)。物流の要 |
| [cccbridge.md](skills/cc-7m/references/cccbridge.md) | CC:C Bridge 1.7.3 の5種 (scroller/source/target/animatronic/redrouter) |
| [advanced-peripherals.md](skills/cc-7m/references/advanced-peripherals.md) | Advanced Peripherals 0.7.62b (chat_box/player_detector/…/colony_integrator) |
| [toms.md](skills/cc-7m/references/toms.md) | Tom's Peripherals 1.3.1 (GPU/キーボード/RS多面/WDT) |
| [misc-addons.md](skills/cc-7m/references/misc-addons.md) | Tweaked Controllers / Deep Seas / Sable / DebugBridge |
| [m7bus-loop.md](skills/cc-7m/references/m7bus-loop.md) | DSH側運用 (m7bus中継・ccbus MCP・M7.*・NBT材料解析) |

## 使い方

### Claude Code / Codex / OpenCode 等 (エージェント)

`skills/` をスキルディレクトリとして読み込ませてください。まず `cc-7m/SKILL.md` を
読み込ませ、必要に応じて references を参照させてください。

### DSH (DeepSeek Harness)

`~/.dsh/skills/` に `cc-7m` ディレクトリを置く (SKILL.md + references)。
ホットリロードでカタログに出る。再起動不要。

### ゲーム内 (Minecraft)

スキルは知識ベースであり、ゲーム内 Mod ではない。使うときはゲーム内コンピュータで
`peripheral.find("<型名>")` を呼ぶ。DSH 運用 (m7bus 経由の遠隔Lua実行) の手順は
[m7bus-loop.md](skills/cc-7m/references/m7bus-loop.md)。

## 検証状態

- [x] javap 実測: Create 18種・CCC Bridge 5種・AP 13種+・Tom's 4種・
  Tweaked Controllers・Deep Seas 3種・Sable 2 API の型文字列とメソッド名
- [x] config 実測: computercraft-server.toml (http allow/deny・燃料)・
  AP peripherals.toml (chatbox/ME/RS/各検出器の有効無効)・cccbridge client.toml
- [x] 公式doc突合: CC:C Bridge wiki・AP 0.7 docs (chat_box/player_detector/redstone_integrator)
- [ ] **多モデル検証: 実施中**。検証に使ったモデル・結果の共有は Issue で歓迎

既知の落とし穴 (詳細は各 reference):

- AP の 1.21.1 型名は snake_case (`chat_box`。旧 `chatBox` ではない)
- AP の redstone integrator は 0.7.50b で削除済み。CC:T 本体の redstone relay を使う
- CCC Bridge 1.7.3 に `train_station` は無い。列車は Create 内蔵 `Create_Station` を使う
- Requester の `setRequest` は1回9種まで・count<=256
- Frogport の `setConfiguration("send_recieve")` はこの綴り (receive ではない)
- Deep Seas の Hull Controller の型名は `oxygenator` (hull ではない)

## ライセンス

[MIT](LICENSE)。寄稿歓迎 — [CONTRIBUTING.md](CONTRIBUTING.md)。
