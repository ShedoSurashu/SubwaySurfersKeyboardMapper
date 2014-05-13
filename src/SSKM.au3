;
;  Subway Surfers Keyboard Mapper
;    This lets you play Subway Surfers using the keyboard via WASD or the arrow keys.
;    It also lets you use SPACEBAR for the hoverboard and ESC to pause the game.
;
;     By: Shedo Surashu
;  Email: http://goo.gl/wiyf8c
;
;  Note: I have included a lot of comments on the code below so you know what each
;        of the segment does.
;

#Region
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=SubwaySurfersKeyboardMapper.exe
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Fileversion=1.0.0.81
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#EndRegion

#NoTrayIcon

;### This declares all the variables that I used.
Dim $UID = Random(1111, 9999, 1)
Dim $SSKMVer = FileGetVersion(@AutoItExe)
Dim $SSKMTitle = "Subway Surfers Keyboard Mapper - v" & $SSKMVer & "   ----------   [" & $UID & "]"
Dim $SSKMGameTitle = "Subway Surfers - Keyboard Enabled [" & $UID & "]"
Dim $AutoStart = False
Dim $MouseDist[2] = [0, 0]
Dim $MousePos[2] = [0, 0]
Dim $WinPos[4] = [0, 0, 0, 0]
Dim $IsRunning = True

;### This sets the Subway Surfers Keyboard Mapper (SSKM) window to a unique title on the offchance
;### that it conflicts with another window. (Highly unlikely but still.)
WinSetTitle(WinGetTitle("[ACTIVE]"),"",$SSKMTitle)

;### This checks for command line flags that you may have set. Only two are available and they are
;### -hidden and -autostart. They are already self-explanatory.
If ($CmdLine[0] > 0) Then
	For $Param In $CmdLine
		If ($Param = "-hidden") Then
			WinSetState($SSKMTitle, "", @SW_HIDE)
		EndIf
		If ($Param = "-autostart") Then
			$AutoStart = True
		EndIf
	Next
EndIf

;### This displays the introduction text showm on the Command Prompt window.
ConsoleWrite(@CRLF)
ConsoleWrite("  Subway Surfers Keyboard Mapper" & @CRLF)
ConsoleWrite("     version " & $SSKMVer & @CRLF)
ConsoleWrite(@CRLF)
ConsoleWrite("     By: Shedo Surashu" & @CRLF)
ConsoleWrite("  Email: http://goo.gl/wiyf8c" & @CRLF)
ConsoleWrite(@CRLF)
ConsoleWrite("  -----------------------------------------------------------" & @CRLF)
ConsoleWrite("  " & @CRLF)

;### This handles exiting of the program.
Func ExitMe()
	ConsoleWrite(@CRLF & "   --> Thanks for using Subway Surfers Keyboard Mapper!" & @CRLF)
	Sleep(1500)
	Exit(0)
EndFunc

;### This detects if the game has been closed and then exits SSKM if that's the case.
Func GameClosed()
	WinWaitClose($SSKMGameTitle)
	ConsoleWrite("   --> Game has been closed." & @CRLF)
	Sleep(750)
	ExitMe()
EndFunc

;### This checks if SSKM is in the same folder as Subway Surfers then opens it if true.
ConsoleWrite("   --> Checking if Subway_Surfers.exe exists..." & @CRLF)
If (Not FileExists("Subway_Surfers.exe")) Then
	ConsoleWrite("    '-> Error! Can't find Subway_Surfers.exe." & @CRLF)
	Sleep(750)
	ExitMe()
EndIf
ConsoleWrite("   --> Subway_Surfers.exe exists! Launching now..." & @CRLF)
Run("Subway_Surfers.exe")

;### This waits for the game's configuration window to show up and then converts the title to a
;### unique one. (Again, to avoid conflicts with the same window title.)
WinWait("[TITLE:Subway Surf Configuration; CLASS:#32770;]","")
WinSetTitle("[TITLE:Subway Surf Configuration; CLASS:#32770;]","",$SSKMGameTitle)
ConsoleWrite("   --> Subway_Surfers.exe is now open." & @CRLF)

;### This sets the game's configuration window as the top-most window shown.
WinActivate($SSKMGameTitle)

;### If you set the -autostart flag, this will automatically press the ENTER button to launch the
;### game.
If ($AutoStart) Then
	ConsoleWrite("   --> Automatically starting game..." & @CRLF)
	Send("{ENTER}")
EndIf

;### This waits for the configuration window to close while monitoring if Subway Surfers is still
;### running in the processes.
WinWaitClose($SSKMGameTitle)
If (Not ProcessExists("Subway_Surfers.exe")) Then
	ConsoleWrite("    '-> Subway_Surfers.exe has been closed." & @CRLF)
	Sleep(750)
	ExitMe()
EndIf

;### After the configuration window closes, the actual game will open up. This will detect that
;### and then convert the window's title again just like before.
WinWait("[TITLE:Subway Surf; CLASS:UnityWndClass;]")
WinSetTitle("[TITLE:Subway Surf; CLASS:UnityWndClass;]","",$SSKMGameTitle)
ConsoleWrite("   --> Game is now running." & @CRLF)

;### This sets the delay of emulating mouse clicks to make the response time faster.
AutoItSetOption("MouseClickDelay","1")

;### This registers the WASD and the arrow keys.
HotKeySet("{LEFT}","GoLeft")
HotKeySet("a","GoLeft")
HotKeySet("{RIGHT}","GoRight")
HotKeySet("d","GoRight")
HotKeySet("{UP}","GoUp")
HotKeySet("w","GoUp")
HotKeySet("{DOWN}","GoDown")
HotKeySet("s","GoDown")
ConsoleWrite("    '-> You can now use WASD or the arrow keys to play." & @CRLF)

;### This registers the SPACEBAR.
HotKeySet("{SPACE}","GoBoard")
ConsoleWrite("    '-> To use the hoverboard, press the SPACEBAR once." & @CRLF)

;### This registers the ESC key.
HotKeySet("{ESC}","GoEsc")
ConsoleWrite("    '-> Pressing ESC on while playing will pause it." & @CRLF)

;### This calculates the area where the mouse should be.
Func SetMouse()
	$WinPos = WinGetPos($SSKMGameTitle)
	$MouseDist[0] = $WinPos[2]/2
	$MouseDist[1] = $WinPos[3]/2
	$MousePos[0] = $MouseDist[0]+$WinPos[0]
	$MousePos[1] = $MouseDist[1]+$WinPos[1]
	$MouseDist[0] = $MouseDist[0]/2
	$MouseDist[1] = $MouseDist[1]/2
	MouseMove($MousePos[0], $MousePos[1], 0)
EndFunc
SetMouse()

;### This makes the mouse click and then drag to the left.
Func GoLeft()
	If (WinActive($SSKMGameTitle)) Then
		SetMouse()
		MouseDown("primary")
		MouseMove(($MousePos[0]-$MouseDist[0]),($MousePos[1]),3)
		MouseUp("primary")
	EndIf
EndFunc

;### This makes the mouse click and then drag to the right.
Func GoRight()
	If (WinActive($SSKMGameTitle)) Then
		SetMouse()
		MouseDown("primary")
		MouseMove(($MousePos[0]+$MouseDist[0]),($MousePos[1]),3)
		MouseUp("primary")
	EndIf
EndFunc

;### This makes the mouse click and then drag up.
Func GoUp()
	If (WinActive($SSKMGameTitle)) Then
		SetMouse()
		MouseDown("primary")
		MouseMove(($MousePos[0]),($MousePos[1]-$MouseDist[1]),3)
		MouseUp("primary")
	EndIf
EndFunc

;### This makes the mouse click and then drag down.
Func GoDown()
	If (WinActive($SSKMGameTitle)) Then
		SetMouse()
		MouseDown("primary")
		MouseMove(($MousePos[0]),($MousePos[1]+$MouseDist[1]),3)
		MouseUp("primary")
	EndIf
EndFunc

;### This makes the mouse click twice (for the hoverboard).
Func GoBoard()
	If (WinActive($SSKMGameTitle)) Then
		MouseClick("primary", MouseGetPos()[0], MouseGetPos()[1], 2, 100)
	EndIf
EndFunc

;### This makes the mouse click on the top-left of the window to press the Pause button.
;### When on the home screen, this ends up pressing the Missions button instead.
Func GoEsc()
	If (WinActive($SSKMGameTitle)) Then
		MouseClick("primary", ($WinPos[0]+30), ($WinPos[1]+37), 1, 0)
	EndIf
EndFunc

;### This is a loop to ensure that the key bindings don't take effect when you alt+tab away from
;### the Subway Surfers window. That way, you can still continue using your keyboard normally
;### when the game is minimized or beneath other windows.
While 1
	If (WinActive($SSKMGameTitle)) Then
		If (Not $IsRunning) Then
			HotKeySet("{LEFT}","GoLeft")
			HotKeySet("a","GoLeft")
			HotKeySet("{RIGHT}","GoRight")
			HotKeySet("d","GoRight")
			HotKeySet("{UP}","GoUp")
			HotKeySet("w","GoUp")
			HotKeySet("{DOWN}","GoDown")
			HotKeySet("s","GoDown")
			HotKeySet("{SPACE}","GoBoard")
			HotKeySet("{ESC}","GoEsc")
			$IsRunning = True
		EndIf
	Else
		If ($IsRunning) Then
			HotKeySet("{LEFT}")
			HotKeySet("a")
			HotKeySet("{RIGHT}")
			HotKeySet("d")
			HotKeySet("{UP}")
			HotKeySet("w")
			HotKeySet("{DOWN}")
			HotKeySet("s")
			HotKeySet("{SPACE}")
			HotKeySet("{ESC}")
			$IsRunning = False
		EndIf
	EndIf

	Sleep(250)

	If (Not WinExists($SSKMGameTitle)) Then
		ExitLoop
	EndIf
WEnd

;### This exits the SSKM.
GameClosed()





