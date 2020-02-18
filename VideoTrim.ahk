#SingleInstance Force
; Autohothey loseless Trimmer with FFMPEG
; Found on https://github.com/PandaEngineerYT/

; SET bin PATH!
ffmpegbin_path:="D:\Soft\ffmpeg\bin"


; regonised ext:
extensions :="mp4,flv,vob,mpg,mkv,mts"

FileSelectFile, file, 2, D:\, Select WMP Compatible File:%extensions%

if Errorlevel
   ExitApp

SplitPath,file, name, dir, ext, name_no_ext, drive

If Ext not In %extensions%
{
msgbox, 262208, ,Can't PLAY`n--------------`nExtension is not in %extensions% .
exitapp
}   

isPlaying:=0
isSliding:=0
ssVal:=0
toVal:=0

;Gui, +LastFound +Resize
Gui,2:Color,Black
Gui,2:Color,ControlColor, Black
Gui,2: Add, ActiveX,x25 y25 w1400 h800 vWMP, WMPLayer.OCX
WMP.Url := file
WMP.uiMode := "none"                   ; no WMP controls
WMP.stretchToFit := 1                  ; video is streched to the given activex range
WMP.enableContextMenu := 0             ; no reaction to right click in the video field
;WMP.settings.setMode("loop", true)

Sleep 100
WMP.Controls.pause()
Sleep 100
WMP.Controls.pause()
Sleep 100
WMP.Controls.pause()
Sleep 100
WMP.Controls.pause()


len:=WMP.currentMedia.duration*100
Gui,2: Add, Slider, vTimeSlider gTimeSlide tickinterval1 w1400 Range0-%len% AltSubmit NoTicks Line10 Page100
VideoStep:=1/WMP.network.encodedFrameRate

Gui,2:Color,ControlColor, White
gui,2: add, button, h20 w70 gPlayPause, ▶/⏸

gui,2: add, button, h20 w50 x+5 gDStepL, ⯬
gui,2: add, button, h20 w50 x+5 gStepL, ⯇
gui,2: add, button, h20 w50 x+5 gStepR, ⯈
gui,2: add, button, h20 w50 x+5 gDStepR, ⯮
Gui,2: Add, Edit, w80 x+30 vBeg ReadOnly Right cWhite, Not Set
gui,2: add, button, h20 w50 x+5 gSetBeggining, [
gui,2: add, button, h20 w50 x+5 gGoBeggining, ⇤
gui,2: add, button, h20 w50 x+5 gGoEnd, ⇥
gui,2: add, button, h20 w50 x+5 gSetEnd, ]
Gui,2: Add, Edit, w80 x+5 vEnd ReadOnly Right cWhite, Not Set
gui,2: add, button, h20 w50 x+30 gTrim vTrim Disabled, Trim
gui,2: add, button, h20 w50 x+30 gExitBtn , Exit
gui, 2: default
SetTimer, TimeChk, 100

Gui,2: Show, w1450 Center, Player GUI
return

ExitBtn:
2GuiClose:
ExitApp

PlayPause:
if isPlaying = 1
{
WMP.Controls.pause()
isPlaying:=0
}
else
{
WMP.Controls.play()
isPlaying:=1
}
return

TimeSlide:
isSliding:=1
WMP.Controls.pause()
WMP.controls.currentPosition:=(TimeSlider/100)-VideoStep
WMP.Controls.step(1)
if A_GuiEvent = normal
{
if isPlaying = 1
{
;WMP.Controls.play()
}

isSliding:=0
}
return

SetBeggining:
GuiControl, 2:,Beg, % WMP.controls.currentPosition
ssVal:=WMP.controls.currentPosition
if (ssVal != 0 and toVal != 0)
{
GuiControl, 2: Enable, Trim
}
return

SetEnd:
GuiControl, 2:,End, % WMP.controls.currentPosition
toVal:=WMP.controls.currentPosition
if (ssVal != 0 and toVal != 0)
{
GuiControl, 2: Enable, Trim
}
return


GoBeggining:
WMP.controls.currentPosition:=ssVal-VideoStep
WMP.Controls.step(1)
return

GoEnd:
WMP.controls.currentPosition:=toVal-VideoStep
WMP.Controls.step(1)
return


StepL:
WMP.controls.currentPosition:=WMP.controls.currentPosition-0.05-VideoStep
WMP.Controls.step(1)
return

StepR:
WMP.controls.currentPosition:=WMP.controls.currentPosition+0.05-VideoStep
WMP.Controls.step(1)
return

DStepL:
WMP.controls.currentPosition:=WMP.controls.currentPosition-0.3-VideoStep
WMP.Controls.step(1)
return

DStepR:
WMP.controls.currentPosition:=WMP.controls.currentPosition+0.3-VideoStep
WMP.Controls.step(1)
return




Trim:
newname=%dir%\%name_no_ext%_%A_YYYY%%A_MM%%A_DD%%A_Hour%%A_Min%%A_Sec%.%ext%
Run %ffmpegbin_path%\ffmpeg.exe -i %file% -ss %ssVal% -to %toVal% -c copy %newname%
;-strict -2 ?
return

TimeChk:
if isSliding = 0 
{
curPos:=WMP.controls.currentPosition*100
;MsgBox, %curPos%/%len%
GuiControl, 2:, TimeSlider, % curPos
}
Return
