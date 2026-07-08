#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn

; ================================================================
;  Mouse button remaps (AutoHotkey v2)
;
;  Chord model : hold a prefix button (XButton1 / XButton2 / F24),
;                then press or scroll another button to fire an
;                action. XButton1/XButton2 alone still send their
;                normal click; F24 alone is intentionally inert.
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
;  "Sniper" button (F24) - navigation & editing
;  (no bare fallback: F24 alone has no useful native action)
; ----------------------------------------------------------------

F24 & WheelUp::Send "^{PgUp}"    ; Previous tab
F24 & WheelDown::Send "^{PgDn}"  ; Next tab
F24 & MButton::Send "{F5}"       ; Refresh
F24 & LButton::Send "^c"         ; Copy
F24 & RButton::Send "#{PgDn}"    ; FancyZones - cycle overlapping windows in zone
F24 & WheelLeft::SendDebounced("^+{Left}", SELECT_DEBOUNCE_MS)   ; Select word left
F24 & WheelRight::SendDebounced("^+{Right}", SELECT_DEBOUNCE_MS) ; Select word right


; ----------------------------------------------------------------
;  Scroll wheel emulation (extra buttons)
; ----------------------------------------------------------------

F22::Send "{WheelDown 5}"        ; Scroll down x5
F23::Send "{WheelUp 5}"          ; Scroll up x5


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
