#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

modDir := StrReplace(A_ScriptDir, "\Presets", "")
SetWorkingDir %modDir%

FileRead, prideSpeed, Presets\prideSpeed.txt
FileRead, maps, Presets\maps.txt
FileRead, packs, Presets\packs.txt
FileRead, multiplayer, Presets\multiplayer.txt
includeList = 
;whitelistArr := StrReplace(whitelist, "`r`n", ",")
MsgBox, 4,, Include Pride and Speed Mods?
IfMsgBox, Yes 
	includeList .= prideSpeed
MsgBox, 4,, Include individual maps?
IfMsgBox, Yes
	includeList .= maps
MsgBox, 4,, Include all large packs?
IfMsgBox, Yes
	includeList .= packs
MsgBox, 4,, Include multiplayer?
IfMsgBox, Yes 
	includeList .= multiplayer
MsgBox Kept mods are:`n%includeList%`n`nRemember to add dependencies! :)
FileDelete, blacklist.txt
FileAppend,
(
`# This is the blacklist. Lines starting with `# are ignored.
`# File generated through the "Manage Installed Mods" screen in Olympus


), blacklist.txt

Loop, Files, *.zip
{
	if (InStr(includeList, A_LoopFileName)) {
		FileAppend,`#` ,blacklist.txt
	}
	FileAppend,%A_LoopFileName%`n, blacklist.txt
}

MsgBox,,,Done