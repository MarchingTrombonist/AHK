#Requires AutoHotkey v2

containingFolder := "Presets"

MsgBox(A_WorkingDir)
if (RegExMatch(A_WorkingDir, "Tests$")) {
	MsgBox("I am in mods")
	MsgBox(A_ScriptName)
	DirCreate containingFolder
	FileCopy A_ScriptName, containingFolder, 1
	;MsgBox(%A_WorkingDir%\Presets\%A_ScriptName%
	newFile := "\" containingFolder "\" A_ScriptName
	MsgBox("run")
	Run A_WorkingDir "" newFile
	ExitApp
}

if (RegExMatch(A_WorkingDir, "\\Celeste\\Mods\\" containingFolder "$")) {
	MsgBox("I am in presets")
	FileDelete(RegExReplace(A_ScriptFullPath, "\\Presets"))
	oldFile := RegExReplace(A_ScriptFullPath, "\\" containingFolder)
	if (FileExist(oldFile)) {
		MsgBox("Deleting" oldFile)
		FileDelete(oldFile)
	}
}

ExitApp
