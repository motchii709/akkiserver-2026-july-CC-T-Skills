# Tom's Peripherals (1.3.1 / jar-measured)

Hi-res monitors, GPU drawing, keyboard, multi-sided redstone, watchdog timer.
Type strings are constants extracted from the jar and verified with javap:
`tm_gpu` / `tm_keyboard` / `tm_rsPort` (+`tm_redstone`) / `tm_wdt`.
The GPU drawing methods below are javap-measured from the `BaseGPU` class.

## GPU + monitor (`tm_gpu`)

```lua
local g = peripheral.find("tm_gpu")
local w, h = g.getSize()
local x, y, color = 1, 1, colors.white  -- example draw position and color
g.fill(x, y, w, h, color)
local x1, y1, x2, y2 = 1, 1, 10, 5
g.filledRectangle(x1, y1, x2, y2, color)
g.rectangle(x1, y1, x2, y2, color)
g.line(x1, y1, x2, y2, color)
g.drawText(x, y, "hello", colors.white, colors.black, 1, 0)
g.drawTextSmart(x, y, "hello", colors.white, colors.black, false, 1, 0)
g.drawChar(x, y, "A", colors.white, colors.black, 1)
-- drawBuffer/drawImage need real pixel data / a saved image; shapes below are illustrative
-- g.drawBuffer(x, y, width, scale, <pixel-data-table>)
-- g.drawImage(x, y, "<saved-image-name>")  -- name must already exist via saveImage
g.sync()  -- flush the drawing
print(g.getBounds())
-- fonts:
print(table.unpack(g.getFont()))
g.setFont("ascii")
g.setFontDefaultCharID(0); print(g.getFontDefaultCharID())
print(g.getTextLength("hello", 1, 0))
-- addNewChar needs a real 16-row bitmap; shape is illustrative, {} is NOT valid
-- g.addNewChar("X", 8, <16-row-bitmap>)
g.delChar("X"); print(g.freeChars()); g.clearChars()
-- windows:
local win = g.createWindow(x, y, w, h)
local win3d = g.createWindow3D(x, y, w, h)
```

Running out of VRAM fails with `Not enough VRAM for screen buffer`.
For multiple monitors, place them adjacent to the GPU block and connect them
(plain in-game placement handles this).

## Keyboard (`tm_keyboard`)

```lua
local k = peripheral.find("tm_keyboard")
k.setFireNativeEvents(true)  -- whether native key events fire
```

Key presses arrive at the computer as `key` events. Combine with the dongle
block for wireless use.

## Redstone (`tm_rsPort` / `tm_redstone`)

```lua
local r = peripheral.find("tm_rsPort")
print(table.unpack(r.getSides()))
print(r.getInput("left"), r.getAnalogInput("left"))
print(r.getOutput("right"), r.getAnalogOutput("right"))
r.setOutput("right", true)
r.setAnalogOutput("right", 10)
print(r.getBundledInput("back"), r.getBundledOutput("back"))
r.setBundledOutput("back", colors.combine(colors.red, colors.blue))
print(r.testBundledInput("back", colors.red))  -- (side, color mask)
-- getAnalogueInput / getAnalogueOutput / setAnalogueOutput are spelling aliases
```

## Watchdog timer (`tm_wdt`)

A watchdog timer that raises a redstone signal if `reset()` is not called in time.

```lua
local w = peripheral.find("tm_wdt")
w.setTimeout(200)  -- must exceed 20 ticks (~1s); cannot change while running
w.setEnabled(true)
w.reset()  -- call periodically to avoid timing out
print(w.isEnabled(), w.getTimeout())
```
