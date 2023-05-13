#NoEnv  ; Recommended for performance and compatibility (future AutoHotkey releases.
; #Warn  ; Enable warnings to assist (detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

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
; [x]: Add default checks in separate file; e.g. default check prideline
; [ ]: Combine all presets into one file
Loop, Files, %presetFolder%\*.txt
{
	if (A_LoopFileName = "examplePreset.txt")
	{
		continue
	}
	ID := TV_Add(A_LoopFileName, root)
	; tracks default checking
	allChecked := False
	Loop, Read, %presetFolder%\%A_LoopFileName%
	{
		; tracks default checking
		itemChecked := False
		; comment handling
		newItem := RegExReplace(A_LoopReadLine, "\s*#.*")
		if (newItem = "")
			{
				continue
			}
		if (newItem = "**ALL**")
			{
				allChecked := True
				continue
			}
		if (RegExMatch(newItem, "^\*"))
			{
				itemChecked := True
				newItem := RegExReplace(newItem, "^\*\s*")
			}
		if (!RegExMatch(newItem, "\.zip$"))
			{
				newItem .= .zip
			}
		lineItem := TV_Add(newItem, ID, ((itemChecked | allChecked) ? "" : "-") "Check")
	}
}

; Show the window and its TreeView.
Gui, Show, AutoSize Center, %appName%
; simulates a click to trigger default checks
leftClick()
; selects root
TV_Modify(root)
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

; runs on left click
leftClick()
{
	global curState, prevState
		updateState()
		
		; if something has been checked or unchecked
		if (prevState.length() != curState.length())
		{
			; gets checked item and selects it
			changedID := % getCheckChange()
			TV_Modify(changedID)
			
			; updates other nodes
			updateChildren(changedID)
			updateParent(changedID)
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
	
	; the only item left in the larger state is the changed one
	return % largeArr[1]
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
	for index in curState
	{
		TV_GetText(fileName, curState[index])
		if (RegExMatch(fileName, ".*\.zip$"))
		{
			whitelist .= fileName ", "
		}
	}
	
	; Writes all .zips to blacklist with # if in whitelist
	Loop, Files, *.zip
	{
		FileAppend, `n, blacklist.txt
		if (inStr(whitelist, A_LoopFileName))
		{
			FileAppend,`#` ,blacklist.txt
		}
		FileAppend,%A_LoopFileName%, blacklist.txt
	}
}