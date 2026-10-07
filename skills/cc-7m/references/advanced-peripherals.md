# Advanced Peripherals (0.7.62b / jar実測 + 公式doc)

汎用ペリフェラル群。`PERIPHERAL_TYPE` 定数とメソッドシグネチャは jar の javap 実測。
1.21.1 では型名が **snake_case** (`chat_box`。旧 `chatBox` ではない)。
Lua の引数形・イベント名は [公式doc 0.7](https://docs.advanced-peripherals.de/0.7/) で裏付け済み。

## 有効・無効マトリクス (このパック)

| 型 | 状態 | 備考 |
|---|---|---|
| `chat_box` | 有効 | クールダウン100tick・最大1024文字・範囲無制限・多次元可 |
| `player_detector` | 有効 | 範囲無制限・多次元可・`getPlayerPos` 拡張情報ON |
| `environment_detector` | 有効 | |
| `geo_scanner` | 有効 | コスト系 (下記) |
| `inventory_manager` | 有効 | |
| `nbt_storage` | 有効 | 最大1MiB文字列 |
| `energy_detector` | 有効 | |
| `block_reader` | 有効 | |
| `colony_integrator` | 有効 | MineColonies 同梱あり |
| `compass` (タートル) | 有効 | `getFacing()` |
| `chunky` (タートル) | 有効 | 半径0=自チャンクのみ (config) |
| automata core系 (タートル) | 有効 | weak/end/husbandry + overpowered3種 |
| `me_bridge` / `rs_bridge` | **接続先なし** | クラスはあるが AE2/RS/Mekanism がパックに無い |
| redstone integrator | **削除済み** | 1.21.1-0.7.50b で削除。CC:T 本体の redstone relay を使うこと |

## `chat_box`

```lua
local c = peripheral.find("chat_box")
c.sendMessage("Hello world!")                    -- "[AP] Hello world!"
os.sleep(1)  -- クールダウン (100tick) を空ける
c.sendMessage("I am dave", "Dave")               -- "[Dave] I am dave"
c.sendMessage("Welcome!", "Box", "<>", "&b", 30) -- 範囲30・水色<>括弧
c.sendMessageToPlayer("Hi", "Player123")
c.sendToastToPlayer("本文", "タイトル", "Player123")
c.sendFormattedMessage(jsonText)                 -- JSONテキストコンポーネント
c.sendFormattedMessageToPlayer(json, "Player123")
c.sendFormattedToastToPlayer(msgJson, titleJson, "Player123")
local ev, user, msg, uuid, hidden = os.pullEvent("chat")
```

- 行頭 `$` は全体送信せずイベントだけ発火 (隠しメッセージ)。
- `run_command` 系は config で `/execute /op /give /summon` 等が禁止。
  `chatBoxWrapCommand=true` のため権限昇格の抜け道にはならない。

## `player_detector`

```lua
local d = peripheral.find("player_detector")
local all = d.getOnlinePlayers()
local pos = d.getPlayerPos("Player123")  -- x/y/z/yaw/pitch/health/dimension/uuid 等
local near = d.getPlayersInRange(30)
local inBox = d.getPlayersInCoords({x=0,y=60,z=0}, {x=16,y=80,z=16})
local inCube = d.getPlayersInCubic(10, 10, 10)  -- 中心=検出器、w/h/d
print(d.isPlayerInRange(30, "Player123"))
print(d.isPlayersInRange(30))
-- isPlayerInCoords / isPlayerInCubic / isPlayersInCoords / isPlayersInCubic も同様
local ev, user, dev = os.pullEvent("playerClick")
local ev2, user2, dim = os.pullEvent("playerJoin")   -- playerLeave / playerChangedDimension も
```

`getPlayersInCoords` の範囲は `[x1,x2)` の半開区間 (x2 側を含まない) です。
始点と終点を同じ座標にすると結果は常に空になります。

## `environment_detector`

```lua
local e = peripheral.find("environment_detector")
print(e.getBiome(), e.getDimension(), e.getTime())
print(e.getSkyLightLevel(), e.getBlockLightLevel(), e.getDayLightLevel())
print(e.isRaining(), e.isThunder(), e.isSunny())
print(e.isSlimeChunk())
print(e.getMoonName(), e.getMoonId())
print(e.listDimensions())
print(e.scanCost(8))       -- 半径の燃料コスト見積り
local r = e.scanEntities({"minecraft:zombie"})  -- 非同期 MethodResult (結果はイベントで受ける)
print(e.canSleepHere())
```

## `geo_scanner`

```lua
local g = peripheral.find("geo_scanner")
print(g.cost(8))       -- 半径の燃料コスト見積り
local r = g.scan(8)  -- 非同期 MethodResult (半径8。結果はイベントで受ける)
local c = g.chunkAnalyze()
```

## `inventory_manager` (所有者は設置者に紐付きます)

```lua
local m = peripheral.find("inventory_manager")
print(m.getOwner())
local items = m.getItems()
print(m.getItemsChest("left"))  -- 隣接チェスト名指定の一覧
print(m.getArmor())
print(m.isPlayerEquipped(), m.isWearing(1))
print(m.getEmptySpace(), m.isSpaceAvailable(), m.getFreeSlot())
print(m.getItemInHand(), m.getItemInOffHand())
m.addItemToPlayer("left", {name="minecraft:torch", count=16})
m.removeItemFromPlayer("left", {name="minecraft:torch", count=16})
```

## `nbt_storage`

```lua
local n = peripheral.find("nbt_storage")
local data = n.read()          -- MethodResult
n.writeTable({key="value"})  -- 保存したいテーブルを渡す
n.writeJson('{"a":1}')
```

## `energy_detector`

```lua
local e = peripheral.find("energy_detector")
print(e.getTransferRate())
print(e.getTransferRateLimit())
e.setTransferRateLimit(10000)
```

## `block_reader`

```lua
local b = peripheral.find("block_reader")
print(b.getBlockName())
print(b.getBlockData())    -- タイルエンティティの NBT データ
print(b.getBlockStates())
print(b.isTileEntity())
```

## `colony_integrator` (MineColonies)

```lua
local c = peripheral.find("colony_integrator")
print(c.isInColony(), c.getColonyID(), c.getColonyName(), c.getColonyStyle())
print(c.isActive(), c.getHappiness(), c.isUnderAttack(), c.isUnderRaid())
print(c.amountOfCitizens(), c.maxOfCitizens(), c.amountOfGraves())
print(c.amountOfConstructionSites())
print(c.getCitizens(), c.getVisitors(), c.getBuildings())
print(c.getWorkOrders(), c.getResearch(), c.getRequests())
print(c.getWorkOrderResources(1))
print(c.getBuilderResources({x=0, y=64, z=0}))
print(c.isWithin({x=0, y=64, z=0}), c.getLocation())
```

## タートル系: `compass` / `chunky` / automata core

```lua
print(peripheral.find("compass").getFacing())  -- 装着タートルの向き
-- chunky: attach でチャンクロード維持 (半径は config chunkyTurtleRadius=0)
-- automata core (weak/end/husbandry + overpowered3種):
--   withOperation 経由で燃料消費の制約付きで実行します。
--   クールダウンとコストは config の [Operations] を参照してください。
```
