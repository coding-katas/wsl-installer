#### Windows environment variables
Write-Host ''
Write-Host "Modifying user's temporary directories (ZoneCentral)" -ForegroundColor Yellow -BackgroundColor DarkBlue
Set-Variable -Name 'WindowsTemp' -Value "C:\My Program Files\Windows\Temp"
if (!(Test-Path -Path $WindowsTemp)) {
    New-Item -Path 'C:\My Program Files' -Name 'Windows\Temp' -ItemType 'directory'
}
# [System.Environment]::SetEnvironmentVariable('TEMP', $WindowsTemp, [System.EnvironmentVariableTarget]::User)
setx TEMP "$WindowsTemp"
# [System.Environment]::SetEnvironmentVariable('TMP', $WindowsTemp, [System.EnvironmentVariableTarget]::User)
setx TMP "$WindowsTemp"
Write-Host 'TEMP:           ' -ForegroundColor Yellow -NoNewline
Write-Host "$env:TEMP" -ForegroundColor Green
Write-Host 'TMP:            ' -ForegroundColor Yellow -NoNewline
Write-Host "$env:TMP" -ForegroundColor Green

Write-Host ''
Write-Host "Please, reboot your computer." -ForegroundColor Green
Write-Host "After that you will can run the LSW's installation again." -ForegroundColor Green
Write-Host ''

# Read-Host -Prompt 'Press Enter to continue'
Exit 0
