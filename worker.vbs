' worker.vbs - Background Scroll Lock toggler
Option Explicit

Dim fso, shell, file, path, lines, enabled, endTime, now
Dim currentMins, targetMins, crossedMidnight

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

path = "state.txt"

Do
    ' Check for state.txt; if missing, recreate with defaults
    If Not fso.FileExists(path) Then
        Set file = fso.CreateTextFile(path, True)
        file.WriteLine "ENABLED=True"
        file.WriteLine "END_TIME=03:30"
        file.Close
        ' Log the creation of the missing file (optional, can be removed)
        ' shell.LogEvent 4, "State file missing; recreating and exiting."
        WScript.Quit  ' Exit gracefully after recreating file
    End If

    ' Read state from file
    Set file = fso.OpenTextFile(path, 1)
    Do Until file.AtEndOfStream
        lines = lines & file.ReadLine & vbCrLf
    Loop
    file.Close

    enabled = GetValue("ENABLED", lines)
    endTime = GetValue("END_TIME", lines)

    If UCase(enabled) <> "TRUE" Then WScript.Quit

    ' Time comparison
    now = Time
    currentMins = Hour(now) * 60 + Minute(now)
    targetMins = TimeToMinutes(endTime)

    ' Handle shift past midnight (e.g. 22:00 to 03:30)
    crossedMidnight = False
    If targetMins < currentMins Then
        crossedMidnight = True
    End If

    If Not crossedMidnight And currentMins >= targetMins Then
        ' Time exceeded – disable script
        Set file = fso.CreateTextFile(path, True)
        file.WriteLine "ENABLED=False"
        file.WriteLine "END_TIME=" & endTime
        file.Close
        WScript.Quit
    End If

    ' Toggle Scroll Lock to simulate activity
    shell.SendKeys "{SCROLLLOCK}"
    WScript.Sleep 200
    shell.SendKeys "{SCROLLLOCK}"

    ' Wait 1 minute (60000 ms)
    WScript.Sleep 60000
    lines = ""

Loop

' Extract value from file content
Function GetValue(key, content)
    Dim linesArr, i
    linesArr = Split(content, vbCrLf)
    For i = 0 To UBound(linesArr)
        If InStr(linesArr(i), key & "=") = 1 Then
            GetValue = Trim(Split(linesArr(i), "=")(1))
            Exit Function
        End If
    Next
    GetValue = ""
End Function

' Convert HH:MM to total minutes
Function TimeToMinutes(t)
    On Error Resume Next
    Dim parts
    parts = Split(t, ":")
    TimeToMinutes = CInt(parts(0)) * 60 + CInt(parts(1))
End Function
