#Requires AutoHotkey v1
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance Force
SetBatchlines -1
OnExit, UnHook



hHookMouse := DllCall("SetWindowsHookEx", "int", 14, "Uint", RegisterCallback("Mouse", "Fast"), "Uint", 0, "Uint", 0)
Return

Mouse(nCode, wParam, lParam)
{
	ToolTip, Running
}

UnHook:
DllCall("UnhookWindowsHookEx", "Uint", hHookMouse)
ExitApp

q::
DllCall("UnhookWindowsHookEx", "Uint", hHookMouse)
ToolTip
return

Esc::ExitApp
