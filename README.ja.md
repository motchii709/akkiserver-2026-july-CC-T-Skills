# cc-tweaked-addons（日本語版）

Minecraft 1.21.1 / NeoForge 上の [ComputerCraft: Tweaked](https://tweaked.cc/) (CC:T)
とアドオン群のためのエージェントスキル集。Mod の jar を javap で実測し、公式ドキュメントと
突き合わせたペリフェラル型名・Lua メソッド表が中心です。推測による記述はありません。
English version: [README.md](README.md).

> 検証歓迎: さまざまなモデルやエージェントでお試しいただき、間違い・不足・動かない例を見つけたら
> Issue / PR で教えてください。寄稿も歓迎します (→ [CONTRIBUTING.md](CONTRIBUTING.md) /
> 日本語版 [CONTRIBUTING.ja.md](CONTRIBUTING.ja.md))。

## スキル一覧

| スキル | 内容 |
|---|---|
| [cc-tweaked-addons](skills/cc-tweaked-addons/SKILL.md) | ルータ。Mod 構成・基本パターン・環境制約・物流レシピへの入口 |

`cc-tweaked-addons` の references（本文は英語。各ファイルの概要のみ訳出）:

| ファイル | 内容 |
|---|---|
| [create.md](skills/cc-tweaked-addons/references/create.md) | Create 6.0.10 内蔵18種 (StockTicker/Requester/Frogport…)。物流の要 |
| [cccbridge.md](skills/cc-tweaked-addons/references/cccbridge.md) | CC:C Bridge 1.7.3 の5種 (scroller/source/target/animatronic/redrouter) |
| [advanced-peripherals.md](skills/cc-tweaked-addons/references/advanced-peripherals.md) | Advanced Peripherals 0.7.62b (chat_box/player_detector/…/colony_integrator) |
| [toms.md](skills/cc-tweaked-addons/references/toms.md) | Tom's Peripherals 1.3.1 (GPU/キーボード/多面レッドストーン/ウォッチドッグ) |
| [misc-addons.md](skills/cc-tweaked-addons/references/misc-addons.md) | Tweaked Controllers / Deep Seas / Sable / DebugBridge |
| [logistics.md](skills/cc-tweaked-addons/references/logistics.md) | 物流レシピ (概略図砲の材料集め: 在庫→注文→到着確認→不足伝達) |
| [types.md](skills/cc-tweaked-addons/references/types.md) | LuaLS 型定義 (`types/class_set.d.lua`、MIT で同梱) |

スキル本体・references は英語です。日本語での質問・Issue・PR は歓迎します。

## 使い方

`skills/` をエージェントのスキルディレクトリとして読み込ませてください。まず
`cc-tweaked-addons/SKILL.md` を読み込ませ、必要に応じて references を参照させてください。

### ゲーム内 (Minecraft)

スキルは知識ベースであり、ゲーム内 Mod ではありません。使うときはゲーム内コンピュータで
`peripheral.find("<型名>")` を呼びます。概略図砲の材料集めの定番手順は
[logistics.md](skills/cc-tweaked-addons/references/logistics.md)（英語）。

### 自分のパックに合わせる

実測バージョンは CC: Tweaked 1.120.0、Create 6.0.10、CC:C Bridge 1.7.3、
Advanced Peripherals 0.7.62b、Tom's Peripherals 1.3.1、
Tweaked Controllers 1.21.1-1.2.7、Deep Seas 1.1.1、Sable 1.3.4 です。
バージョンが異なる場合はゲーム内で `peripheral.getNames()` / `peripheral.getType()` で
型文字列を確認し直し、Issue や PR で共有してください。

## 検証状態

- [x] javap 実測: Create 18種・CCC Bridge 5種・AP 13種以上・Tom's 4種・
  Tweaked Controllers・Deep Seas 3種・Sable 2 API の型文字列とメソッド名
- [x] config 実測: computercraft-server.toml（http 許可/拒否・燃料）・
  AP peripherals.toml（chatbox/ME/RS/各検出器の有効無効）・cccbridge client.toml
- [x] 公式ドキュメント突合: CC:C Bridge wiki・AP 0.7 docs
- [x] 複数モデルによるレビュー（事実 / Lua / 可読性 / 一貫性）
- [ ] **他パックでのゲーム内検証 — 募集中**。モデルと結果の共有は Issue で歓迎

既知の落とし穴（詳細は各 reference・英語）:

- AP の 1.21.1 型名は snake_case（`chat_box`。旧 `chatBox` ではない）
- AP の redstone integrator は 0.7.50b で削除済み。CC:T 本体の redstone relay を使う
- CCC Bridge 1.7.3 に `train_station` は無い。列車は Create 内蔵 `Create_Station` を使う
- Requester の `setRequest` は1回9種まで・count<=256
- Frogport の `setConfiguration("send_recieve")` はこの綴り（receive ではない）
- Deep Seas の Hull Controller の型名は `oxygenator`（hull ではない）

## ライセンス

[MIT](LICENSE)。寄稿歓迎 — [CONTRIBUTING.md](CONTRIBUTING.md) /
[CONTRIBUTING.ja.md](CONTRIBUTING.ja.md)。
第三者帰属表示: [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。
