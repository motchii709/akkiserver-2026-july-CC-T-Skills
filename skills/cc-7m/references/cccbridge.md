# CC:C Bridge (cccbridge 1.7.3 / jar実測 + 公式wiki)

Create の表示・レッドストーン・拡散系を CC から触る5種。
型文字列・メソッド名は jar の javap 実測。使い方は
[公式 Peripherals](https://cccbridge.kleinbox.dev/peripherals/) と
[wiki](https://github.com/tweaked-programs/cccbridge/wiki) で裏付け済み。

## `scroller` — 数値選択ペイン

```lua
local sc = peripheral.find("scroller")
sc.setLock(true)              -- 編集中ロック (公式: isLocked/setLock → setLocked表記もあり)
print(sc.isLocked())
print(sc.getValue())          -- 現在値 (-limit..limit)
sc.setValue(32)
print(sc.getLimit())
sc.setLimit(64)               -- 上限。マイナス領域 (minus spectrum) 有効なら -limit〜limit、無効なら 0〜limit
-- (マイナス領域の切替は下の toggleMinusSpectrum)
print(sc.hasMinusSpectrum())
sc.toggleMinusSpectrum(true)
sc.setLock(false)
os.pullEvent("scroller_changed")  -- プレイヤーが変えるまで待つ
```

## `create_source` — 表示送信ブロック (term互換)

Create の各種ディスプレイへ文字を送る。Window API 互換の振る舞い。

```lua
local src = peripheral.find("create_source")
local w, h = src.getSize()
src.clear()
src.setCursorPos(math.floor(w/2 - #"Hello World"/2), math.floor(h/2))
src.write("Hello World")
print(src.getLine(math.floor(h/2)))  -- 書いた行の読み返し (テキストのみ)
src.setSize(51, 19)
print(table.unpack(src.getContent()))
-- scroll(yDiff) / clearLine() / getCursorPos() も term と同様
```

## `create_target` — 表示受信の模擬ターゲット

Create の Display Source からのデータを受けて読む。

```lua
local t = peripheral.find("create_target")
t.resize(32, 8)
for _, line in ipairs(t.dump()) do print(line) end
print(t.getLine(1))          -- 例: 応力値の行だけ読む
print(table.unpack(t.getSize()))
```

## `animatronic` — アニマトロニクス人形

```lua
local a = peripheral.find("animatronic")
a.setFace("happy")           -- normal / happy / question / sad
a.setTransition("rusty")     -- linear / none / rusty (既定 rusty)
a.setHeadRot(0, 0, 0)        -- 各 -180..180 (body の X のみ 360可)
a.setBodyRot(0, 180, 0)
a.setLeftArmRot(0, 0, 0)
a.setRightArmRot(0, 0, 90)
a.push()                     -- 適用 (呼ぶまで反映されない。呼後は蓄積値リセット)
local x, y, z = a.getStoredHeadRot()
local x2, y2, z2 = a.getAppliedHeadRot()
-- getStoredBodyRot / getStoredLeftArmRot / getStoredRightArmRot
-- getAppliedBodyRot / getAppliedLeftArmRot / getAppliedRightArmRot も同様
```

## `redrouter` — 6面レッドストーンルータ

コンピュータの6面より多い面を扱いたいとき用。
側面名 (コンピュータから見た接続面名) は `front/back/left/right/top/bottom` (jar実測)。

```lua
local r = peripheral.find("redrouter")
r.setOutput("left", true)
print(r.getOutput("left"), r.getInput("front"))
r.setAnalogOutput("back", 10)   -- 0..15。範囲外は LuaException
print(r.getAnalogOutput("back"), r.getAnalogInput("back"))
os.pullEvent("redstone")
```

## 注意: `train_station` はこの jar に無い

旧wiki に `train_station` (assemble/disassemble/getBogeys 等) の記述があるが、
1.7.3 の jar 内 peripheral クラスは上記5種のみで station 系クラスは存在しない。
列車操作は Create 内蔵の `Create_Station` (→ [create.md](create.md)) を使うこと。
