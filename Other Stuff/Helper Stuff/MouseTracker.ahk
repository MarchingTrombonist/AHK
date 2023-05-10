#Persistent
#SingleInstance Force
SetBatchlines -1
OnExit, UnHook

; http://msdn.microsoft.com/en-us/library/windows/desktop/ms644990.aspx , WH_MOUSE_LL

hHookMouse := DllCall("SetWindowsHookEx", "int", 14, "Uint", RegisterCallback("Mouse", "Fast"), "Uint", 0, "Uint", 0)
Return

UnHook:
DllCall("UnhookWindowsHookEx", "Uint", hHookMouse)
ExitApp

Mouse(nCode, wParam, lParam)
{
	Critical
	Tooltip, % (wParam = 0x201 ? "LBUTTONDOWN"
		: wParam = 0x202 ? "LBUTTONUP"
		: wParam = 0x200 ? "MOUSEMOVE"
		: wParam = 0x20A ? "MOUSEWHEEL"
		: wParam = 0x20E ? "MOUSEWHEEL"
		: wParam = 0x204 ? "RBUTTONDOWN"
		: wParam = 0x205 ? "RBUTTONUP"
		: "?")
	. " ptX: " . NumGet(lParam+0, 0, "int")
	. " ptY: " . NumGet(lParam+0, 4, "int")
	. "`nmouseData: " . NumGet(lParam+0, 10, "short")
	. " flags: " . NumGet(lParam+0, 12, "uint")
	. " time: " . NumGet(lParam+0, 16, "uint")
	Return DllCall("CallNextHookEx", "Uint", 0, "int", nCode, "Uint", wParam, "Uint", lParam)
}

Esc::
ExitApp