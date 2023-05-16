#NoEnv ; Recommended for performance and compatibility (future AutoHotkey releases.
; #Warn  ; Enable warnings to assist (detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

; gives the program a name
appName := "Everest Presets"

; check if in right directory
if !(RegExMatch(A_WorkingDir, "\\Celeste\\Mods$"))
{
	MsgBox,, %appName%, Move me to \Celeste\Mods and try again!
	ExitApp
}

; Creates preset folder
presetFolder := "Presets"
if !FileExist(presetFolder)
{
	FileCreateDir, %presetFolder%
	FileAppend,
	(LTrim,On
		`# This is a preset file. Add names of mods below to add them to the preset.
		`# If the line doesn't end with .zip, it will be appended
		`# '`#' acts as a comment: lines starting with it are ignored, along with any text preceded by it
		`# Lines starting with * are selected by default.
		`# **ALL** as the first line will select the entire preset by default.

		`# If '`#' removed, would check all by default
		`# **ALL**
		exampleMod1 `# Unchecked by default and will be listed as exampleMod1.zip
		`# Will not be listed
		`# exampleMod2.zip
		`# Will be checked by default
		* exampleMod3.zip
	), %presetFolder%\examplePreset.txt

	MsgBox,, %appName%, Celeste\Mods\%presetFolder% created! Add some presets and run me again.
	ExitApp
}

; state storage
prevState := []
curState := []

; Creates GUI
Gui, New

Gui, Add, TreeView, Checked AltSubmit gtvClicked h300 w300
Gui, Add, Button, default gbuttonScript, &Update mod list
root := TV_Add("All Presets")

; Adds nodes
Loop, Files, %presetFolder%\*.txt
{
	newPreset := RegExReplace(A_LoopFileName, "\.txt")
	if (newPreset = "examplePreset")
	{
		continue
	}
	curPreset := TV_Add(newPreset, root)
	; tracks default checking
	allChecked := False
	Loop, Read, %presetFolder%\%A_LoopFileName%
	{
		; tracks default checking
		itemChecked := False
		; comment handling
		newItem := RegExReplace(A_LoopReadLine, "(\s*#.*)|(\.zip)")
		if (newItem = "")
		{
			continue
		}
		if (RegExMatch(newItem, "\*\*\s*ALL\s*\*\*"))
		{
			allChecked := True
			TV_Modify(curPreset, "Check")
			continue
		}
		if (RegExMatch(newItem, "^\*"))
		{
			itemChecked := True
			newItem := RegExReplace(newItem, "^\*\s*")
		}
		lineItem := TV_Add(newItem, curPreset, ((itemChecked | allChecked) ? "" : "-") "Check")
	}
}

; Show the window and its TreeView.
Gui, Show, AutoSize Center, %appName%
; updates default checks
defaultCheck()
; selects root
TV_Modify(root)
updateState()
return

; Run on close
GuiClose:
ExitApp

; Exit Script (Win + Esc)
#Esc::
ExitApp
return

; runs on treeView clicked
tvClicked:
	; left click
	if (A_GuiEvent = "Normal")
	{
		global curState, prevState
		leftClick()
	}
return

; Runs default checks
defaultCheck()
{
	global root
	; simulates click to update checks
	leftClick()

	; starts at first child of root
	ID := root
	ID := TV_GetChild(root)

	; loops through all presets and collapses
	Loop
	{
		if (ID = 0)
		{
			break
		}
		TV_Modify(ID, "-Expand")
		ID := TV_GetNext(ID)
	}
	return
}

; runs on left click
leftClick()
{
	global curState, prevState
	updateState()

	; if something has been checked or unchecked
	if (prevState.length() != curState.length())
	{
		changedArr := % getCheckChange()
		for key,ID in changedArr
		{
			; gets checked item and selects it
			TV_Modify(ID)

			; updates other nodes
			updateChildren(ID)
			updateParent(ID)
		}
	}
	updateState()
	return
}

; runs when button clicked
buttonScript:
	createBlacklist()
	MsgBox,, %appName%, Everest mod list updated!`nEverest will update dependencies on launch.
	Gui, Destroy
ExitApp
return

; figures out which item was checked
getCheckChange()
{
	global prevState, curState

	; assumes boxes are checked more than unchecked
	if (prevState.length() > curState.length())
	{
		smallArr := curState
		largeArr := prevState
	}
	else
	{
		smallArr := prevState
		largeArr := curState
	}

	; loops through smaller state and removes each item from the larger state
	for indexSmall in smallArr
	{
		for indexLarge in largeArr
		{
			if (largeArr[indexLarge] = smallArr[indexSmall])
			{
				largeArr.RemoveAt(indexLarge)
				break
			}
		}
	}

	; any items left in the larger state are changed
	return % largeArr
}

updateState()
{
	; changes states
	global prevState := % curState
	global curState := []
	global root

	; starts at root
	ID := root

	; adds root if checked
	if (ID = TV_Get(ID, "C"))
	{
		curState.Push(ID)
	}

	; loops through all others and adds all checked items to current state
	Loop
	{
		ID := TV_GetNext(ID, "Checked")
		if (ID = 0)
		{
			break
		}
		curState.Push(ID)
	}
}

updateChildren(ID)
{
	childID := TV_GetChild(ID)

	; recursively loops through all children
	Loop
	{
		if (childID = 0)
		{
			break
		}

		; sets all children to match state of parent
		TV_Modify(childID, (TV_Get(ID, "C") ? "" : "-") "Check")
		updateChildren(childID)
		childID := TV_GetNext(ChildID)
	}
}

updateParent(ID)
{
	; set check var
	allSibChecked := true

	; get parent and first sibling
	parentID := TV_GetParent(ID)
	siblingID := TV_GetChild(parentID)

	; loop all siblings
	Loop
	{
		if (siblingID = 0)
		{
			break
		}

		; if any siblings unchecked, break
		if (TV_Get(siblingID, "C") != siblingID)
		{
			allSibChecked := false
			break
		}
		siblingID := TV_GetNext(siblingID)
	}

	; set parent to checked if all children checked
	TV_Modify(parentID, (allSibChecked ? "" : "-") "Check")

	; call on parent, stops when no parent
	if (parentID != 0)
	{
		updateParent(parentID)
	}
}

createBlacklist()
{
	global curState

	; removes old blacklist and starts new with header
	FileDelete, blacklist.txt
	FileAppend,
	(LTrim,On
		`# This is the blacklist. Lines starting with `# are ignored.
		`# File generated through the "Manage Installed Mods" screen in Olympus

		Presets
	), blacklist.txt

	; Adds checked .zips to whitelist
	whitelist :=
	for index,ID in curState
	{
		TV_GetText(fileName, ID)
		if (TV_GetChild(ID) == 0)
		{
			whitelist .= fileName ".zip, "
		}
	}

	; Writes all .zips to blacklist with # if in whitelist
	Loop, Files, *.zip
	{
		curFile := A_LoopFileName
		FileAppend, `n, blacklist.txt
		if (inStr(whitelist, curFile))
		{
			FileAppend,`#` ,blacklist.txt
		}
		FileAppend,%A_LoopFileName%, blacklist.txt
	}
}