# m7bus ループ — DSH 側運用 (m7-dshtest 実測)

ゲーム内コンピュータ側では判断を行いません。DSH (このPCのエージェント) が材料解析・
注文設計を行い、m7bus (Cloudflare Worker の KV メールボックス中継) 経由で
Lua を送信します。ゲーム内 `startup.lua` v3 は受け取って実行し結果を返すだけです。

```
[会話] → DSHエージェント(このPC)
              |  ccbus.py (MCP / CLI)
              |  ・材料は .nbt をこのPCで解析 (NBTパーサ内蔵)
              |  ・注文設計もPC側で実施
              ▼ https (m7bus Worker・トークン認証)
[ゲーム内CC:T コンピュータ] startup.lua v3 (常駐バスループ)
  GET /get/cmd → Lua実行 → POST /put/resp
  ・Create_Frogport / Create_StockTicker / Create_RedstoneRequester
  ・M7.stock() / M7.order() / M7.show()  ← プレイヤーと等しい操作
```

## 前提ブロック (ゲーム内設置)

コンピュータ (advanced) をケーブルで StockTicker / RedstoneRequester /
Frogport (`Generated` + 隣クレート) / モニタに接続。倉庫クレートにネットワークリンク。
物流リンク = StockTicker/Requester/梱包機/ネットワークリンク付き収納が同じ物流網にいること。

## ゲーム内インストール (1コマンド)

```
wget https://gist.githubusercontent.com/motchii709/e27e542a67bd298f2a2dae4db98ac8f5/raw/startup.lua startup.lua
reboot
m7set token <m7busトークン(m7bus_...)>
reboot
```

`peek` コマンドでペリフェラルの接続を確認し、`M7.status()` が取得できればセットアップ完了です。

```lua
-- ゲーム内コンピュータで実行
peek
-- → peripherals 一覧 + stock + frogports の住所・中身を表示
```

## ccbus MCP (DSH側)

| ツール | 用途 |
|---|---|
| `mcp__ccbus__cc_eval` (`lua`, `timeout?=60`) | ゲーム内でLua実行。戻り値 `{ok, result, print[], error?}` |
| `mcp__ccbus__schematic_materials` (`name_or_path?`, `top?=50`) | .nbt 材料リスト (個体のみ。液体はスキップ) |
| `mcp__ccbus__schematics_list` | .nbt 一覧 (新着順) |
| `mcp__ccbus__bus_ping` | 中継疎通確認 |

CLI 同等物: `python bus/ccbus.py ping|schematics|materials [名]|eval "lua"`。

## M7.* グローバル (ゲーム内定義済み)

- `M7.stock()` — 物流網在庫一覧 `{{name,count},...}`
- `M7.generated()` — Frogport一覧 `{{name,addr,items={...}},...}`
- `M7.status()` — 上2つのまとめ
- `M7.order(items, opts)` — 注文発射。`items={{name=,count=}}`、`opts={to="Generated",crafting=false}`。
  内部で9種ずつ `setRequest`+`request()` を回す。戻り値 `{fired, failed, batches, dest, crafting}`
- `M7.show(lines)` — モニタ表示 `{"行1","行2",...}` (日本語折返しあり)
- `M7.peripherals()` / `M7.help()` — 接続一覧 / 関数一覧

## 定番ループ (材料→注文→不足伝達)

1. `schematic_materials` で材料リスト取得 (PC側)。
2. `cc_eval "return M7.status()"` で在庫 + Generated 到着済みを取得。
3. 差分 = 材料 - 在庫 - 到着済み をPC側で計算。
4. 差分のうち在庫にある物 → `cc_eval "return M7.order({...}, {to='Generated'})"`。
   クラフトで賄える物 → `crafting=true` で同様に。
5. ネット上に一切無い原材料だけ `M7.show({"...を倉庫へ投入", ...})` で人間に伝達。
6. `gap=0` になったら `M7.show({"概略図砲を発射できます", ...})`。

## 既知の制限 (実測)

- 概略図砲自体に peripheral は無い。材料は .nbt 解析で代用。
- `stock()` は配送中を含まない。二重注文防止の差分管理は DSH 側で行う。
- `http.get` の長ポーリング中はブロックする。v3 は自動注文ループ無し・バス専用のため問題なし。
- KV無料枠: 読取10万回/日・書込1千回/日。同じ Cloudflare データセンター (Colo) 内なら
  書き込み反映は実測約0.6秒ですが、異なる Colo 間では最大約60秒遅延する場合があります。
- トークン失効: Cloudflare ダッシュボード → Workers → m7bus → Settings → Variables の
  `TOKEN` を差し替え+再デプロイ → ゲーム内 `m7set token` 更新。

## セキュリティ

ゲーム内・ワールド・gist に APIキーは一切置かない。置くのは失効/再発行可能な
m7bus バストークン (`m7bus_...`) のみ。PC側トークンの保管先は `bus/.bus-token.local.txt`
(gist には出さない)。通信はすべて HTTPS。無Token → 401。
