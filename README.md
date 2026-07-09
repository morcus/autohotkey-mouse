# autohotkey-mouse

An [AutoHotkey v2](https://www.autohotkey.com/) script that turns spare mouse buttons into
chord modifiers, layering media, zoom, tab-navigation, editing, and window-management shortcuts
onto a single mouse.

## How it works

Three physical buttons act as **chord prefixes** — hold one and press another button (or scroll
the wheel) to trigger an action. Each prefix defines its own "layer":

| Prefix | Physical button | Layer |
| --- | --- | --- |
| `XButton1` | mouse "back" button | Media & audio |
| `XButton2` | mouse "next" button | Browser & zoom |
| `F24` | extra/"sniper" button mapped to F24 | Sniper mode, navigation & editing |

`XButton1` and `XButton2` still send their normal click when pressed on their own. Holding
`F24` on its own activates **sniper mode**: the Windows pointer speed is lowered while the
button is held, and cursor movement is further damped on top of that for extra precision —
left/right clicks (including drags) work normally during the hold.

## Requirements

- Windows
- [AutoHotkey v2](https://www.autohotkey.com/) (this script uses v2 syntax — it will not run on v1)
- A mouse with `XButton1` / `XButton2` (back/next) buttons, plus optionally an extra button
  bound to `F24`
- [Microsoft PowerToys](https://learn.microsoft.com/windows/powertoys/) (FancyZones) for the
  left+right window-snapping chord

## Usage

1. Install AutoHotkey v2.
2. Double-click [`mouse.ahk`](mouse.ahk) to load it (it appears in the system tray).
3. To start it automatically, place a shortcut to `mouse.ahk` in your Startup folder
   (`shell:startup`).

After editing the script, reload it from the tray icon (**Reload Script**) or re-run the file.

## Bindings

### `XButton1` — Media & audio

| Chord | Action |
| --- | --- |
| `XButton1` + Wheel Up / Down | Volume up / down |
| `XButton1` + Middle click | Mute |
| `XButton1` + Left click | Media play / pause |
| `XButton1` + Right click | Media next track |
| `XButton1` + Wheel tilt left | Galaxy Buds2 ambient sound (Alt+NumpadDot) |
| `XButton1` + Wheel tilt right | Galaxy Buds2 ANC (Alt+NumpadSub) |

### `XButton2` — Browser & zoom

| Chord | Action |
| --- | --- |
| `XButton2` + Wheel Up / Down | Zoom in / out (Ctrl+Wheel) |
| `XButton2` + Middle click | Reopen last closed tab (Ctrl+Shift+T) |
| `XButton2` + Left click | Ctrl + Left click |
| `XButton2` + Right click | Shift + Left click |

### `F24` — Sniper mode, navigation & editing

| Chord | Action |
| --- | --- |
| `F24` (hold) | Sniper mode: lower pointer speed (`SNIPER_MOUSE_SPEED`) plus extra cursor damping (`SNIPER_EXTRA_SCALE`) while held |
| `F24` + Wheel Up / Down | Previous / next tab (Ctrl+PgUp / Ctrl+PgDn) |
| `F24` + Middle click | Refresh (F5) |
| `F24` + Wheel tilt left / right | Select word left / right (Ctrl+Shift+Arrow) |

Left and right click are deliberately not bound in this layer, so clicking and dragging stay
native while aiming in sniper mode. The pointer-speed change is temporary (not written to the
registry) and is restored on release, or on script exit if it dies mid-hold; the damping timer
simply stops. Tune `SNIPER_EXTRA_SCALE` (lower = slower) and `SNIPER_POLL_MS` (sampling
period) in `mouse.ahk` to taste.

### Other

| Input | Action |
| --- | --- |
| Left + Right button (hold) | Hold Ctrl+Shift to snap windows between PowerToys FancyZones |

## Customizing

Bindings are grouped into labeled sections in [`mouse.ahk`](mouse.ahk), one per prefix layer.
