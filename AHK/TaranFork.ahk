; global savedCLASS = "ahk_class Notepad++"
; global savedEXE = "notepad++.exe" ;BEFORE the #include is apparently the only place these can go.


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#WinActivateForce

; global savedCLASS = "ahk_class Notepad++"
; global savedEXE = "notepad++.exe"

; -------------------------------------------------------------------------
; If this is your first time using AutoHotkey, you must take this tutorial:
; https://autohotkey.com/docs/Tutorial.htm
; -------------------------------------------------------------------------


Menu, Tray, Icon, shell32.dll, 16 ;this changes the icon into a little laptop thingy. just useful for making it distinct from the others.


#IfWinActive


windowSaver()
{
WinGet, lolexe, ProcessName, A
WinGetClass, lolclass, A ; "A" refers to the currently active window
global savedCLASS = "ahk_class "lolclass
global savedEXE = lolexe ;is this the way to do it? IDK.
;msgbox, %savedCLASS%
;msgbox, %savedEXE%
}

;SHIFT + macro key G14


global savedCLASS = "ahk_class Notepad++"
global savedEXE = "notepad++.exe"

switchToSavedApp(savedCLASS)
{
;msgbox,,, savedCLASS is %savedCLASS%,0.5
;msgbox,,, savedexe is %savedEXE%,0.5
if savedCLASS = ahk_class Notepad++
	{
	;msgbox,,, is notepad++,0.5
	if WinActive("ahk_class Notepad++")
		{
		sleep 5
		Send ^{tab}
		}
	}
;msgbox,,,got to here,0.5
windowSwitcher(savedCLASS, savedEXE)
}





back(){
;; if WinActive("ahk_class MozillaWindowClass")
;tooltip, baaaack
if WinActive("ahk_exe firefox.exe")
	Send ^+{tab}
if WinActive("ahk_class Chrome_WidgetWin_1")
	Send ^+{tab}
if WinActive("ahk_class Notepad++")
	Send ^+{tab}
if WinActive("ahk_exe Adobe Premiere Pro.exe")
	Send ^!+b ;ctrl alt shift B  is my shortcut in premiere for "go back"(in bins)(the project panel)
if WinActive("ahk_exe explorer.exe")
	Send !{left} ;alt left is the explorer shortcut to go "back" or "down" one folder level.
if WinActive("ahk_class OpusApp")
	sendinput, {F2} ;"go to previous comment" in Word.
}

;macro key 16 on my logitech G15 keyboard. It will activate firefox,, and if firefox is already activated, it will go to the next window in firefox.

switchToFirefox(){
sendinput, {SC0E8} ;scan code of an unassigned key. Do I NEED this?
IfWinNotExist, ahk_class MozillaWindowClass
	Run, firefox.exe
if WinActive("ahk_exe firefox.exe")
	{
	WinGetClass, class, A
	if (class = "Mozillawindowclass1")
		msgbox, this is a notification
	}
if WinActive("ahk_exe firefox.exe")
	Send ^{tab}
else
	{
	;WinRestore ahk_exe firefox.exe
	WinActivatebottom ahk_exe firefox.exe
	;sometimes winactivate is not enough. the window is brought to the foreground, but not put into FOCUS.
	;the below code should fix that.
	WinGet, hWnd, ID, ahk_class MozillaWindowClass
	DllCall("SetForegroundWindow", UInt, hWnd) 
	}
}


#IfWinActive
;Press SHIFT and macro key 16, and it'll switch between different WINDOWS of firefox.

switchToOtherFirefoxWindow(){
;sendinput, {SC0E8} ;scan code of an unassigned key
Process, Exist, firefox.exe
;msgbox errorLevel `n%errorLevel%
	If errorLevel = 0
		Run, firefox.exe
	else
	{
	GroupAdd, taranfirefoxes, ahk_class MozillaWindowClass
	if WinActive("ahk_class MozillaWindowClass")
		GroupActivate, taranfirefoxes, r
	else
		WinActivate ahk_class MozillaWindowClass
	}
}



; This is a script that will always go to The last explorer window you had open.
; If explorer is already active, it will go to the NEXT last Explorer window you had open.
; CTRL Numpad2 is pressed with a single button stoke from my logitech G15 keyboard -- Macro key 17. 

switchToExplorer(){
IfWinNotExist, ahk_class CabinetWClass
	Run, explorer.exe
GroupAdd, taranexplorers, ahk_class CabinetWClass
if WinActive("ahk_exe explorer.exe")
	GroupActivate, taranexplorers, r
else
	WinActivate ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
}

; ;trying to activate these windows in reverse order from the above. it does not work.
; ^+F2::
; IfWinNotExist, ahk_class CabinetWClass
	; Run, explorer.exe
; GroupAdd, taranexplorers, ahk_class CabinetWClass
; if WinActive("ahk_exe explorer.exe")
	; GroupActivate, taranexplorers ;but NOT most recent.
; else
	; WinActivatebottom ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
; Return

;closes all explorer windows :/
;^!F2 -- for searchability

closeAllExplorers()
{
WinClose,ahk_group taranexplorers
}


switchToPremiere(){
IfWinNotExist, ahk_class Premiere Pro
	{
	;Run, Adobe Premiere Pro.exe
	;Adobe Premiere Pro CC 2017
	; Run, C:\Program Files\Adobe\Adobe Premiere Pro CC 2017\Adobe Premiere Pro.exe ;if you have more than one version instlaled, you'll have to specify exactly which one you want to open.
	Run, Adobe Premiere Pro.exe
	}
if WinActive("ahk_class Premiere Pro")
	{
	IfWinNotExist, ahk_exe notepad++.exe
		{
		Run, notepad++.exe
		sleep 200
		}
	WinActivate ahk_exe notepad++.exe ;so I have this here as a workaround to a bug. Sometimes Premeire becomes unresponsive to keyboard input. (especially after timeline scrolling, especially with a playing video.) Switching to any other application and back will solve this problem. So I just hit the premiere button again, in those cases.g
	sleep 10
	WinActivate ahk_class Premiere Pro
	}
else
	WinActivate ahk_class Premiere Pro
}


switchToWord()
{
Process, Exist, WINWORD.EXE
;msgbox errorLevel `n%errorLevel%
	If errorLevel = 0
		Run, WINWORD.EXE
	else
	{
	IfWinExist, Microsoft Office Word, OK ;checks to see if the annoying "do you want to continue searching from the beginning of the document" dialouge box is present.
		sendinput, {escape}
	else if WinActive("ahk_class OpusApp")
		sendinput, {F3} ;set to "go to next comment" in Word.
	else
		WinActivate ahk_class OpusApp
	}
}


switchWordWindow()
{
; Process, Exist, WINWORD.EXE
; ;msgbox errorLevel `n%errorLevel%
	; If errorLevel = 0
		; Run, WINWORD.EXE
	; else
	; {
	GroupAdd, taranwords, ahk_class OpusApp
	if WinActive("ahk_class OpusApp")
		GroupActivate, taranwords, r
	else
		WinActivate ahk_class OpusApp
	; }
}



switchToChrome()
{
IfWinNotExist, ahk_exe chrome.exe
	Run, chrome.exe

if WinActive("ahk_exe chrome.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe chrome.exe
}

switchToStreamDeck(){
IfWinNotExist, ahk_exe StreamDeck.exe
	{
	Run, C:\Program Files\Elgato\StreamDeck\StreamDeck.exe
	}
else
	{
	WinActivate ahk_exe StreamDeck.exe
	}
}


#IfWinActive
windowSwitcher(theClass, theEXE)
{
;msgbox,,, switching to `nsavedCLASS = %theClass% `nsavedEXE = %theEXE%, 0.5
IfWinNotExist, %theClass%
	Run, % theEXE
if not WinActive(theClass)
	WinActivate %theClass%
}


sortExplorerByName(){
IfWinActive, ahk_class CabinetWClass
	{
	;Send,{LCtrl down}{NumpadAdd}{LCtrl up} ;expand name field
	send {alt}vo{enter} ;sort by name
	;tippy2("sort Explorer by name")

	}

}

sortExplorerByDate(){
IfWinActive, ahk_class CabinetWClass
	{
	;Send,{LCtrl down}{NumpadAdd}{LCtrl up} ;expand name field
	send {alt}vo{down}{enter} ;sort by date modified, but it functions as a toggle...
	;tippy2("sort Explorer by date")

	}

}






;---------------------

ExplorerViewChange_Window(explorerHwnd)
{
;https://autohotkey.com/boards/viewtopic.php?t=28304
	if (!explorerHwnd)
		return
	;msgbox,,, % explorerHwnd, 0.5
	Windows := ComObjCreate("Shell.Application").Windows
	for window in Windows
		if (window.hWnd == explorerHwnd)
			sFolder := window.Document
			
	;sFolder.ShellView := 1
	sFolder.CurrentViewMode := 4 ; Details
	;tooltip % sFolder.CurrentViewMode
	;sFolder.SORTCOLUMNS := PKEY_ItemNameDisplay, SORT_DESCENDING, bsssssss
}

;;;must look through that thread to find the direct "sort by name, sort by date" thingies.

ExplorerViewChange_List(explorerHwnd)
{
	if (!explorerHwnd)
		return
	;msgbox,,, % explorerHwnd, 0.5
	Windows := ComObjCreate("Shell.Application").Windows
	for window in Windows
		if (window.hWnd == explorerHwnd)
			sFolder := window.Document
	if (sFolder.CurrentViewMode == 8)
		sFolder.CurrentViewMode := 6 ; Tiles
	else if (sFolder.CurrentViewMode == 6)
		sFolder.CurrentViewMode := 4 ; Details
	else if (sFolder.CurrentViewMode == 4)
		sFolder.CurrentViewMode := 3 ; List
	else if (sFolder.CurrentViewMode == 3) {
		sFolder.CurrentViewMode := 2 ; Small icons
		sFolder.IconSize := 16 ; Actually make the icons small...
	} else if (sFolder.CurrentViewMode == 2) {
		sFolder.CurrentViewMode := 1 ; Icons
		sFolder.IconSize := 48 ; Medium icon size
	} else if (sFolder.CurrentViewMode == 1) {
		if (sFolder.IconSize == 256)
			sFolder.CurrentViewMode := 8 ; Go back to content view
		else if (sFolder.IconSize == 48)
			sFolder.IconSize := 96 ; Large icons
		else
			sFolder.IconSize := 256 ; Extra large icons
	}
	ObjRelease(Windows)
	tooltip % sFolder.CurrentViewMode
}



ExplorerViewChange_ICONS(explorerHwnd)
{

	if (!explorerHwnd)
	{
		tooltip, exiting.
		sleep 100
		return
	}
	;msgbox,,, % explorerHwnd, 0.5
	Windows := ComObjCreate("Shell.Application").Windows
	for window in Windows
		if (window.hWnd == explorerHwnd)
			sFolder := window.Document
	if (sFolder.CurrentViewMode >= 2) {
		sFolder.CurrentViewMode := 1 ; icons
		sFolder.IconSize := 256 ; make the icons big...
		;tooltip, large 1
	} else if (sFolder.CurrentViewMode == 1) {
		if (sFolder.IconSize == 48){
			sFolder.IconSize := 256
			;tooltip, large
			}
		else if (sFolder.IconSize == 256){
			sFolder.IconSize := 96
			;tooltip, you are now at medium icons
			}
		else if (sFolder.IconSize == 96) {
			sFolder.IconSize := 48 ; smallish icons
			;tooltip, you are now at smallish icons
			}
		else {
			sFolder.CurrentViewMode := 1
			sFolder.IconSize := 256
			;tooltip, reset
		}
	}
	;tooltip % sFolder.IconSize
	;tooltip, %explorerHwnd%
	;sleep 100
	;tooltip, % sFolder.CurrentViewMode
}


; ExplorerViewChange_ICONS(explorerHwnd)
; {

	; if (!explorerHwnd)
	; {
		; tooltip, exiting.
		; sleep 100
		; return
	; }
	; ;msgbox,,, % explorerHwnd, 0.5
	; Windows := ComObjCreate("Shell.Application").Windows
	; for window in Windows
		; if (window.hWnd == explorerHwnd)
			; sFolder := window.Document
	; if (sFolder.CurrentViewMode >= 2) {
		; sFolder.CurrentViewMode := 1 ; Small icons
		; sFolder.IconSize := 48 ; Actually make the icons small...
	; } else if (sFolder.CurrentViewMode == 1) {
		; if (sFolder.IconSize == 256){
			; sFolder.CurrentViewMode := 2 ; Go back to small icons
			; sFolder.IconSize := 48
			; }
		; else if (sFolder.IconSize == 48)
			; sFolder.IconSize := 96 ; Large icons
		; else
			; sFolder.IconSize := 256 ; Extra large icons
	; }
	; ;tooltip % sFolder.IconSize
	; ;tooltip, %explorerHwnd%
	; ;sleep 100
	; ;tooltip, % sFolder.CurrentViewMode
; }



; ; ;testing the script here...
; ; #If (exphWnd := WinActive("ahk_class CabinetWClass"))
; ; ^+::
; ; ^=::
; ; tooltip, waaaaaaaaat
; ; ExplorerViewChange_Window(exphWnd)
; ; return
; ; #If



; Script to activate any given firefox tab...
;This requires the ACC library, which you have to install into AutoHotKey (it's pretty easy, just scroll to the top of this page and follow the instructions.)
;https://autohotkey.com/boards/viewtopic.php?f=6&t=26947&p=139114#p139114
; calling the funciton looks like this: 
^!+numpad2::JEE_FirefoxFocusTabByName(hWnd, "Linus Media Group Inc. Mail")
;==================================================

JEE_FirefoxGetTabCount(hWnd)
{
oAcc := Acc_Get("Object", "4", 0, "ahk_id " hWnd)
vRet := 0
for each, oChild in Acc_Children(oAcc)
	if (oChild.accName(0) == "Browser tabs")
	{
		oAcc := Acc_Children(oChild)[1], vRet := 1
		break
	}
if !vRet
{
	oAcc := oChild := ""
	return
}

vCount := 0
for each, oChild in Acc_Children(oAcc)
	if !(oChild.accName(0) == "")
		vCount++
oAcc := oChild := ""
return vCount
}

;==================================================

JEE_FirefoxGetTabNames(hWnd, vSep="`n")
{
oAcc := Acc_Get("Object", "4", 0, "ahk_id " hWnd)
vRet := 0
for each, oChild in Acc_Children(oAcc)
	if (oChild.accName(0) == "Browser tabs")
	{
		oAcc := Acc_Children(oChild)[1], vRet := 1
		break
	}
if !vRet
{
	oAcc := oChild := ""
	return
}

vOutput := ""
for each, oChild in Acc_Children(oAcc)
{
	vTabText := oChild.accName(0)
	if !(vTabText == "")
	;&& !(vTabText == "New Tab")
	;&& !(vTabText == "Open a new tab")
		vOutput .= vTabText vSep
}
vOutput := SubStr(vOutput, 1, -StrLen(vSep)) ;trim right
oAcc := oChild := ""
return vOutput
}

;==================================================

gotofiretab(name,URL)
{
;WinActivate ahk_exe firefox.exe ;I think this is unreilable because it only makes sure the applicaiton is RUNNING, not necessarily that it's ACTIVE.
WinActivate ahk_class MozillaWindowClass ;so i use the CLASS instead.
;tooltip, FIRETAB
sleep 15
WinGet, the_current_id, ID, A
vRet := JEE_FirefoxFocusTabByName(the_current_id, name)
;tooltip, vret is %vRet%
if (vRet = 0)
	run, firefox.exe %URL%
sleep 100
tooltip,
}



JEE_FirefoxFocusTabByNum(hWnd, vNum)
{
;TARAN NOTE: Using a tab NAME is somewhat unstable. Gmail for example will dynamically change the name to "Message from Nick Light" or whatever else. So really, I need to get the tab URL. will have to poke around ACC viewer to see where that information is...
; for future URL getting: https://autohotkey.com/boards/viewtopic.php?t=3702
; better: https://autohotkey.com/boards/viewtopic.php?f=6&t=26947&p=139114#p139114



oAcc := Acc_Get("Object", "4", 0, "ahk_id " hWnd)
vRet := 0
for each, oChild in Acc_Children(oAcc)
	if (oChild.accName(0) == "Browser tabs")
	{
		oAcc := Acc_Children(oChild)[1], vRet := 1
		break
	}
if !vRet || !Acc_Children(oAcc)[vNum]
	vNum := ""
else
	Acc_Children(oAcc)[vNum].accDoDefaultAction(0)
oAcc := oChild := ""
return vNum
}

;==================================================



 
JEE_FirefoxFocusTabByName(hWnd, vTitle, vNum=1)
{
oAcc := Acc_Get("Object", "4", 0, "ahk_id " hWnd)
vRet := 0
for each, oChild in Acc_Children(oAcc)
	if (oChild.accName(0) == "Browser tabs")
	{
		oAcc := Acc_Children(oChild)[1], vRet := 1
		break
	}
if !vRet
{
	oAcc := oChild := ""
	return
}

vCount := 0, vRet := 0
for each, oChild in Acc_Children(oAcc)
{
	vTabText := oChild.accName(0)
	; if (vTabText = vTitle)
		; vCount++
	If InStr(vTabText, vTitle) ;TARAN NOTE: I changed this line so that only a PARTIAL tab title match is required.
		vCount++
	if (vCount = vNum)
	{
		oChild.accDoDefaultAction(0), vRet := A_Index
		break
	}
}
oAcc := oChild := ""
return vRet
}
 
;==================================================













;;;;;;;scripts from this guy;;;;;;;;;;;;;;;;
;https://github.com/asvas/AsVas_AutoHotkey_Scripts/blob/master/ahk_Scripts.ahk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;not CURRENTLY used anywhere...;;;;


; x::F_Switch("firefox.exe","ahk_class MozillaWindowClass","firefoxgroup","C:\Program Files (x86)\Mozilla Firefox\firefox.exe")
; +x::F_Run("firefox.exe","C:\Program Files (x86)\Mozilla Firefox\firefox.exe")
; c::F_Switch("chrome.exe","ahk_class Chrome_WidgetWin_1","chromegroup")
; +c::F_Run("chrome.exe")
;
; w::F_Switch("WINWORD.EXE","ahk_class OpusApp","wordgroup") ;,"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk")
; +w::F_Run("WINWORD.EXE") ;,"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk")


;Function for hiding/Showing the intercept.exe window
F_Intercept_visibility()
{
IfWinActive ahk_exe intercept.exe
	WinHide ahk_exe intercept.exe
else
	WinShow ahk_exe intercept.exe
return
}

;---------------------------------------------------------------------------------
;Function for running intercept.exe
F_Intercept_run()
{
Run, intercept.exe
Sleep 250
WinActivate ahk_exe intercept.exe
send y
WinHide ahk_exe intercept.exe
return
}

;---------------------------------------------------------------------------------
;Run Function - Running specific executable
F_Run(Target,TPath = 0)
{
if TPath = 0 
	Run, %Target%
else
	Run, %TPath% ;Command for running target if conditions are satisfied
}

;---------------------------------------------------------------------------------
;Switch Function - Switching between different instances of the same executable or running it if missing
F_Switch(Target,TClass,TGroup,TPath = 0)
{
IfWinExist, ahk_exe %Target% ;Checking state of existence
	{
	GroupAdd, %TGroup%, %TClass% ;Definition of the group (grouping all instance of this class) (Not the perfect spot as make fo unnecessary reapeats of the command with every cycle, however the only easy option to keep the group up to date with the introduction of new instances)
	ifWinActive %TClass% ;Status check for active window if belong to the same instance of the "Target"
		{
		GroupActivate, %TGroup%, r ;If the condition is met cycle between targets belonging to the group
		}
	else
		WinActivate %TClass% ;you have to use WinActivatebottom if you didn't create a window group.
	}
else
	{
	if TPath = 0 
		Run, %Target%
	else
		Run, %TPath% ;Command for running target if conditions are satisfied
	}
Return
}
;;;;;;scripts from another guy END;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;END OF FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; insert::

; return

;;; https://autohotkey.com/board/topic/34696-explorer-post-message-sort-by-modified-size-name-etc/
; pgup::
; tooltip, sort by name?
; PostMessage, 0x111, 30210,,, ahk_class CabinetWClass ; Name
; return

; pgdn::
; PostMessage, 0x111, 28715,,, ahk_class CabinetWClass ; List
; ;PostMessage, 0x111, 30213,,, ahk_class CabinetWClass ; Date modified
; return


;;-----BEGIN FUNCTION KEYS PAIRED WITH CTRL --------
;;---These are mostly application switching keys.---
#IfWinActive

;Macro key G13
;F13:: ;it's more reliable to use the scan code, i guess? Maybe because I used "F13::" elsewhere.
SC064::back()

;macro key G16
^F1::switchToFirefox()
+^F1::switchToOtherFirefoxWindow() ;^+F1 ^+{F1}

;macro key G17
^F2::switchToExplorer()
!^F2::closeAllExplorers()

;macro key G18
^F3::switchToPremiere()

;macro key G15
^F4::switchToWord()
+^F4::switchWordWindow() ; AKA, ^+F4 ^+{F4}

;No K95 macro key assigned:
^F5::switchToChrome()
;also, CTRL works a little funny when the function uses CTRL TAB to switch tabs. This might be better assigned to ALT F5 or something.

;macro key G14
+^F6::
windowSaver()
msgbox,,, savedCLASS = %savedCLASS% `nsavedEXE = %savedEXE%, 0.6
Return

;Macro key G14
^F6::
;I had to learn just now to use the parameter to pass "savedCLASS" even though it's already a global variable. Just works better this way... but really IDK what i am doing.
;msgbox,,, switching to `nsavedCLASS = %savedCLASS% `nsavedEXE = %savedEXE%,0.3
switchToSavedApp(savedCLASS) 
return

;No K95 macro key assigned:
^F9::windowSwitcher("ahk_exe AfterFX.exe","C:\Program Files\Adobe\Adobe After Effects CC 2017\Support Files\AfterFX.exe") ;NOTE: was used for toggle all video tracks in premiere.
^F10::windowSwitcher("ahk_exe StreamDeck.exe","C:\Program Files\Elgato\StreamDeck\StreamDeck.exe")

; ^F11 is taken by filemover.ahk
; ^F12 is also taken by filemover.ahk
;NOTE: ^F12 (ctrl F12) is forbidden by Premiere, since it opens the Premiere CONSOLE. interesting.

;;------END OF CTRL FUNCITON KEYS----------

;#IfWinActive
;winkey Z opens the CLOCK / CALENDAR. ;http://superuser.com/questions/290068/windows-keyboard-shortcut-to-view-calendar
;#z::
;Send #b{left}{left}{enter}
;Return

#IfWinActive
Joy1::msgbox you hit Joy1
Joy2::msgbox you hit Joy2
Joy3::msgbox you hit Joy3
;I could never get any of these working

#ifWinActive
!,::msgbox, A_workingDir should be %A_WorkingDir%
!.::msgbox, TaranDir should be %TaranDir%
Xbutton1::return
Xbutton2::return ;these are both on the side of my mouse and I don't like accidentally hitting them.

