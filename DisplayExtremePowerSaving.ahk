; Found on https://github.com/PandaEngineerYT/
;
; Turns off display after 15s of inactivity while keeping computer unlocked. Turns screen on temporarily in case of any flashing window on taskbar or when new window is created (for example new IM message).
;
; Power Saving is enabled by Ctrl+Shift+PageUp
; Tray notification (eject CD tray on any flashing window) is enabled with Ctrl+Shift+PageDn
;
#SingleInstance force
#Persistent
;SetTimer, chk, 250,-2147483648
monst=on
tray=off
; Variable of time - 15sec
Delay=15000
running=off

Process, priority, DllCall("GetCurrentProcessId"), Low

flashWinID =
Gui +LastFound
hWnd := WinExist() , DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage" )
;NoSleep
SetTimer, MouseM, 300000

;Blank gui
Gui, Margin, 0, 0
Gui, -Border +Disabled +AlwaysOnTop +ToolWindow 
Gui, Color, 000000
Gui, Show, W%A_ScreenWidth% H%A_ScreenHeight% x-3 y-3 Hide, Background

Return 



MouseM:
IfEqual, monst, off, {
Gui, Show
}
MouseMove, 0, 0, 0, R

IfEqual, monst, off, {
SendMessage 0x112, 0xF170, 2, , Program Manager
sleep 500
Gui, Show, Hide
}
return


ShellMessage( wParam,lParam ) {
  If ( wParam = 0x8006 ) ;  0x8006 is 32774 as shown in Spy!
    {
global flashWinID
global otitles
global tray
global monst
flashWinID := lParam
otitles:=
IfEqual, tray, on, {
IfEqual, monst, off, {
Drive, Eject
}
}

    }
}

^+PgUp::
ifequal, running, on, {
SetTimer, chk, off
running=off
Tooltip, Powersaving Off
Sleep, 500
Tooltip,
} else {
SetTimer, chk, 250,-2147483648
running=on
Tooltip, Powersaving On
Sleep, 500
Tooltip, 

}
return

^+PgDn::
ifequal, tray, on, {
tray=off
Tooltip, TrayNotify Off
Sleep, 500
Tooltip,
} else {
tray=on
Tooltip, TrayNotify On
Sleep, 500
Tooltip, 
}
return


chk:
IfEqual, monst, on, {
IfGreater, A_TimeIdle, %Delay%, {
SendMessage 0x112, 0xF170, 2, , Program Manager
SetTimer, chk, off
Sleep 250
otitles=
WinGet, id, list,,, Program Manager
Loop, %id%
{
tmp:=id%A_Index%
WinGetTitle, this_title, ahk_id %tmp%
otitles=%otitles%%this_title%
}
monst=off
SetTimer, chk, 500,-2147483648
}
}


IfLess, A_TimeIdle, %Delay%, {
monst=on
}
time=%A_TimeIdle%


IfEqual, monst, off, {
titles=
WinGet, id, list,,, Program Manager
Loop, %id%
{
tmp:=id%A_Index%
WinGetTitle, this_title, ahk_id %tmp%
titles=%titles%%this_title%
}
IfNotEqual, titles, %otitles%, {
SetTimer, chk, off
SendMessage 0x112, 0xF170, -1, , Program Manager
Sleep %Delay%
monst=on
SetTimer, chk, 250,-2147483648
}
}
return

;Uncomment this for Ctr+2 to flash current window afte 15s for testing purpouses
;
;^2::
; hWnd := WinActive( "A" )
;Sleep, 15000
; DllCall( "FlashWindow", UInt,hWnd, Int,True )
; DllCall( "FlashWindow", UInt,hWnd, Int,True )
;Return
