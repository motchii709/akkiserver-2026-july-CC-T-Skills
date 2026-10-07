# Create 内蔵ペリフェラル (Create 6.0.10 / jar実測)

Create 本体が CC: Tweaked 連携を内蔵している。型文字列・メソッド名は
`create-1.21.1-6.0.10.jar` の `.../implementation/peripherals/*.class` を
javap で読んだ実測値。Lua の型名は `peripheral.getType()` の返り値と一致する。

## 物流系 (m7bus ループの主戦場)

### `Create_StockTicker` — 在庫台帳

```lua
local t = peripheral.find("Create_StockTicker")
local summary = t.stock()          -- { [1]={name=,count=,...}, ... } 正確な集計
local full = t.stock(true)         -- 詳細付き (引数は Optional<Boolean>)
local d = t.getStockItemDetail(1)  -- stock() の何番目かを指定
t.requestFiltered("minecraft:oak_log", {name="minecraft:oak_log", count=64})
```

- `stock()` は実在庫の正確な集計を返します (配送中の分は含みません)。
- `requestFiltered(name, filterTable...)` は戻り値 int (要求数)。

### `Create_RedstoneRequester` — 注文発射台

```lua
local r = peripheral.find("Create_RedstoneRequester")
r.setAddress("Generated")
r.setRequest({name="minecraft:oak_log", count=64}, {name="minecraft:iron_ingot", count=32})
r.request()
r.setCraftingRequest({name="minecraft:oak_planks", count=16})  -- クラフト注文
local cur = r.getRequest()
print(r.getAddress(), r.getConfiguration())
r.setConfiguration("...")  -- 設定文字列の切替
```

- **`setRequest` は1回9種まで・各 count<=256** (jar実測 + 運用実績)。
  9種を超える注文はスライスして `setRequest` + `request()` を繰り返す。
- `getRequest()` で発射前の要求内容を確認できる。

### `Create_Frogport` / `Create_Postbox` — 荷物の住所付きポート

```lua
local f = peripheral.find("Create_Frogport")
f.setAddress("Generated")
print(f.getAddress())
f.setConfiguration("send_recieve")  -- 送受信モード (実測の綴り。receive ではない)
local items = f.list()               -- ポート内 = { [slot]={name=,count=}, ... }
local d = f.getItemDetail(1)
```

- イベント `package_received` / `package_sent` を投げる (m7-dshtest の startup.lua v3 で受信確認済み。
  なお jar 内のイベントクラス名は `PackageEvent` / `RepackageEvent` / ... のため、
  他環境では `os.pullEvent()` を回して厳密な文字列を確認すること)。
- Postbox も同形 (`setAddress/getAddress/getConfiguration/setConfiguration/list/getItemDetail`)。

### `Create_Packager` / `Create_Repackager` — 梱包機

```lua
local pk = peripheral.find("Create_Packager")
pk.setAddress("Generated")   -- Optional<String> なので省略可
local ok = pk.makePackage()  -- 中身を荷物化。戻り値 boolean
local box = pk.getPackage()  -- PackageLuaObject
print(box.getAddress())
box.setAddress("Generated")
local items = box.list()
if box.hasOrderData() then
  local o = box.getOrderData()
  print(o.getOrderID(), o.getIndex(), o.isFinal(), o.getLinkIndex(), o.isFinalLink())
  local list = o.list()          -- 注文明細
  local crafts = o.getCrafts()   -- クラフト明細
end
```

## 列車系

### `Create_Station`

```lua
local s = peripheral.find("Create_Station")
s.assemble()
-- s.disassemble()  -- 解体するときはこちら
s.setAssemblyMode(true); print(s.isInAssemblyMode())
s.setStationName("depot"); print(s.getStationName())
s.setTrainName("freight-1"); print(s.getTrainName())
print(s.isTrainPresent(), s.isTrainImminent(), s.isTrainEnroute())
print(s.hasSchedule())
local sch = s.getSchedule()
s.setSchedule(sch)  -- 取得→設定の往復。書換え時はテーブルを編集して渡す
-- 非同期 (MethodResult): 結果はイベントで返る
s.canTrainReach("north-depot")
s.distanceTo("north-depot")
```

### `Create_TrainObserver`

```lua
local o = peripheral.find("Create_TrainObserver")
print(o.isTrainPassing())
print(o.getPassingTrainName())
```

### `Create_Signal`

```lua
local sg = peripheral.find("Create_Signal")
print(sg.getState(), sg.getSignalType())
print(sg.isForcedRed()); sg.setForcedRed(true)
sg.cycleSignalType()
local trains = sg.listBlockingTrainNames()
```

## 回転・動力系

### `Create_RotationSpeedController`

```lua
local c = peripheral.find("Create_RotationSpeedController")
c.setTargetSpeed(64); print(c.getTargetSpeed())
```

### `Create_CreativeMotor`

```lua
local m = peripheral.find("Create_CreativeMotor")
m.setGeneratedSpeed(256); print(m.getGeneratedSpeed())
```

### `Create_SequencedGearshift`

```lua
local g = peripheral.find("Create_SequencedGearshift")
g.rotate({direction="clockwise", angle=90})  -- IArguments (回転指示テーブル。具体形はゲーム内で確認)
g.move({distance=1})  -- IArguments (移動指示テーブル。具体形はゲーム内で確認)
print(g.isRunning())
```

### `Create_Sticker` — 粘着ピストン系

```lua
local st = peripheral.find("Create_Sticker")
print(st.isExtended(), st.isAttachedToBlock())
st.extend()
-- st.retract()  -- 引っ込めるときはこちら
-- st.toggle()   -- 切替はこちら
```

## 表示・計測・販売系

### `Create_NixieTube`

```lua
local n = peripheral.find("Create_NixieTube")
n.setText("0123")            -- IArguments (文字列+色等の可変引数)
n.setTextColour("red")      -- setTextColor も同義で存在
n.setSignal("redstone", true)  -- IArguments (信号名+状態。具体形はゲーム内で確認)
```

### `Create_DisplayLink` — 表示パネル直書き (term互換サブセット)

```lua
local d = peripheral.find("Create_DisplayLink")
d.setCursorPos(1, 1)
print(table.unpack(d.getCursorPos()))
print(table.unpack(d.getSize()))
print(d.isColor())  -- isColour も同義
d.write("hello")
d.writeBytes(72, 101, 108, 108, 111)  -- IArguments ("Hello" のバイト列例)
d.clearLine(); d.clear(); d.update()
```

### `Create_Stressometer` / `Create_Speedometer`

```lua
print(peripheral.find("Create_Stressometer").getStress())
print(peripheral.find("Create_Stressometer").getStressCapacity())
print(peripheral.find("Create_Speedometer").getSpeed())
```

### `Create_TableClothShop` — お店テーブル

```lua
local sh = peripheral.find("Create_TableClothShop")
print(sh.isShop())
sh.setAddress("shop-1"); print(sh.getAddress())
print(sh.getPriceTagCount()); sh.setPriceTagCount(5)
local wares = sh.getWares()
sh.setWares(sh.getWares())  -- 取得→設定の往復。書換え時はテーブルを編集して渡す
local price = sh.getPriceTagItem()
sh.setPriceTagItem("minecraft:diamond")  -- Optional<String>
```

## イベント

Create 側は `prepareComputerEvent` でコンピュータイベントを投げる。
jar 内イベントクラス実測: `PackageEvent` / `RepackageEvent` /
`StationTrainPresenceEvent` / `TrainPassEvent` / `SignalStateChangeEvent` /
`KineticsChangeEvent`。受ける側は `os.pullEvent()` で待つのが定石。
イベント名の厳密な文字列はゲーム内で `os.pullEvent()` を回して確認すること。
