; Found on https://github.com/PandaEngineerYT/
;
; Timer with reminder
;
; Allways on top, does not cover minimalize, maximilize and close buttons. Blinks and rings at the end of countdown.
; Choose time to count down in minutes by pressing up and down keys, start by pressing the value.
; Right click on time makes it full screen, left makes it semi-transparent.
; 
; Usefull for pomidoro technique.



SetTitleMatchMode, 2
gui, font, s30 , Microsoft Sans Serif
Gui, Add, Text, x40 y-8 vTimeLeft gTransMode, 00:00
gui, font, s6, Small Fonts
Gui, Add, Button, x0 y0 h15 w40 Default, Go!
Gui, Add, UpDown, vMyUpDown Range1-60, 25
Gui, Add, Button, x0 y16 w33 h15, Reset
gui, font, s1, Small Fonts
Gui, Add, Button, x33 y16 w7 h15, X
Gui +ToolWindow +AlwaysOnTop -Border
SysGet, ScreenWidth, 61
SysGet, ScreenHeight, 62
WinPos:=ScreenWidth-250

Gui, Margin, -1, 0
Gui, Show, x%WinPos% y1 h31 w138, Timer 

started=false
stop=false
fsmode=true
return 

ButtonReset:
stop=true
return

ButtonX:
 ExitApp
return



GuiContextMenu: 
if (fsmode="false")
{
;WinSet, Transparent, OFF, Timer
gui, font, s30 , Microsoft Sans Serif
GuiControl, Font, TimeLeft
GuiControl, Move, TimeLeft, x40 y-8
;Gui, Show, x1076 y1 h31 w138, Timer 
Gui, Show, x%WinPos% y1 h31 w138, Timer 
fsmode=true
}
else
{

gui, font, s375 , Microsoft Sans Serif
GuiControl, Font, TimeLeft
GuiControl, Move, TimeLeft, x40 y-8 w1274 h770
Gui, Show, x0 y0 w%ScreenWidth% h%ScreenHeight%, Timer 

fsmode=false
}

return 

TransMode:

if (tmode="false")
{
WinSet, Transparent, OFF, Timer
tmode=true
}
else
{
WinSet, Transparent, 75, Timer

tmode=false
}

if (started="false")
{
stop=true
}
return

ButtonGo!:
stop=false
Gui, Submit, NoHide
;Gui, Destroy
if (started="false")
{
pmin:=
psec:=
started=true
min=%MyUpDown%
sec=0
if (min<10)
{
pmin:=0
}
psec:=0
Loop
{
GuiControl, Text, TimeLeft, %pmin%%min%:%psec%%sec%
Sleep, 1000
sec--
if (sec==-1)
{
sec=59
min--
psec:=
}


if (min="0" AND sec="0") 
{
GuiControl, Text, TimeLeft, 00:00
;IfWinExist, Media Player Classic
;{
;WinActivate
;Send {Enter}
;}
;IfWinExist, BESTplayer
;{
;WinActivate
;Send {``}
;}
onoff=true
started=false
Loop 30
{
if (onoff="true")
{
WinSet, Transparent, 100, Timer
onoff=false
} else {
WinSet, Transparent, OFF, Timer
onoff=true
}

    Sleep 200  
	SoundPlay *-1
	if (stop="true") 
	{
	Gui Flash, Off
	break
	}	
}
break
}
if (stop="true") 
{
break
}
if (min<10)
{
pmin:=0
}
if (sec<10)
{
psec:=0
}
}

}
stop=false

started=false
if (tmode="false")
{
WinSet, Transparent, 75, Timer
}
else
{
WinSet, Transparent, OFF, Timer
}
GuiControl, Text, TimeLeft, 00:00
return


GuiClose: 
 ExitApp
