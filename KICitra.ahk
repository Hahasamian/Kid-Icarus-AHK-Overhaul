#SingleInstance force
#MaxThreadsPerHotkey 2

;---KID ICARUS UPRISING: AHK OVERHAUL---
;            A little project by Hahasamian
;repo: https://github.com/Hahasamian/Kid-Icarus-AHK-Overhaul/
;
;Hello world! This is an AutoHotKey script to make Kid Icarus Uprising work well with a mouse and keyboard!
;It's designed around using a certain controller config, obviously,
; so make sure to check out the other items that should have come with this script!
;Obviously, you'll need AutoHotKey to run this, and Citra to play the game. 
;It's based on a script by Kelkador on Github, but at this point I've transformed it so much that it's its own,
; far less janky, thing. Still, it can only go so far, so make sure to maximize your in-game sensitivity for the best experience!
;If something feels off, check out the Cusomization Settings section!

;-MODE EXPLANATIONS-
;MENU MODE
;By default, you're in Menu Mode (which can be activated with the 1 key). It allows you to easily operate menus.

;AIR MODE
;Press 2 when you get into an air battle! This mode locks Left Click down so the cursor follows the mouse,
;  and remaps your clicks to shots! 
;Waggle the mouse past each of the touchscreen's edges for best results. I do this when I play on 3DS, honestly

;LAND MODE
;First, if you haven't, press 4 to set Land Mode's center! This is important but you should only have to do it once per session.
;Then, press 3 to enter Land Mode! This takes your mouse movements and translates them to something
;  this globe-spinning game can understand. Once again, you can click to fire. Right-click twice to enter scope mode!
;Hold down Shift to decrease your analog sensitivity, so you can walk instead of run!
;Holding down right-click also disables the normal wrapping stuff, so use it if you're taking aim 
;  and need to make sure NOTHING interrupts you!
;Oh yeah, wrapping! You should probably learn about it. When the mouse gets a certain distance from the center,
;  it un-clicks for a moment and wraps back to it. That's how we can get continuous mouse movement!
;  If your window is less than 1920 pixels long and/or doesn't have the touchscreen at full size (shame on you),
;  the wrapping boundaries may become an issue, so make sure to adjust them accordingly!

;GENERALL INPUT
;WASD is the Circle Pad! Shift will slow its movement. Control is the R button, which recenters the camera!
;You can use the scroll wheel and click it to select and use items. You can also press Z-X-C, or E!
;ABXY are mapped to FRGT. You won't need to be using them much though
;Q is D-pad up! You can access first-person view and scope mode with this!
;Space is the L-button, but you usually won't need it if you're in modes 2 or 3.


;--CUSTOMIZATION SETTINGS--
;Check out these variables if something's behaving wrong!

XWrapBound = 100 ;Distance the mouse can travel horizontally from the center before it goes back to the center

YWrapBound = 100 ;So it's like the above one, but vertical!!

WrapDistanceMultiplier = 0 ;By default we wrap to the center position, to avoid constant fence-hopping. Set this between 0 and 1 to push it out more towards the opposite edge! 

WrapDelay = 2 ;This option... could be very important? The OG script that got me into all this waited a muuch longer time.
; If for some reason things are acting really janky, and it's not an issue with the settings above, you may want to try adjusting this variable, but probably not to something obnoxious like 40


;--MAIN SCRIPT--
;If you're trying to change some input things, definitely check out the bottom of this!

mode = menu

#Persistent
CoordMode, Mouse, Window
SetTimer, WatchCursor, 5 ; "Necessary and I don't know why"
return

WatchCursor:
MouseGetPos, XCur, YCur ; "Tracks mouse at all times"
return

4:: ;The center position for Land Mode is chosen here!
CoordMode, Mouse, Window
MouseGetPos, XCen, YCen ; This will be where your mouse snaps back to
toggle := !toggle
Return

5:: ; Restarts Script
Reload
Return

1:: ;Menu mode
mode = menu
Send {LButton Up}
Return

2:: ;Air Mode
mode = air
While (mode="air") 
{	
	if GetKeyState("LButton", "P") = 0
		{
		Send {LButton Down} ; Ensures touch screen is always tapped
		}
}
Return

3:: ;Land Mode
mode = land
While (mode="land")
{	
	DllCall("SystemParametersInfo", Int,[color=red]113[/color], Int,0, UInt,[color=red]5[/color], Int,2) ;Slows mouse movement (idk if this actually works lol
	;MouseMove xCen, yCen, 0
	if GetKeyState("LButton", "P") = 0
		{
		Send {LButton Down} ; Ensures touch screen is always tapped
		}
	Sleep 1
	;Send {LButton Down)
	if ((XCur - XCen > XWrapBound) or ((XCur - XCen < -XWrapBound)))
	{
		Send {LButton}
		extraWrap := XWrapBound * WrapDistanceMultiplier
		if (XCur > XCen) 
		{ 
			extraWrap := -extraWrap 
		}
		MouseMove (XCen + extraWrap), YCur, 0
		Sleep WrapDelay
		Send {LButton Down}

	}
	if ((YCur - YCen > YWrapBound) or ((YCur - YCen < -YWrapBound)))
	{
		Send {LButton}
		extraWrap := YWrapBound * WrapDistanceMultiplier
		if (YCur - YCen > YWrapBound) 
		{ 
			extraWrap := -extraWrap
		}
		MouseMove xCur, (YCen + extraWrap), 0
		Sleep WrapDelay
		Send {LButton Down}

	}
	if GetKeyState("RButton", "P")
	{
		Send {LButton}
		MouseMove xCen, YCur, 0
		Sleep WrapDelay
		Send {LButton Down}
		While GetKeyState("RButton", "P")
		{
			Send {LButton Down}
		}
		Send {LButton}
		MouseMove xCur, YCen, 0
		Sleep WrapDelay
		Send {LButton Down}
	}
	;Send {LButton}
	MouseGetPos, xPast, yPast
}
Return


;--BUTTON REMAPS--


;Left Click is remapped to space unless you're in Menu Mode.

LButton::
if(mode!="menu")
{
Send {Space Down}
}
else
{
Send {LButton Down}
}
Return

LButton Up::
if(mode!="menu")
{
Send {Space Up}
}
else
{
Send {LButton Up}
}
Return


;Scroll/Middle Click are remapped to Z, X, and C

MButton::
Send {x Down}
Sleep 3
Send {x Up}
Return

WheelUp::
Send {z Down}
Sleep 1
Send {z Up}
Return

WheelDown::
Send {c Down}
Sleep 1
Send {c Up}
Return


;Shift is remapped to E, because using Shift as Circle Mod didn't actually work right. 
;AHK was probably messing it up in some way

LShift::
Send {E Down}
Return

LShift Up::
Send {E Up}
Return

;E is remapped to X for a handy use-item button, because E being the "also Circle Mod" button would suck

E::
Send {X Down}
Return

E Up::
Send {X Up}
Return


;Enter is just Enter but it also blanks the mouse for a split second. Handy if you need to unpause and don't wanna change modes

Enter:: ;Releases the mouse for a moment when enter is pressed, so you can unpause without mode-changing
Send {LButton Up}
Send {Enter Down}
Return

Enter Up::
Send {Enter Up}
Return


;Escape key ends the script.

Esc:: ExitApp