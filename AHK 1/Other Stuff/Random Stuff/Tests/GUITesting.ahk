#Requires AutoHotkey v1
#NoEnv  ; Recommended for performance and compatibility (future AutoHotkey releases.
; #Warn  ; Enable warnings to assist (detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

prevState := []
curState := []

Gui, New

Gui, Add, TreeView, Checked AltSubmit gtvClicked h300 w300
Gui, Add, Button, default gupdateBlacklist, &Update mod list
root := TV_Add("All Presets")

Loop, Files, *.txt
{
	ID := TV_Add(A_LoopFileName, root)
	Loop, Read, %A_LoopFileName%
	{
		lineItem := TV_Add(A_LoopReadLine, ID)
	}
}
Gui, Show, AutoSize Center ; Show the window and its TreeView.
return

GuiClose:  ; Exit the script when the user closes the TreeView's GUI window.
ExitApp

#Esc::						; Exit all AHK scripts (Win+Esc)
ExitApp
return

tvClicked:
if (A_GuiEvent = "Normal")
{
	global curState, prevState
	updateState()
	;MsgBox % curState.length()
	;MsgBox % prevState.length()
	
	if (prevState.length() != curState.length())
	{
		changedID := % getCheckChange()
		updateChildren(changedID)
		updateParent(changedID)
		TV_Modify(changedID)
	}
	updateState()
}
if (A_GuiEvent = "RightClick")
{
	MsgBox,,, %A_EventInfo%
}
return

updateBlacklist:
MsgBox,,, Everest mod list updated!`nEverest will update dependencies on launch.
Gui, Destroy
return

getCheckChange()
{
	;MsgBox,,, Running getCheckChange()
	global prevState, curState
	;testStatement := "checked"
	smallArr := prevState
	largeArr := curState
	if (prevState.length() > curState.length())
	{
		smallArr := curState
		largeArr := prevState
		;testStatement := "unchecked"
	}
	;MsgBox % testStatement
	for indexSmall in smallArr
	{
		;MsgBox % indexSmall
		for indexLarge in largeArr
		{
			if (largeArr[indexLarge] = smallArr[indexSmall])
			{
				largeArr.RemoveAt(indexLarge)
				break
			}
		}
	}
	;TV_GetText(name, largeArr[1])
	;MsgBox % name
	return % largeArr[1]
}

treeAdd() {
	
}

treeRecurse(ID)
{
	childID := TV_GetChild(ID)
	
	Loop
	{
		if (childID = 0)
		{
			break
		}
		treeRecurse(childID)
		childID := TV_GetNext(ChildID)
	}
}

updateState()
{
	global prevState := % curState
	global curState := []
	global root
	ID := root
	if (ID = TV_Get(ID, "C"))
	{
		curState.Push(ID)
	}
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

storeTree(ID)
{
	global curState
	if (ID = TV_Get(ID, "C"))
	{
		curState.Push(ID)
	}
	
	childID := TV_GetChild(ID)
	
	Loop
	{
		if (childID = 0)
		{
			break
		}
		storeTree(childID)
		childID := TV_GetNext(childID)
	}
}

updateChildren(ID)
{
	childID := TV_GetChild(ID)
	
	Loop
	{
		if (childID = 0)
		{
			break
		}
		if (TV_Get(ID, "C"))
		{
			TV_Modify(childID, "Check")
		} else
		{
			TV_Modify(childID, "-Check")
		}
		updateChildren(childID)
		childID := TV_GetNext(ChildID)
	}
}

updateParent(ID)
{
	;set check var
	allSibChecked := true
	;goto parent
	parentID := TV_GetParent(ID)
	;goto first sibling
	siblingID := TV_GetChild(parentID)
	;loop all siblings
	Loop
	{
		if (siblingID = 0)
		{
			break
		}
		;check if checked
		if (TV_Get(siblingID, "C") != siblingID)
		{
			allSibChecked := false
			break
		}
		siblingID := TV_GetNext(siblingID)
	}
	;set parent to checked if all children checked
	TV_Modify(parentID, (allSibChecked ? "" : "-") "Check")
	
	;call on parent
	if (parentID != 0)
	{
		updateParent(parentID)
	}
}
