#Requires AutoHotkey v1
#NoEnv ; Recommended for performance and compatibility (future AutoHotkey releases.
; #Warn  ; Enable warnings to assist (detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

;state storage
prevState := []
curState := []

;Creates GUI
Gui, New

Gui, Add, TreeView, Checked AltSubmit gtvClicked h300 w300
Gui, Add, Button, default gbuttonScript, &Close
root := TV_Add("Root")

;ADD YOUR NODES HERE
P1 := TV_Add("First parent", root)
P1C1 := TV_Add("Parent 1's first child", P1)
P2 := TV_Add("Second parent", root)
P2C1 := TV_Add("Parent 2's first child", P2)
P2C2 := TV_Add("Parent 2's second child", P2)
P2C2C1 := TV_Add("Child 2's first child", P2C2)

;Show the window and its TreeView.
Gui, Show, AutoSize Center
return

;Run on close
GuiClose:
ExitApp

;Exit Script (Win + Esc)
#Esc::
ExitApp
return

;runs on treeView clicked
tvClicked:
	;left click
	if (A_GuiEvent = "Normal")
	{
		global curState, prevState
		updateState()

		;if something has been checked or unchecked
		if (prevState.length() != curState.length())
		{
			;gets checked item and selects it
			changedID := % getCheckChange()
			TV_Modify(changedID)

			;updates other nodes
			updateChildren(changedID)
			updateParent(changedID)
		}
		updateState()
	}
return

;runs when button clicked
buttonScript:
	MsgBox,,, You clicked the button!
	Gui, Destroy
return

;figures out which item was checked
getCheckChange()
{
	global prevState, curState

	;assumes boxes are checked more than unchecked
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

	;loops through smaller state and removes each item from the larger state
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

	;the only item left in the larger state is the changed one
	return % largeArr[1]
}

updateState()
{
	;changes states
	global prevState := % curState
	global curState := []
	global root

	;starts at root
	ID := root

	;adds root if checked
	if (ID = TV_Get(ID, "C"))
	{
		curState.Push(ID)
	}

	;loops through all others and adds all checked items to current state
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

	;recursively loops through all children
	Loop
	{
		if (childID = 0)
		{
			break
		}

		;sets all children to match state of parent
		TV_Modify(childID, (TV_Get(ID, "C") ? "" : "-") "Check")
		updateChildren(childID)
		childID := TV_GetNext(ChildID)
	}
}

updateParent(ID)
{
	;set check var
	allSibChecked := true

	;get parent and first sibling
	parentID := TV_GetParent(ID)
	siblingID := TV_GetChild(parentID)

	;loop all siblings
	Loop
	{
		if (siblingID = 0)
		{
			break
		}

		;if any siblings unchecked, break
		if (TV_Get(siblingID, "C") != siblingID)
		{
			allSibChecked := false
			break
		}
		siblingID := TV_GetNext(siblingID)
	}

	;set parent to checked if all children checked
	TV_Modify(parentID, (allSibChecked ? "" : "-") "Check")

	;call on parent, stops when no parent
	if (parentID != 0)
	{
		updateParent(parentID)
	}
}
