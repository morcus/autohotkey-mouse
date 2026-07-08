#Requires AutoHotkey v2.0
#SingleInstance Force

; ================================================================
;  Mouse button remaps (AutoHotkey v2)
;
;  Chord model : hold a prefix button (XButton1 / XButton2 / F24),
;                then press or scroll another button to fire an
;                action. Each prefix alone still sends its normal
;                click.
;  Modifiers   : ^ Ctrl    + Shift    ! Alt    # Win
; ================================================================


; ----------------------------------------------------------------
;  "Back" button (XButton1) - media & audio
; ----------------------------------------------------------------

XButton1 & WheelUp::Send "{Volume_Up}"        ; Volume +
XButton1 & WheelDown::Send "{Volume_Down}"    ; Volume -
XButton1 & MButton::Send "{Volume_Mute}"      ; Volume mute
XButton1 & LButton::Send "{Media_Play_Pause}" ; Play / pause
XButton1 & RButton::Send "{Media_Next}"       ; Next track

XButton1 & WheelLeft::   ; Galaxy Buds2 - ambient sound
{
    Send "!{NumpadDot}"
    Sleep 250
}

XButton1 & WheelRight::  ; Galaxy Buds2 - ANC
{
    Send "!{NumpadSub}"
    Sleep 250
}

XButton1::Send "{XButton1}"                   ; passthrough (normal back click)


; ----------------------------------------------------------------
;  "Next" button (XButton2) - browser & zoom
; ----------------------------------------------------------------

XButton2 & WheelUp::Send "^{WheelUp}"       ; Zoom in
XButton2 & WheelDown::Send "^{WheelDown}"   ; Zoom out
XButton2 & MButton::Send "^+{t}"            ; Reopen last closed tab
XButton2 & LButton::Send "^{LButton}"       ; Ctrl + click
XButton2 & RButton::Send "+{LButton}"       ; Shift + click

XButton2::Send "{XButton2}"                 ; passthrough (normal forward click)


; ----------------------------------------------------------------
;  "Sniper" button (F24) - navigation & editing
; ----------------------------------------------------------------

F24 & WheelUp::Send "^{PgUp}"    ; Previous tab
F24 & WheelDown::Send "^{PgDn}"  ; Next tab
F24 & MButton::Send "{F5}"       ; Refresh
F24 & LButton::Send "^c"         ; Copy
F24 & RButton::Send "#{PgDn}"    ; Win + PgDn

F24 & WheelLeft::   ; Select word left
{
    Send "^+{Left}"
    Sleep 150
}

F24 & WheelRight::  ; Select word right
{
    Send "^+{Right}"
    Sleep 150
}


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
