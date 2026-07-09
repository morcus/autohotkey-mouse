#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
CoordMode "Mouse", "Screen"  ; MouseGetPos/SetCursorPos agree on screen coordinates (sniper damping)

; ================================================================
;  Mouse button remaps (AutoHotkey v2)
;
;  Chord model : hold a prefix button (XButton1 / XButton2 / F24),
;                then press or scroll another button to fire an
;                action. XButton1/XButton2 alone still send their
;                normal click; F24 held alone is sniper mode
;                (lowered pointer speed for precise movement).
;  Modifiers   : ^ Ctrl    + Shift    ! Alt    # Win
; ================================================================


; ----------------------------------------------------------------
;  Debounced send helper
; ----------------------------------------------------------------

; One physical wheel flick emits several ticks. Sleeping keeps this
; hotkey's thread busy, and AutoHotkey discards the extra ticks
; because #MaxThreadsPerHotkey is 1 by default - do not raise it.
BUDS_DEBOUNCE_MS   := 250
SELECT_DEBOUNCE_MS := 150

SendDebounced(keys, ms) {
    Send keys
    Sleep ms
}


; ----------------------------------------------------------------
;  "Back" button (XButton1) - media & audio
; ----------------------------------------------------------------

XButton1 & WheelUp::Send "{Volume_Up}"        ; Volume +
XButton1 & WheelDown::Send "{Volume_Down}"    ; Volume -
XButton1 & MButton::Send "{Volume_Mute}"      ; Volume mute
XButton1 & LButton::Send "{Media_Play_Pause}" ; Play / pause
XButton1 & RButton::Send "{Media_Next}"       ; Next track
XButton1 & WheelLeft::SendDebounced("!{NumpadDot}", BUDS_DEBOUNCE_MS)  ; Galaxy Buds2 - ambient sound
XButton1 & WheelRight::SendDebounced("!{NumpadSub}", BUDS_DEBOUNCE_MS) ; Galaxy Buds2 - ANC

XButton1::Send "{Blind}{XButton1}"            ; passthrough (keeps held modifiers)


; ----------------------------------------------------------------
;  "Next" button (XButton2) - browser & zoom
; ----------------------------------------------------------------

XButton2 & WheelUp::Send "^{WheelUp}"       ; Zoom in
XButton2 & WheelDown::Send "^{WheelDown}"   ; Zoom out
XButton2 & MButton::Send "^+{t}"            ; Reopen last closed tab
XButton2 & LButton::Send "^{LButton}"       ; Ctrl + left click
XButton2 & RButton::Send "+{LButton}"       ; Shift + left click

XButton2::Send "{Blind}{XButton2}"          ; passthrough (keeps held modifiers)


; ----------------------------------------------------------------
;  "Sniper" button (F24) - precision, navigation & editing
;  (held alone, F24 lowers the pointer speed and damps cursor
;   movement further still; left/right click are deliberately
;   unbound so clicks and drags stay native while aiming)
; ----------------------------------------------------------------

SNIPER_MOUSE_SPEED := 1   ; Windows pointer speed (1-20) while F24 is held; default is 10
SNIPER_EXTRA_SCALE := 1 ; extra damping on top of the OS floor above (1.0 = none, lower = slower)
SNIPER_POLL_MS     := 8   ; cursor-damping sample period in ms (125 Hz)

F24 & WheelUp::Send "^{PgUp}"    ; Previous tab
F24 & WheelDown::Send "^{PgDn}"  ; Next tab
F24 & MButton::Send "{F5}"       ; Refresh
F24 & WheelLeft::SendDebounced("^+{Left}", SELECT_DEBOUNCE_MS)   ; Select word left
F24 & WheelRight::SendDebounced("^+{Right}", SELECT_DEBOUNCE_MS) ; Select word right

; The ~ makes this fire on press instead of release (the default
; for a custom-combination prefix key); F24's own keystroke leaks
; through to the OS, which is harmless since F24 does nothing.
~F24::   ; Sniper mode - lower pointer speed and damp cursor movement while held
{
    normal := GetMouseSpeed()
    OnExit RestoreSpeed              ; restore even if the script exits mid-hold
    SetMouseSpeed(SNIPER_MOUSE_SPEED)

    MouseGetPos &refX, &refY
    SetTimer SniperDamp, SNIPER_POLL_MS

    KeyWait "F24"                    ; until the sniper button is released

    SetTimer SniperDamp, 0
    RestoreSpeed()
    OnExit RestoreSpeed, 0

    RestoreSpeed(*) {
        SetMouseSpeed(normal)        ; no return value: a nonzero OnExit result would veto exit
    }

    ; Windows' pointer-speed floor (1) still moves the cursor faster than
    ; desired for fine work, so this reins in each poll's movement to a
    ; fraction of what the OS already applied, rather than the raw
    ; hardware delta - keeps clicks/drags untouched since only the
    ; cursor position is adjusted, not any button state.
    SniperDamp() {
        MouseGetPos &curX, &curY
        refX += (curX - refX) * SNIPER_EXTRA_SCALE
        refY += (curY - refY) * SNIPER_EXTRA_SCALE
        DllCall("SetCursorPos", "Int", Round(refX), "Int", Round(refY))
    }
}

GetMouseSpeed() {
    speed := 0
    DllCall("SystemParametersInfo", "UInt", 0x70, "UInt", 0, "UInt*", &speed, "UInt", 0)  ; SPI_GETMOUSESPEED
    return speed
}

SetMouseSpeed(speed) {
    DllCall("SystemParametersInfo", "UInt", 0x71, "UInt", 0, "Ptr", speed, "UInt", 0)  ; SPI_SETMOUSESPEED
}


; ----------------------------------------------------------------
;  "Back" + "Next" buttons together - FancyZones
;  (both press orders defined so either button can be held first)
; ----------------------------------------------------------------

XButton1 & XButton2::Send "#{PgDn}" ; Cycle overlapping windows in zone
XButton2 & XButton1::Send "#{PgDn}" ; Cycle overlapping windows in zone


; ----------------------------------------------------------------
;  PowerToys FancyZones - snap window while dragging
;  (hold Left, then Right, and drag)
; ----------------------------------------------------------------

~LButton & RButton::
{
    Send "{Shift Down}{Ctrl Down}"  ; hold Shift+Ctrl while dragging
    KeyWait "LButton"               ; until the left button is released
    Send "{Shift Up}{Ctrl Up}"
}
