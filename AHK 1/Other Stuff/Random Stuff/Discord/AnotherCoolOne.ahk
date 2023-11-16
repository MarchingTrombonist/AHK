#Requires AutoHotkey v1
#NoEnv  ; Recommended for performance and compatibility (future AutoHotkey releases.
; #Warn  ; Enable warnings to assist (detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

WinActivate, ahk_exe Discord.exe
CoordMode, Mouse, Screen

;ControlSend, ahk_parent, Click, Discord

WinGetPos, winX, winY,,, ahk_exe Discord.exe
ToolTip, %winX%`, %winY%`, %winWidth%`, %winHeight%`

WinMove, ahk_exe Discord.exe,, 0, 0
WinGetPos,,, winWidth, winHeight, ahk_exe Discord.exe

MouseMove, 135, winHeight - 40
Sleep, 500
Click

WinMove, ahk_exe Discord.exe,, %winX%, %winY%

WinActivate, ahk_exe Discord.exe
Send My name is ^V {Backspace 6} and I like feet

Esc::ExitApp
