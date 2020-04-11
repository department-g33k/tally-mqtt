add-type -path 'C:\MASTERS\SwitcherLib.dll'
add-type -Path "C:\masters\lib\M2Mqtt.4.3.0.0\lib\net45\M2Mqtt.Net.dll" 

$LastProgram = 0
$LastPreview = 0

$MqttClient = [uPLibrary.Networking.M2Mqtt.MqttClient]("10.10.10.8")
$mqttclient.Connect([guid]::NewGuid(), $null, $null, 0, 0, 1, "tally/statusLW", "error", 1, 30 )

$Global:atem = New-Object SwitcherLib.Switcher("10.10.10.56")
$atem.Connect() #For some reason, this command errors out, even with the switcher active.  But the script still works.  So........
$MEs = $atem.getmes() #Same here, this errors out, but the $MEs object still updates with live data from the switcher.  Honestly it seems like it works and the error is just a false-positive.

While ($true) {

$me1 = $MEs[0]

#Keep track of last value, and only execute anything if the value changes.  If value hasn't changed, do nothing.
If (($($me1.Program) -ne $LastProgram) -or ($($me1.Preview) -ne $LastPreview)) {

#Set LastProgram to match current program
$LastProgram = $me1.Program
$LastPreview = $me1.Preview

#CAM1 Tally Check
If ($($me1.Program) -eq 8) {$MqttClient.Publish("cam1/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,255,0,0,0"), 0, 0)}
ElseIf ($($me1.Preview) -eq 8) {$MqttClient.Publish("cam1/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,0,255,0,0"), 0, 0)}
Else {$MqttClient.Publish("cam1/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,0,0,0,0"), 0, 0)}

#ZOOM Tally Check
If ($($me1.Program) -eq 9) {$MqttClient.Publish("zoom/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,255,0,0,0"), 0, 0)}
ElseIf ($($me1.Preview) -eq 9) {$MqttClient.Publish("zoom/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,0,255,0,0"), 0, 0)}
Else {$MqttClient.Publish("zoom/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,0,0,0,0"), 0, 0)}

#CWID Tally Check
If ($($me1.Program) -eq 6) {$MqttClient.Publish("cwid/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,255,0,0,0"), 0, 0)}
ElseIf ($($me1.Preview) -eq 6) {$MqttClient.Publish("cwid/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,0,255,0,0"), 0, 0)}
Else {$MqttClient.Publish("cwid/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,0,0,0,0"), 0, 0)}

#LEF2 Tally Check
If ($($me1.Program) -eq 6) {$MqttClient.Publish("lef2/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,255,0,0,0"), 0, 0)}
ElseIf ($($me1.Preview) -eq 6) {$MqttClient.Publish("lef2/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,0,255,0,0"), 0, 0)}
Else {$MqttClient.Publish("lef2/cmd", [System.Text.Encoding]::UTF8.GetBytes("neopixelall,0,0,0,0"), 0, 0)}

Write-Host "Preview: " -NoNewline -ForegroundColor Red
Write-Host $me1.Program
Write-Host "Program: " -NoNewline -ForegroundColor Green
Write-Host $me1.Preview
<#
'zoom' = 9
'CAM1' = 8
'CWID' = 6
'LEF2' = 3
'COMP' = 1
#>
}
Start-Sleep -Seconds 1
}