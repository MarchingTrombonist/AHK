#NoEnv  ; Recommended for performance and compatibility (future AutoHotkey releases.
; #Warn  ; Enable warnings to assist (detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
OnExit, ExitRun

SetKeyDelay, 0, 50
CoordMode, Mouse
active := false
distance := 30
speed := 0

Run, https://classic.minecraft.net/
checkOpen()
Sleep, 1000
WinActivate, Minecraft
Sleep, 1000
WinMove, Minecraft,, 0, 0
Send #{Up 3}
Sleep, 200
checkLoad()
Sleep, 500
Click 2
SendInput {Backspace 100}Steve
Click
Sleep, 1000
PixelSearch, boxX, boxY, 100, A_ScreenHeight * 2/3, A_ScreenWidth - 100, A_ScreenHeight - 100, 0x6F6F6F,, Fast
MouseMove, %boxX%, %boxY%, 0
Click
Send {F11}

active := true

MsgBox, 0, Cursed, Have fun :) (Esc to quit), 3
IfMsgBox, Ok
	Click
else
	Click
MouseGetPos, centerX, centerY
SetTimer, mouseDetector, 50

SetTimer, mouseDetector, 50

w::
if active {
	MouseMove, 0, -distance, speed, R
	return
}
Send {w}
return

s::
if active {
	MouseMove, 0, distance, speed, R
	return
}
Send {s}
return

a::
if active {
	MouseMove, -distance, 0, speed, R
	return
}
Send {a}
return

d::
if active {
	MouseMove, distance, 0, speed, R
	return
}
Send {d}
return

Esc::						; Exit script (Esc)
SplashTextOn,,, Exiting
ExitApp
return

; LABELS

ExitRun:
Send {F11}
Send ^w
Sleep, 200
Send {Enter}
SplashTextOff
ExitApp
return


checkLoad() {
	loading := true
	boxX := ""
	boxY := ""
	while loading == true {
		PixelSearch, boxX, boxY, 100, A_ScreenHeight * 2/3, A_ScreenWidth - 100, A_ScreenHeight - 100, 0x000000,, Fast
		if (boxX > 100) {
			MouseMove, %boxX%, %boxY%, 0
			loading := false
			Break
			return
		}
	}
}

checkOpen() {
	open := false
	while open != false {
		if WinExist("Minecraft") {
			open := true
			Break
			return
		}
	}
}

mouseDetector:
CoordMode, Mouse
MouseGetPos, posx, posy
if (posx > centerX) {
ControlSend, ahk_parent, d, Minecraft
}
if (posx < centerX) {
ControlSend, ahk_parent, a, Minecraft
}
if (posy > centerY) {
ControlSend, ahk_parent, s, Minecraft
}
if (posy < centerY) {
ControlSend, ahk_parent, w, Minecraft
}
return