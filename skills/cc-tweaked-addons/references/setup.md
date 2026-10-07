# Physical setup — wiring, wireless, monitors, turtles, chunks

Lua alone builds nothing. This page covers the blocks and placement the Lua
references assume. Confirm both uncertain points in-game before freezing
dependent builds (see bottom).

## Wired network

Place a Wired Modem on the computer (adjacent, right-click to attach) and one
on each distant peripheral (or on one block of a peripheral cluster). Connect
modems with Networking Cable (cable alone carries no signal).
`peripheral.getNames()` then lists direct-attached sides as `left/right/...`
and wired remotes with generated names (e.g. `monitor_0`,
`Create_StockTicker_1`); names can shift as devices join — prefer
`peripheral.find("Create_StockTicker")` over hardcoded names. Verify:

```lua
for _, n in ipairs(peripheral.getNames()) do print(n, peripheral.getType(n)) end
```

Cable max length is effectively unlimited; modems bridge across the whole run.

## Wireless (config-measured: modem_range=64, high_altitude=384, storm 64/384)

Attach a Wireless Modem (place against computer/turtle, or Ender Modem for
global reach). Normal range is ~64 blocks at the same altitude, ~384 only when
both ends are at high altitude; rain/storm collapses range back down. Ender
Modem means unlimited range plus cross-dimension.

```lua
rednet.open("top")  -- side the modem is on; without this, sends/receives silently drop
rednet.send(id, "msg")
local sender, msg = rednet.receive()
-- raw modem API alternative:
local m = peripheral.wrap("top")
m.open(1)  -- channels 0..65535, 65535 = broadcast
m.transmit(1, 2, "hi")
print(m.isWireless())
```

## Adjacency vs network

Network-safe (wrapping over cable is fine): StockTicker, RedstoneRequester,
Frogport/Postbox, Packager/Repackager, Station, chat_box, player/environment
detectors (they read at their own position), nbt_storage, colony_integrator,
scroller/create_source/create_target, redrouter, Tom's RS port.

Position-coupled (the block must touch or face its target): block_reader
(reads the block it faces), energy_detector (must sit inline on the energy
path), inventory_manager `getItemsChest("left")` (the chest must touch the
manager; the side is manager-relative), Tom `tm_gpu` monitors (each monitor
must touch the GPU block or another monitor in the same panel), Create
DisplayLink/Nixie (mounted on the display), Station/Signal (mounted on track).

Rule: sensing or actuating the world happens where the block sits, not where
the computer sits.

## Logistics network formation

Membership is physical, not addresses: StockTicker, packagers,
RedstoneRequester, Frogport/Postbox, and storage must all touch the same
inventory network (inventories joined by chutes/belts/funnels or direct
contact), each accessor block placed against the inventory it serves.
A Frogport `setAddress("Generated")` is only the delivery address, not network
membership — two ports with the same address on different networks do not see
each other. Debug order:

1. `ticker.stock()` empty? The ticker is not on the storage network.
2. Requester fires but nothing packs? The requester is not on the packager network.
3. Package made but never arrives? Wrong Frogport address/mode (check
   `getAddress`/`getConfiguration`, spelling `send_recieve`).

One ticker per network is enough; multiple requesters and ports can share it.
Unconfirmed: the exact network-link formation rule varies by Create minor
version — verify in-game for your pack version.

## Monitors (config: computer term 51x19, monitor panel max 8x6 blocks)

Place Advanced (color) or Normal (mono) monitors in a rectangle up to 8 wide by
6 high in blocks; they fuse into one panel on placement (right-click an edge if
a seam stays). Wrap the panel with `peripheral.find("monitor")`; size in
characters depends on text scale:

```lua
local mon = peripheral.find("monitor")
mon.setTextScale(0.5)  -- 0.5/1/2/4/5; smallest shows the most text
mon.clear(); mon.setCursorPos(1, 1); mon.write("hello")
```

Tom `tm_gpu` hi-res monitors are separate: place them touching the GPU block
(see [toms.md](toms.md)), not as CC monitor panels.

## Turtles (need_fuel=true; AP pockets use no fuel)

Equip: hold the upgrade item and run `turtle.equipLeft()` / `turtle.equipRight()`
(or craft turtle + item). Fuel: `turtle.refuel()` burns inventory fuel,
`turtle.getFuelLevel()` / `turtle.getFuelLimit()`; movement costs 1 per block.
Farm minimum: fuel in a slot plus `refuel()` at startup, a compass upgrade for
heading (`getFacing()`), a chunky upgrade to keep the work chunk loaded, an
automata core (weak/end/husbandry) only when using `withOperation` tools.
Unload with `turtle.drop()` / `turtle.suck()` against an adjacent chest.
Fuel limits rate, not permission — keep turtles out of other players' claims
and supervise loops.

## Chunk loading

CC computers and turtles do not force-load chunks by default. Keep the farm
loaded: a turtle `chunky` upgrade for mobile farms, a dedicated chunk-loader
block for the base cell (computer + ticker + requester + frogport + storage),
or keep the whole network inside one routinely visited chunk. Symptom check:
events stop plus stale `stock()` plus no `package_received` means an unloaded
chunk, not a Lua bug. Verify with player_detector/environment_detector reads
before debugging code. Chunky here means radius 0 (own chunk) for 600s —
don't mass-spawn chunky turtles; prefer one loader for the base cell.
