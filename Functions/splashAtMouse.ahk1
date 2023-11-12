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