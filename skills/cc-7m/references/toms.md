# Tom's Peripherals (1.3.1 / jar実測)

高精度モニタ・GPU描画・キーボード・レッドストーン多面・ウォッチドッグ。
型文字列は jar 内の定数から抽出した実測値です (javap で確認): `tm_gpu` / `tm_keyboard` / `tm_rsPort` (+`tm_redstone`) / `tm_wdt`。
GPU の描画メソッド群は `BaseGPU` クラスの javap 実測。

## GPU + モニタ (`tm_gpu`)

```lua
local g = peripheral.find("tm_gpu")
local w, h = g.getSize()
local x, y, color = 1, 1, colors.white  -- 描画位置と色の例
g.fill(x, y, w, h, color)
local x1, y1, x2, y2 = 1, 1, 10, 5
g.filledRectangle(x1, y1, x2, y2, color)
g.rectangle(x1, y1, x2, y2, color)
g.line(x1, y1, x2, y2, color)
g.drawText(x, y, "hello", colors.white, colors.black, 1, 0)
g.drawTextSmart(x, y, "hello", colors.white, colors.black, false, 1, 0)
g.drawChar(x, y, "A", colors.white, colors.black, 1)
g.drawBuffer(x, y, 8, 1, {0, 1, 0, 1})  -- (位置・幅・倍率・データ例)
g.drawImage(x, y, "example_ref")  -- 画像参照名は環境に合わせて変更
g.sync()  -- 描画反映
print(g.getBounds())
-- フォント:
print(table.unpack(g.getFont()))
g.setFont("ascii")
g.setFontDefaultCharID(0); print(g.getFontDefaultCharID())
print(g.getTextLength("hello", 1, 0))
g.addNewChar("X", 8, {})  -- カスタム文字 (16行分のドットデータを渡す)
g.delChar("X"); print(g.freeChars()); g.clearChars()
-- ウィンドウ:
local win = g.createWindow(x, y, w, h)
local win3d = g.createWindow3D(x, y, w, h)
```

VRAM 不足時は `Not enough VRAM for screen buffer` で失敗する。
複数モニタを使う場合は GPU ブロックに隣接設置し、`connectMonitors` 相当の接続を行ってください
(ゲーム内の設置操作で対応できます)。

## キーボード (`tm_keyboard`)

```lua
local k = peripheral.find("tm_keyboard")
k.setFireNativeEvents(true)  -- ネイティブキーイベント発火のON/OFF
```

押下イベントはコンピュータの `key` イベントとして届く。Dongle ブロック併用で無線化。

## レッドストーン (`tm_rsPort` / `tm_redstone`)

```lua
local r = peripheral.find("tm_rsPort")
print(table.unpack(r.getSides()))
print(r.getInput("left"), r.getAnalogInput("left"))
print(r.getOutput("right"), r.getAnalogOutput("right"))
r.setOutput("right", true)
r.setAnalogOutput("right", 10)
print(r.getBundledInput("back"), r.getBundledOutput("back"))
r.setBundledOutput("back", colors.combine(colors.red, colors.blue))
print(r.testBundledInput("back", colors.red))  -- (面, 色マスク)
-- getAnalogueInput / getAnalogueOutput / setAnalogueOutput は綴り違いの同義語
```

## ウォッチドッグタイマ (`tm_wdt`)

一定時間 `reset()` が呼ばれないとレッドストーン信号を出力する
ウォッチドッグタイマです。

```lua
local w = peripheral.find("tm_wdt")
w.setTimeout(200)   -- 20tick (約1秒) 超が必須。カウント中の変更は不可
w.setEnabled(true)
w.reset()           -- 定期呼び出しでタイムアウト回避
print(w.isEnabled(), w.getTimeout())
```
