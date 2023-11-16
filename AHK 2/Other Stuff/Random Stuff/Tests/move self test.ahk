#Requires AutoHotkey v2
#SingleInstance

containingFolder := "Presets"

if (RegExMatch(A_WorkingDir, "Tests$")) {
	MsgBox("I am in mods")
	MsgBox(A_ScriptName)
	DirCreate containingFolder
	FileCopy A_ScriptName, containingFolder, 1
	newFile := "\" containingFolder "\" A_ScriptName
	Run A_WorkingDir "" newFile
	ExitApp
}

if (RegExMatch(A_WorkingDir, "Tests\\" containingFolder "$")) {
	MsgBox("I am in presets")
	oldFile := RegExReplace(A_ScriptFullPath, "\\" containingFolder)
	if (FileExist(oldFile)) {
		MsgBox("Deleting" oldFile)
		FileDelete oldFile
	}
}