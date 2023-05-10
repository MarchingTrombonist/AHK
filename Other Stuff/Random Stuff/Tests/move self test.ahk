#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

containingFolder := "Presets"

;MsgBox %A_WorkingDir%
if (RegExMatch(A_WorkingDir, "\\Celeste\\Mods$")) {
	;MsgBox,,, I am in mods
	;MsgBox,,, %A_ScriptName%
	FileCreateDir, %containingFolder%
	FileCopy, %A_ScriptName%, %containingFolder%, 1
	;MsgBox,,, %A_WorkingDir%\Presets\%A_ScriptName%
	newFile = \%containingFolder%\%A_ScriptName%
	Run, %A_WorkingDir%%newFile%
	ExitApp
}

if (RegExMatch(A_WorkingDir, "\\Celeste\\Mods\\" containingFolder "$")) {
	;MsgBox,,, I am in presets
	;FileDelete, RegExReplace(A_ScriptFullPath, "\\Presets")
	oldFile := RegExReplace(A_ScriptFullPath, "\\" containingFolder)
	if (FileExist(oldFile)) {
		MsgBox,,, Deleting %oldFile%
		FileDelete, %oldFile%
	}
}

ExitApp