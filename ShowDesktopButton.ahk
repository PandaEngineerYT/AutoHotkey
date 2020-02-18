#NoTrayIcon
#SingleInstance force
; Found on https://github.com/PandaEngineerYT/
;
; Show Desktop button in right bottom corrner for Windows XP and Windows 7
;
; Usefull for classic theme (you can remove time and windows show desktop button to save space on taskbar)
; Displays time. Left click shows desktop, right click shows current time with seconds and date in tooltip.
;
Gui +ToolWindow +AlwaysOnTop -Border
SysGet, ScreenWidth, 61
SysGet, ScreenHeight, 62

SysGet, Mon,MonitorPrimary
SysGet, Mon,Monitor, Mon
WinPosH:=MonBottom-28
WinPos:=MonRight-15


gui, font, s7, Arial
Gui, Add, Text, x0 y0 gButton_ vMytext h80 w30, 88`n88
Gui, Show, x%WinPos% y%WinPosH% h27 w12 NoActivate , ShowDesk 

old_min=90

SetTimer, ResChe, 60000




Loop
{
if old_min<>%A_Min%
{
GuiControl, Text, Mytext, %A_Hour%`n%A_Min%
old_min=%A_Min%
}
Gui +AlwaysOnTop
Sleep 500
}
return 

ResChe:
SysGet, ScreenWidthN, 61
SysGet, ScreenHeightN, 62
if (ScreenWidthN<>ScreenWidth OR ScreenHeight<>ScreenHeightN) 
{
Reload
}
return


Button_:
Send #{d}
Gui +AlwaysOnTop
return

GuiContextMenu:
Tooltip, %A_Space%%A_Space%%A_Hour%:%A_Min%:%A_Sec%`n%A_DD%-%A_MM%-%A_YYYY%
Sleep, 1000
Tooltip,
return



GuiClose: 
 ExitApp
