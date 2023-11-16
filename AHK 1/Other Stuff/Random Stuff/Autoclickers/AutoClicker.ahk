#Requires AutoHotkey v1
#NoEnv  ; Recommended for performance and compatibility (future AutoHotkey releases.
; #Warn  ; Enable warnings to assist (detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

ToggleL := 0
ToggleR := 0
ToggleClick := 0

Numpad1::
ToggleL = !ToggleL
If ToggleL
	Click, Down
else
	Click, Up
return

Numpad2::
ToggleR = !ToggleR
If ToggleR
	Click, R, Down
else
	Click, R, Up
return

Numpad3::
ToggleClick = !ToggleClick
while ToggleClick
	click
return

^!r::Reload
