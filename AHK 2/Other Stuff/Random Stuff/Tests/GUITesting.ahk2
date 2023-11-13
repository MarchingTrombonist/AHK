#Requires AutoHotkey v2.0
#SingleInstance

MyGui := Gui()
TV := MyGui.Add("TreeView", "Checked")

; TV.OnNotify(18446744073709551197, test) ; TVN_ITEMCHANGED notification code (magnumdb.com)
TV.OnNotify(-2, test) ; NM_CLICK notification code (magnumdb.com)

P1 := TV.Add("First parent")
P1C1 := TV.Add("Parent 1's first child", P1)  ; Specify P1 to be this item's parent.
P2 := TV.Add("Second parent")
P2C1 := TV.Add("Parent 2's first child", P2)
P2C2 := TV.Add("Parent 2's second child", P2)
P2C2C1 := TV.Add("Child 2's first child", P2C2)

MyGui.Show  ; Show the window and its TreeView.

test(GuiCtrl, lParam) {
    hwndFrom := NumGet(lParam, "UINT64")
    idFrom := NumGet(lParam, 8, "UINT64")
    code := NumGet(lParam, 16, "UINT")
    uChanged := NumGet(lParam, 20, "UINT")
    itemID := NumGet(lParam, 32, "UINT64") ; 64-bit system
    ; itemID := NumGet(lParam, 24, "UINT") ; 32-bit system
    uStateNew := NumGet(lParam, 40, "UINT")
    uStateOld := NumGet(lParam, 44, "UINT")
    text := TV.GetText(itemID)
    if (Abs(uStateNew - uStateOld) = 4096) { ; checks if change was checked vs unchecked
        ; checked:  0x2XXX yes, 0x1XXX no
        ; expanded: 0xXX6X yes, 0xXX4X no
        ; selected: 0xXXX2 yes, 0xXXX0 no
        ; MsgBox(text)
        updateChildren(itemID)
    }
    ; MsgBox("Curr" uStateNew)
    ; MsgBox("Prev" uStateOld)

    ; FileAppend "hwndFrom"
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