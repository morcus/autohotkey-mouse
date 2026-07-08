; #InstallKeybdHook


; ------------------------
; Right click enhancements
; ------------------------

;(RButton Up):: Send "{RButton Up}"
;(RButton Dn):: Send "{RButton Down}"
;RButton::
;RButton & WheelUp::Send "{PgUp}"
;RButton & WheelDown::Send "{PgDn}"

; --------------------------------
; Mouse "back" button enhancements
; --------------------------------

; Wheel UP
XButton1 & WheelUp::Send "{Volume_Up}"						; Volume +

; Wheel Down
XButton1 & WheelDown::Send "{Volume_Down}"					; Volume -

; Middle button
XButton1 & MButton::Send "{Volume_Mute}"					; Volume Mute

; Left button
XButton1 & LButton::Send "{Media_Play_Pause}"				; Media Play/Pause

; Right button
XButton1 & RButton::Send "{Media_Next}"						; Media Next

	; Middle tilt left
	XButton1 & WheelLeft::
	{
	Send "{ALTDOWN}{NumpadDot}{ALTUP}"						; Buds2 ambiant sound
	Sleep 250
	return
	}

	; Middle tilt right
	XButton1 & WheelRight::
	{
	Send "{ALTDOWN}{NumpadSub}{ALTUP}"						; Buds2 anc
	Sleep 250
	return
	}


; Deprecated
; XButton1 & WheelLeft::Send "{Media_Prev}"					; Media Prev
; XButton1 & WheelRight::Send "{Media_Next}"				; Media Next	???	duplicated

; Default
XButton1:: Send "{XButton1}"								; Default button


; --------------------------------
; Mouse "next" button enhancements
; --------------------------------

; Wheel UP
XButton2 & WheelUp::Send "{CTRLDOWN}{WheelUp}{CTRLUP}"				; Zoom +

; Wheel Down
XButton2 & WheelDown::Send "{CTRLDOWN}{WheelDown}{CTRLUP}"			; Zoom -

; Middle button
XButton2 & MButton::Send "^+{t}"									; Firefox: Open last closed tab

; Left button
XButton2 & LButton::Send "{CTRLDOWN}{LButton}{CTRLUP}"				; Ctrl + Left Mouse

; Right button
XButton2 & RButton::Send "{SHIFTDOWN}{LButton}{SHIFTUP}"			; Shift + Left Mouse

; Middle tilt left
; NOTHING

; Middle tilt right
; NOTHING

; Deprecated
; XButton2 & WheelUp::Send "{CTRLDOWN}{+}{CTRLUP}"					; Zoom +
; XButton2 & WheelDown::Send "{CTRLDOWN}{-}{CTRLUP}"				; Zoom -
; XButton2 & WheelLeft::Send "{CTRLDOWN}{PgUp}{CTRLUP}"				; Previous TAB
; XButton2 & WheelRight::Send "{CTRLDOWN}{PgDn}{CTRLUP}"			; Next TAB

; Default
XButton2::Send "{XButton2}"											; Default button


; ----------------------------------
; Mouse "sniper" button enhancements
; ----------------------------------

; Wheel UP
F24 & WheelUp::Send "{CTRLDOWN}{PgUp}{CTRLUP}"					; Previous TAB

; Wheel Down
F24 & WheelDown::Send "{CTRLDOWN}{PgDn}{CTRLUP}"				; Next TAB

; Middle button
F24 & MButton::Send "{F5}"										; F5 - refresh

; Left button
F24 & LButton::Send "{CTRLDOWN}c{CTRLUP}"						; CTRL + C

; Right button
F24 & RButton::Send "{LWinDOWN}{PgDn}{LWinUP}"					; CTRL + V

; Wheel tilt left
F24 & WheelLeft::
{
Send "{CTRLDOWN}{SHIFTDOWN}{Left}{CTRLUP}{SHIFTUP}"				; select word left
Sleep 150
return
}

; Wheel tilt right
F24 & WheelRight::												; select word right
{
Send "{CTRLDOWN}{SHIFTDOWN}{Right}{CTRLUP}{SHIFTUP}"
Sleep 150
return
}

; F24:: Send "{XButton1}"										; Default button
; F23:: sendinput "{ASC 096}"
; F23:: send "````"
; F1::Send "{F23}"
; F2::Send "{F22}"
; F3::Send "{F21}"
; F4::Send "{F16}"
; F5::Send "{F17}"

F22::Send "{WheelDown 5}"
F23::Send "{WheelUp 5}"


; Deprecated
; F24 & WheelUp::Send "{PgUp}"									; Page Up
; F24 & WheelDown::Send "{PgDn}"								; Page Down



; --------------------------------------------------------------------------------------
; Microsoft PowerToys FancyZones - move window to zone with left and right mouse buttons
; --------------------------------------------------------------------------------------

~lbutton & rbutton::
{
	while GetKeyState("lbutton", "P")
	{
		; if !GetKeyState("rbutton", "P")
		; {
		; 	send "{SHIFTUp}{CTRLUp}"
		; 	return
		; }
		
		Send "{SHIFTDown}{CTRLDown}"
		sleep 50
	}
send "{SHIFTUp}{CTRLUp}"
return
}


;rbutton & WheelUp::Send "{CTRLDOWN}{PgUp}{CTRLUP}"				; Previous TAB
;rbutton & WheelDown::Send "{CTRLDOWN}{PgDn}{CTRLUP}"			; Next TAB
;rbutton:: Send "{rbutton}"



; ~rbutton & WheelUp::
; {
; 	while GetKeyState("rbutton", "T")
; 	{
; 		Send "{CTRLDOWN}{PgUp}{CTRLUP}"
; 	}
; }
