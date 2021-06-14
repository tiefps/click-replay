; Click Replay - a script v0.1

#SingleInstance Force

CoordMode, Mouse, Screen

Class ClickInfo
{
  x := 0
  y := 0
  delay := 0
  left := true
  shift := false
}

ClickReplay := []
Recording := false
ReferenceTime := 0
Replaying := false

; start/stop recording
F12::
	global Recording
	global ReferenceTime
	global ClickReplay
  
	Recording := !Recording
	
	; if we just stopped recording, append the extra time to the first action's sleep
	if !Recording and ClickReplay.Count() > 0
	{	
		ClickReplay[1].delay += A_TickCount - ReferenceTime
	}
	
	ReferenceTime := A_TickCount
	return
	
; start the replay
F11::
	global Replaying
	If (Replaying := !Replaying)
		SetTimer, Timer, -1
	return
	
Timer:
	global ClickReplay
	global Replaying
	while Replaying
	{
		for index, element in ClickReplay
		{
			Sleep, element.delay
			if !Replaying
			{
				break
			}
			

			if element.shift
			{
				Send, {Shift down}
			}
			if element.left
			{
				MouseClick, left, element.x, element.y
			}
			else
			{
				MouseClick, right, element.x, element.y
			}
			if element.shift
			{
				Send, {Shift up}
			}
		}
	}
	return
	
; debugging
F10::
	global ClickReplay
	Out := ""

    for index, element in ClickReplay
	{
	    NewOut = % "Element number " . index . " is " . element.x . " " . element.y . " " . element.delay . " " . element.shift "`n"
		Out .= NewOut
	}
	MsgBox %Out%
	return
	
; reset
F9::
	global ClickReplay
	global Recording
	global ReferenceTime
	global Replaying
	
	ClickReplay := []
	Recording := false
	ReferenceTime := 0
	Replaying := false
	return
	
; left-click
~LButton::
	global ClickReplay
	global Recording
	global ReferenceTime
  
	if Recording
	{
		TempClickInfo := new ClickInfo
		MouseGetPos, xPos, yPos
		TempClickInfo.x := xPos
		TempClickInfo.y := yPos
		TempClickInfo.delay := A_TickCount - ReferenceTime
		TempClickInfo.left := true
		TempClickInfo.shift := false
		ReferenceTime := A_TickCount
		ClickReplay.Push(TempClickInfo)
	}
	return

; shift + left-click
~+LButton::
	global ClickReplay
	global Recording
	global ReferenceTime
  
	if Recording
	{
		TempClickInfo := new ClickInfo
		MouseGetPos, xPos, yPos
		TempClickInfo.x := xPos
		TempClickInfo.y := yPos
		TempClickInfo.delay := A_TickCount - ReferenceTime
		TempClickInfo.left := true
		TempClickInfo.shift := true
		ReferenceTime := A_TickCount
		ClickReplay.Push(TempClickInfo)
	}
	return
	
; right-click	
~RButton::
	global ClickReplay
	global Recording
	global ReferenceTime
  
	if Recording
	{
		TempClickInfo := new ClickInfo
		MouseGetPos, xPos, yPos
		TempClickInfo.x := xPos
		TempClickInfo.y := yPos
		TempClickInfo.delay := A_TickCount - ReferenceTime
		TempClickInfo.left := false
		TempClickInfo.shift := false
		ReferenceTime := A_TickCount
		ClickReplay.Push(TempClickInfo)
	}
	return
