#Requires AutoHotkey v2.0
#SingleInstance

MyGui := Gui()
TV := MyGui.Add("TreeView", "Checked h300 w300")

TV.OnEvent("ItemCheck", onCheck)

root := TV.Add("Root")

P1 := TV.Add("First parent", root)
P1C1 := TV.Add("Parent 1's first child", P1)
P2 := TV.Add("Second parent", root)
P2C1 := TV.Add("Parent 2's first child", P2)
P2C2 := TV.Add("Parent 2's second child", P2)
P2C2C1 := TV.Add("Child 2's first child", P2C2)

; Show the window and its TreeView.
MyGui.Show

onCheck(GuiCtrl, itemID, checked) {
    itemID := GuiCtrl.Modify(itemID, "Select")
    updateChildren(itemID)
    updateParent(itemID)
} 

updateChildren(ID) {
    childID := TV.GetChild(ID)

    Loop {
        ; recursively loops through all children
        if (childID = 0) {
            break
        }

        ; sets all children to match state of parent
        TV.Modify(childID, (TV.Get(ID, "C") ? "" : "-") "Check")
        updateChildren(childID)
        childID := TV.GetNext(ChildID)
    }
}

updateParent(ID) {
    ; set check var
	allSibChecked := true

	; get parent and first sibling
	parentID := TV.GetParent(ID)
	siblingID := TV.GetChild(parentID)

	; loop all siblings
	Loop {
		if (siblingID = 0) {
			break
		}

		; if any siblings unchecked, break
		if (TV.Get(siblingID, "C") != siblingID) {
			allSibChecked := false
			break
		}
		siblingID := TV.GetNext(siblingID)
	}

	; set parent to checked if all children checked
	parentID := TV.Modify(parentID, (allSibChecked ? "" : "-") "Check")

	; call on parent, stops when no parent
	if (parentID != 0) {
		updateParent(parentID)
	}
}