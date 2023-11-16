#Requires AutoHotkey v1
#NoEnv  ; Recommended for performance and compatibility (future AutoHotkey releases.
; #Warn  ; Enable warnings to assist (detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Mouse, Screen

WinGet, min, MinMax
;WinGetPos, winX, winY, ogWinWidth, ogWinHeight, ahk_exe Discord.exe
;WinActivate, ahk_exe Discord.exe


WinMove, ahk_exe Discord.exe,, 0, 0
WinGetPos,,, winWidth, winHeight, ahk_exe Discord.exe

MouseMove, 170, winHeight - 40
Sleep, 500
Click

;WinMove, ahk_exe Discord.exe,, %winX%, %winY%, ogWinWidth, ogWinHeight
;if (min == -1) {
	;WinMinimize, ahk_exe Discord.exe
;}

WinActivate, ahk_exe Discord.exe
SendInput My name is ^V {Backspace 6} and I have committed several war crimes {Enter}
Sleep, 1000

WinClose, ahk_exe Discord.exe

ExitApp

Esc::ExitApp
