# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A single AutoHotkey **v2** script ([mouse.ahk](mouse.ahk)) that remaps mouse buttons on a
multi-button mouse into media, zoom, tab, and window-management controls. There is no build,
lint, or test tooling — the script is the entire project.

## Running / testing changes

There is no CLI. To try a change, the user runs the script with AutoHotkey v2 (double-click
`mouse.ahk`, or `AutoHotkey.exe mouse.ahk`), which loads it into the tray. After editing, the
running instance must be reloaded (tray icon → Reload Script, or re-run the file) for changes
to take effect. Because hotkeys act on live input, most behavior can only be verified by the
user physically pressing the buttons — you generally cannot self-verify runtime behavior here.

Note this is AutoHotkey **v2** syntax (`Hotkey::Send "text"`, quoted send strings, braced
multi-line hotkey blocks). Do not introduce v1 syntax (`Send, text`, unquoted args).

## Architecture

The script is built almost entirely on AutoHotkey's **custom combination** hotkeys
(`Prefix & Key::`), which fire only when `Prefix` is held while `Key` is pressed. Three
physical buttons act as chord prefixes, each defining its own "layer" of actions:

- **`XButton1`** (mouse "back" button) — media & audio: volume via wheel, mute, play/pause,
  next track, and Galaxy Buds2 ambient/ANC toggles (sent as Alt+Numpad combos).
- **`XButton2`** (mouse "next" button) — browser/zoom: Ctrl+wheel zoom, reopen-closed-tab,
  Ctrl/Shift + click.
- **`F24`** (a "sniper"/extra mouse button mapped to F24) — sniper mode plus
  navigation/editing: Ctrl+PgUp/PgDn tab switching, F5 refresh, and word-by-word selection.
  `F24 & LButton` / `F24 & RButton` are deliberately left unbound so clicks and drags stay
  native while aiming in sniper mode.

`XButton1` and `XButton2` also have a bare fallback (`XButton1::Send "{Blind}{XButton1}"`)
so the button still does its normal click when pressed alone — the `{Blind}` preserves any
physically held modifiers (e.g. Ctrl+Back in a browser). `F24`'s bare hotkey is **sniper
mode**: `~F24::` lowers the Windows pointer speed (SPI_SETMOUSESPEED via `DllCall`, session
only — never persisted to the registry) to `SNIPER_MOUSE_SPEED` while the button is held,
then restores it on release (and on script exit via `OnExit`, in case the script dies
mid-hold). The `~` prefix matters: without it a custom-combination prefix key's own hotkey
fires on *release*, not press.

`SNIPER_MOUSE_SPEED` alone bottoms out at Windows' API floor (1 on its 1-20 scale), which is
still too fast for fine work, so the same `~F24::` block layers a **cursor damping timer** on
top: `SetTimer SniperDamp, SNIPER_POLL_MS` samples the cursor position every few ms and moves
it only `SNIPER_EXTRA_SCALE` of the way toward where it actually moved (an exponential-lag
filter via `DllCall("SetCursorPos", ...)`), then `SetTimer SniperDamp, 0` stops it on release.
This needed `CoordMode "Mouse", "Screen"` at the top of the file, since `MouseGetPos` defaults
to client-area-relative coordinates while `SetCursorPos` always expects screen coordinates.
`refX`/`refY` are captured as closure variables shared between the hotkey body and the nested
`SniperDamp()` function (same mechanism as `normal` for `RestoreSpeed`, but read *and*
written here — AHK v2 allows this because they're first referenced with `&` in the outer
scope). This approach was chosen over a `WH_MOUSE_LL` hook or third-party drivers (RawAccel,
Interception) specifically because it needs no kernel driver or admin rights — relevant since
this runs on a work PC where such installs may be blocked by IT/EDR policy.

A separate chord, `~LButton & RButton::`, holds Ctrl+Shift while the left button is down
(via `KeyWait "LButton"`) to drag windows between **PowerToys FancyZones** — the `~` keeps the
physical left-click passing through to the OS.

### Conventions when editing

- The bindings are organized into labeled sections (a header comment banner per prefix layer);
  keep new bindings inside the matching section, one per line.
- Give each binding a trailing `;` comment describing its effect, aligned into a space-padded
  column so the section reads as a `binding → effect` table. Indentation and alignment use
  **spaces, not tabs** — keep it that way so columns render identically in every editor. The
  binding's key names already convey which input, so no separate label comment is needed.
- For multi-line hotkeys with a `{ }` block, put the effect comment on the `::` declaration
  line (e.g. `F24 & WheelLeft::   ; Select word left`).
- Prefer AutoHotkey's built-in modifier prefixes in send strings — `^` Ctrl, `+` Shift,
  `!` Alt, `#` Win — over the verbose `{CtrlDown}…{CtrlUp}` form.
- Wheel-tick actions that must not fire once per tick go through the `SendDebounced(keys, ms)`
  helper with a named `*_DEBOUNCE_MS` constant. The debounce only works because
  `#MaxThreadsPerHotkey` is left at its default of 1 (extra ticks are discarded while the
  thread sleeps) — do not raise it.
- Keep the file ASCII-only (plain `-`, no accented characters) to avoid encoding issues when
  AutoHotkey reads the script.
