# Tom's Peripherals (1.3.1 / jar-measured)

Hi-res monitors, GPU drawing, keyboard, multi-sided redstone, watchdog timer.
Type strings are constants extracted from the jar and verified with javap:
`tm_gpu` / `tm_keyboard` / `tm_rsPort` / `tm_wdt`.
(`tm_redstone` is not a type — it is the redstone-input-changed event the RS
port queues on input change; wait with `os.pullEvent("tm_redstone")`.)
The GPU drawing methods below are javap-measured from the `BaseGPU` class
(plus `GPUImpl`/`GPUExt`, which share the same `tm_gpu` peripheral).

Colors are raw `0xAARRGGBB` ints, `(r,g,b)`, or `(a,r,g,b)` tuples. CC palette
constants like `colors.white` (=1) are NOT RGB and render nearly black — prefer
`0xFFFFFFFF`-style ints or `(r,g,b)` triples in GPU calls.

## GPU + monitor (`tm_gpu`)

```lua
local g = peripheral.find("tm_gpu")
local w, h = g.getSize()  -- actually returns width, height, blocksX, blocksY, pixelScale
local x, y, color = 1, 1, 0xFFFFFFFF  -- example draw position and color
g.fill(color)  -- fills the whole screen/window; color optional (default black).
-- NOTE: fill takes ONLY an optional color, not x/y/w/h (jar-measured).
local rx, ry, rw, rh = 1, 1, 10, 5  -- 1-based x,y plus WIDTH,HEIGHT (not corner pairs)
g.filledRectangle(rx, ry, rw, rh, color)
g.rectangle(rx, ry, rw, rh, color)
g.line(rx, ry, rx + rw, ry + rh, color)  -- 1-based endpoints, color optional
g.lineS(rx, ry, rx + rw, ry + rh, color)  -- same args as line (jar: 'expected x1,y1,x2,y2,[color]')
g.drawText(x, y, "hello", 0xFFFFFFFF, 0xFF000000, 1, 0)
g.drawTextSmart(x, y, "hello", 0xFFFFFFFF, 0xFF000000, false, 1, 0)
local id = g.addNewChar("X", 8, ...)  -- 16 numbers of char bitmap follow the width
-- 3rd arg of drawChar is a NUMBER char id (jar: 'expected (number x,number y,number char,...)'):
g.drawChar(x, y, id, 0xFFFFFFFF, 0xFF000000, 1)
-- pixel data is vararg numbers (jar: 'expected (number x,number y,number w,number scale,number... data)'):
g.drawBuffer(x, y, w, 1, 0, 1, 0, 1)
-- images are ref objects (jar: 'expected (number x, number y, image ref)'):
local img = g.newImage(w, h)  -- or g.decodeImage(buffer-or-numbers), g.imageFromBuffer(...)
g.drawImage(x, y, img)
local buf = g.newBuffer()  -- LuaByteBuffer: write/read/free/length/available
print(g.getUsedMemory(), g.getMaxMemory())  -- VRAM is 16 MiB total (16777216)
-- g.setSize(n)  -- pixel scale 16..64 (rebuilds the screen buffer); g.refreshSize()
g.sync()  -- flush the drawing
print(g.getBounds())
-- fonts (getFont returns name + info; builtins include 'ascii', 'ascii_sga', unicode pages):
print(table.unpack(g.getFont()))
g.setFont("ascii")  -- errors 'Font file not found' for bad names
-- addNewChar/delChar/setFontDefaultCharID only work on editable (custom) fonts,
-- else 'Selected font is not modifiable'
g.setFontDefaultCharID(0); print(g.getFontDefaultCharID())
print(g.getTextLength("hello", 1, 0))
g.delChar("X"); print(g.freeChars()); g.clearChars()
-- windows:
local win = g.createWindow(x, y, w, h)
-- 3D windows expose a GPU3D OpenGL-like object (glBegin/glEnd/glVertex/glColor/
-- glTexCoord/glTranslate/glScale/glRotate/glFrustum/glDirLight/glGenTextures/
-- glBindTexture/glTexImage/render/clear/sync/getConstants/getBounds — jar-measured
-- names; exact arities TBD in-game):
local win3d = g.createWindow3D(x, y, w, h)
```

VRAM is 16 MiB; a screen costs width*height*4 bytes. Failures: `Attached screen
too big` / `Not enough VRAM for screen buffer`. Monitors are NOT peripherals
themselves — place same-facing monitor blocks adjacent to (or in a wall next
to) the GPU and draw via `tm_gpu`. Touch input arrives as
`tm_monitor_touch(side, x, y, pressed)` on right-click (x,y are 1-based pixels).

## Keyboard (`tm_keyboard`)

The sole method is `setFireNativeEvents(boolean)` (default false):

```lua
local k = peripheral.find("tm_keyboard")
k.setFireNativeEvents(true)
```

Default (false): events are `tm_keyboard_key` / `tm_keyboard_key_up` /
`tm_keyboard_char`, with the keyboard's attached name as first arg. With
`setFireNativeEvents(true)` the raw CC `key` / `key_up` / `char` events fire
instead (plus `paste` on paste). For wireless use, bind a portable-keyboard
item to a keyboard-dongle block (`dongle_not_found` / `dongle_out_of_range`
chat errors if unbound).

## Redstone (`tm_rsPort`)

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
-- sides: up/down/north/south/east/west; analog range 0-15
```

## Watchdog timer (`tm_wdt`)

A watchdog timer that REBOOTS the computer the block faces if `reset()` is not
called in time (no redstone output).

```lua
local w = peripheral.find("tm_wdt")
w.setTimeout(200)  -- at least 20 ticks (20 ticks = ~1s); cannot change while running
w.setEnabled(true)
w.reset()  -- call periodically to avoid a reboot; also resets on setEnabled/setTimeout
print(w.isEnabled(), w.getTimeout())
```

On expiry the WDT disables itself and restarts the computer adjacent on its
facing side.
