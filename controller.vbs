Option Explicit

Dim fso, file, path, enabled, endTime, inputTime, userInput
path = "state.txt"

Set fso = CreateObject("Scripting.FileSystemObject")

' Ask user if they want to enable the script
userInput = MsgBox("Do you want to enable the availability script?", vbYesNo + vbQuestion, "Enable Script?")

If userInput = vbNo Then
    ' Write disabled state and exit
    Set file = fso.CreateTextFile(path, True)
    file.WriteLine "ENABLED=False"
    file.WriteLine "END_TIME=03:30" ' Default end time if user selects No
    file.Close
    WScript.Quit
End If

' If Yes, ask for end time
inputTime = InputBox("Enter end time (HH:MM, 24h format):", "Set End Time", "03:30")
If inputTime = "" Then WScript.Quit

' Validate time format
If Not IsValidTimeFormat(inputTime) Then
    MsgBox "Invalid time format. Use HH:MM in 24-hour format.", vbExclamation, "Invalid Input"
    WScript.Quit
End If

' Write enabled state
enabled = "True"

Set file = fso.CreateTextFile(path, True)
file.WriteLine "ENABLED=" & enabled
file.WriteLine "END_TIME=" & inputTime
file.Close

' Run worker if enabled
If enabled = "True" Then
    Dim shell
    Set shell = CreateObject("WScript.Shell")
    shell.Run "wscript.exe worker.vbs", 0, False  ' Run worker silently
End If

' Time format validation function
Function IsValidTimeFormat(t)
    On Error Resume Next
    Dim parts, hourPart, minutePart
    parts = Split(t, ":")
    If UBound(parts) <> 1 Then
        IsValidTimeFormat = False
        Exit Function
    End If
    hourPart = CInt(parts(0))
    minutePart = CInt(parts(1))
    If IsNumeric(hourPart) And IsNumeric(minutePart) Then
        If hourPart >= 0 And hourPart <= 23 And minutePart >= 0 And minutePart <= 59 Then
            IsValidTimeFormat = True
            Exit Function
        End If
    End If
    IsValidTimeFormat = False
End Function
