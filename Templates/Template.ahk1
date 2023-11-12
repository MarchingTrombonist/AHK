#NoEnv  ; Recommended for performance and compatibility (future AutoHotkey releases.
; #Warn  ; Enable warnings to assist (detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

splashAtMouse("AHK Script " """" A_ScriptName """" " Started",, 400)



; HOTKEYS

; CONTROL

^!e:: 						; Edit script (Ctrl+Alt+E)
editMe()
return

#Esc::						; Exit all AHK scripts (Win+Esc)
control("exit")
return	

^!p::						; Pause script (Ctrl+Alt+P)
Pause,, 1
control("pause")
return

^!r::						; Reload script (Ctrl+Alt+R)
control("reload")
return

^!s::						; Suspend script (Ctrl+Alt+S)
Suspend
control("suspend")
return

^!h:: 						; Open help (Ctrl+Alt+H)
control("help")
return


; FUNCTIONS	

control(state) {
	if (state == "exit") {
		splashAtMouse("Exiting all AHK Scripts")
		ExitApp
		return
	}
	
	if (state == "pause") {
		if (A_IsPaused) {
			splashAtMouse("AHK Script paused")
		}
		else {
			splashAtMouse("AHK Script unpaused")
		}
		return
	}
	
	if (state == "reload") {
		splashAtMouse("AHK Script reloading")
		Reload
		return
	}
	
	if (state == "suspend") {
		if (A_IsSuspended) {
			splashAtMouse("AHK Script suspended")
		}
		else {
			splashAtMouse("AHK Script unsuspended")
		}
		return
	}
	
	if (state == "help") {
		Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
		return
	}
	
	splashAtMouse("error")
	return
}

splashAtMouse(title, sleepDelay := 1000, width := 200, height := 0, text := "") {
	CoordMode, Mouse
	SplashTextOn, %width%, %height%, %title%, %text%
	MouseGetPos, xpos, ypos
	xpos += 10
	ypos += 10
	if (xpos > A_ScreenWidth - 400) {
		xpos -= 220
	}
	if (ypos > A_ScreenHeight - 80) {
		ypos -= 40
	}
	WinMove, %title%, %text%, %xpos%, %ypos%
	if (sleepDelay != -1) {
		Sleep sleepDelay
		SplashTextOff
	}
	
	return
}

editMe(editor := "AHK Studio", file := "default") {
	if (file == "default") {
		file := """" A_ScriptFullPath """"
	}
	
	if (editor == "AHK Studio") {
		Run, "D:\Applications\AHK-Studio-master\AHK-Studio.ahk" %file%
		return
	}
	
	if (editor == "Notepad++") {
		Run, notepad++.exe %file%
		return
	}
	
	splashAtMouse("error")
	return
}

; LABELS

