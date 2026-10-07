---
name: cc-7m
description: 7m-dshtest modpack (MC 1.21.1/NeoForge) の ComputerCraft: Tweaked とアドオン群の操作ガイド。ペリフェラル (周辺機器。以下ペリフェラル) 型名と Lua メソッド、Create内蔵ペリフェラル・CC:C Bridge・Advanced Peripherals・Tom's Peripherals・Tweaked Controllers・Deep Seas・Sable の使い方、DSH側の m7bus/ccbus 運用ループをまとめる。ゲーム内Luaを書く・ペリフェラルを操作する・物流注文を組むときに読む。
---

# cc-7m — 7m-dshtest の ComputerCraft

対象: `7m-dshtest` インスタンス (MC 1.21.1 / NeoForge)。
CC: Tweaked 1.120.0 + 下表のアドオン。**API一覧はすべて同梱 jar の javap 実測値と公式ドキュメントで裏付け済みです** (推測による記述はありません)。

## 0. Mod構成 (jar実測バージョン)

| Mod | jar内バージョン | 役割 |
|---|---|---|
| CC: Tweaked | 1.120.0 (`computercraft`) | 本体。コンピュータ/タートル/モニタ/モデム |
| Create | 6.0.10 | CC互換ペリフェラル18種を**内蔵** |
| CC:C Bridge | 1.7.3 (`cccbridge`) | Create表示・レッドストーン・拡散系5種 |
| Advanced Peripherals | 0.7.62b | 汎用ペリフェラル群 (下記) |
| Tom's Peripherals | 1.3.1 (`toms_peripherals`) | GPU描画・キーボード・高精度モニタ等 |
| Create: Tweaked Controllers | 1.21.1-1.2.7 | 操縦桿コントローラ連携 |
| CC: Deep Seas | 1.1.1 (`cc_deepseas`) | Create Submarine 連携 (潜水艦Modは同梱あり) |
| CC: Sable | 1.3.4 (`cc_sable`) | Sable(VS系物理)連携。**Lua API形式** (同梱あり) |
| DebugBridge | 2.0.0 | CCではない。クライアント側WebSocket REPL。CC作業では無視してよい |

注意: Advanced Peripherals の `me_bridge` / `rs_bridge` はクラスとして存在するが、
このパックには AE2・Refined Storage・Mekanism が含まれていないため接続先がありません。
`colony_integrator` は MineColonies 同梱ありのため有効。

## 1. 基本パターン

```lua
-- 一覧 → 型で探す → ラップ
for _, n in ipairs(peripheral.getNames()) do print(n, peripheral.getType(n)) end
local ticker = peripheral.find("Create_StockTicker")  -- 型名指定find
local p = peripheral.wrap("right")                    -- 設置面指定も可
```

型文字列は正式名を使う (`chat_box` 系は1.21.1で snake_case。旧 `chatBox` ではない)。
詳細は `references/` の各ファイル:

- Create内蔵18種 → [create.md](references/create.md) (物流の要。StockTicker/Requester/Frogport含む)
- CC:C Bridge 5種 → [cccbridge.md](references/cccbridge.md)
- Advanced Peripherals → [advanced-peripherals.md](references/advanced-peripherals.md)
- Tom's (GPU等) → [toms.md](references/toms.md)
- Tweaked Controllers / Deep Seas / Sable → [misc-addons.md](references/misc-addons.md)
- DSH側運用 (m7bus・ccbus・M7.*・NBT材料解析) → [m7bus-loop.md](references/m7bus-loop.md)

## 2. このパック固有の制約 (config実測)

- CC の `http` API は有効です。ただし `$private` (localhost や 192.168.x 等の
  プライベートアドレス宛) は拒否、`"*"` は許可されます。ゲーム内から内向き接続は
  できません。m7bus 等の外部HTTPSは利用可能です (Cloudflare の Bot 判定回避のため
  ブラウザ相当の User-Agent が必要ですが、`startup.lua` に設定済みです)。
- タートルは燃料必要 (`need_fuel=true`)。Advanced Pocket は燃料消費なし。
- ChatBox: 発言クールダウン100tick (約5秒)・最大1024文字・範囲無制限・多次元可。
  `/execute /op /give /summon` 等は `run_command` 禁止 (config)。
- RedstoneRequester の `setRequest` は **1回9種まで・count<=256** (jar実測)。
  大量注文は9種ずつ `setRequest` + `request()` を繰り返す。
- Frogport の住所は、ブロックを右クリックして手入力するか、
  `setAddress("Generated")` で設定します。

## 3. DSH から触るとき

ゲーム内コンピュータ (`cc/startup.lua` v3 常駐) には DSH 側の ccbus MCP で Lua を送る:

- `mcp__ccbus__cc_eval` — 任意Lua実行 (`M7.stock()` / `M7.generated()` / `M7.status()` /
  `M7.order(items, opts)` / `M7.show(lines)` が定義済み)
- `mcp__ccbus__schematic_materials` / `schematics_list` — .nbt 材料解析はPC側で行う
- `mcp__ccbus__bus_ping` — 中継疎通確認

手順・トークン管理・KV制限などの運用事項は [m7bus-loop.md](references/m7bus-loop.md)。
ゲーム内・ワールド・gist に APIキー類は一切置かない (置くのは失効可能な m7bus バストークンのみ)。
