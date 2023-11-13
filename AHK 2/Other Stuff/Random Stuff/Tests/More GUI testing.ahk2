#Requires AutoHotkey v2.0
#SingleInstance

clicked := False

MyGui := Gui()
TV := MyGui.Add("TreeView", "Checked h300 w300")

TV.OnNotify(18446744073709551197, test) ; TVN_ITEMCHANGED notification code (magnumdb.com)
TV.OnEvent("Click", onClick)

P1 := TV.Add("First parent")
P1C1 := TV.Add("Parent 1's first child", P1)  ; Specify P1 to be this item's parent.
P2 := TV.Add("Second parent")
P2C1 := TV.Add("Parent 2's first child", P2)
P2C2 := TV.Add("Parent 2's second child", P2)
P2C2C1 := TV.Add("Child 2's first child", P2C2)

MyGui.Show  ; Show the window and its TreeView.


onClick(GuiCtrl, itemID) {
    ; itemID := GuiCtrl.Modify(itemID, "Select")
    global clicked := True
}

test(GuiCtrl, lParam) {
    itemID := NumGet(lParam, 32, "UINT64") ; 64-bit system
    ; itemID := NumGet(lParam, 24, "UINT") ; 32-bit system
    uStateNew := NumGet(lParam, 40, "UINT")
    uStateOld := NumGet(lParam, 44, "UINT")
    ; if (Abs(uStateNew - uStateOld) = 4096) { ; checks if change was checked or unchecked
        ; text := GuiCtrl.GetText(itemID)
        ; MsgBox(text)
        ; MsgBox("Curr: " uStateNew)
        ; MsgBox("Prev: " uStateOld)
        if (clicked) {
            global clicked := False
            itemID := GuiCtrl.Modify(itemID, "Select")
            updateChildren(itemID)
            updateParent(itemID)
        }
    ; }
} 

updateChildren(ID) {
    childID := TV.GetChild(ID)

    Loop {
        if (childID = 0) {
            break
        }

        TV.Modify(childID, (TV.Get(ID, "C") ? "" : "-") "Check")
        updateChildren(childID)
        childID := TV.GetNext(ChildID)
    }
}

updateParent(ID) {
    ;set check var
	allSibChecked := true

	;get parent and first sibling
	parentID := TV.GetParent(ID)
	siblingID := TV.GetChild(parentID)

	;loop all siblings
	Loop {
		if (siblingID = 0) {
			break
		}

		;if any siblings unchecked, break
		if (TV.Get(siblingID, "C") != siblingID) {
			allSibChecked := false
			break
		}
		siblingID := TV.GetNext(siblingID)
	}

	;set parent to checked if all children checked
	parentID := TV.Modify(parentID, (allSibChecked ? "" : "-") "Check")

	;call on parent, stops when no parent
	if (parentID != 0) {
		updateParent(parentID)
	}
}