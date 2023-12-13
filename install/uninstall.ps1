# DebugMode exeception name
# $error[0] | fl * -Force
param (
    [Parameter(Mandatory = $true)]
    [String]$WSL_DISTRO_NAME = 'WSL-Ubuntu-20.04-PFC',
    [Parameter(Mandatory = $false)]
    [String]$DebugMode = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name DEBUG).DEBUG
)

#### Global variables
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$ScriptName = $MyInvocation.MyCommand.Name
Write-Host ''
Write-Host 'Variables' -ForegroundColor Yellow -BackgroundColor DarkBlue
Write-Host 'ScriptDirectory:                ' -ForegroundColor Yellow -NoNewline
Write-Host "$ScriptDirectory" -ForegroundColor Green
Write-Host 'ScriptName:                     ' -ForegroundColor Yellow -NoNewline
Write-Host "$ScriptName" -ForegroundColor Green
Write-Host 'DebugMode:                      ' -ForegroundColor Yellow -NoNewline
Write-Host "$DebugMode" -ForegroundColor Green

try {
    . ("$ScriptDirectory\01_variables.ps1")
    . ("$ScriptDirectory\02_functions.ps1")
}
catch {
    Write-Host 'Error occured' -ForegroundColor DarkRed
    Write-Warning "$_"
}

#### Powershell QuickMode
# https://stackoverflow.com/questions/21805712/windows-batch-how-to-disable-quickedit-mode-for-individual-scripts
# Enable:       PwsQuickEdit 1
# Disable:      PwsQuickEdit 2
# Get State:    PwsQuickEdit 3
$PwsQuickEditExe = ((Get-ItemProperty "$RegistryPath" -ErrorAction SilentlyContinue -Name WslRootDir).WslRootDir) + "\bin\PwsQuickEdit.exe"
if (Test-Path "$PwsQuickEditExe" -PathType leaf) {
    Write-Host ''
    Write-Host 'PowerShell QuickEdit mode' -ForegroundColor Yellow -BackgroundColor DarkBlue
    Write-Host 'PwsQuickEdit.exe:               ' -ForegroundColor Yellow -NoNewline
    Write-Host "$PwsQuickEditExe" -ForegroundColor DarkGreen

    Write-Host 'QuickEdit mode:                 ' -ForegroundColor Yellow -NoNewline
    .$PwsQuickEditExe 2
    $status = (.$PwsQuickEditExe 3)
    if ($status -eq 'disabled') {
        Write-Host "$status" -ForegroundColor DarkGreen
    }
    else {
        Write-Host "$status" -ForegroundColor Yellow
        Write-Host 'Please do not click in the current PowerShell console.' -ForegroundColor Yellow
    }
}

# ######################################################################################################################

#### Restore default user proxy configuration
Write-Host ''
Write-Host "Restoring user proxy configuration" -ForegroundColor Yellow -BackgroundColor DarkBlue

$AutoConfigURL = (Get-ItemProperty "$RegistryPath\Proxy" -Name AutoConfigURL -ErrorAction SilentlyContinue).AutoConfigURL
$ProxyServer = (Get-ItemProperty "$RegistryPath\Proxy" -Name ProxyServer -ErrorAction SilentlyContinue).ProxyServer
$ProxyEnable = (Get-ItemProperty "$RegistryPath\Proxy" -Name ProxyEnable -ErrorAction SilentlyContinue).ProxyEnable
$ProxyOverride = (Get-ItemProperty "$RegistryPath\Proxy" -Name ProxyOverride -ErrorAction SilentlyContinue).ProxyOverride
$UserAgent = (Get-ItemProperty "$RegistryPath\Proxy" -Name 'User Agent' -ErrorAction SilentlyContinue).'User Agent'

if ($AutoConfigURL) {
    Write-Host 'AutoConfigURL:                  ' -ForegroundColor Yellow -NoNewline
    Write-Host "$AutoConfigURL" -ForegroundColor Green
    Set-ItemProperty -Path $ProxyRegistryKey -Name AutoConfigURL -Value "$AutoConfigURL"
}
if ($ProxyServer) {
    Write-Host 'ProxyServer:                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$proxy_server" -ForegroundColor Green
    Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyServer -Value "$ProxyServer"
}
if ($ProxyEnable) {
    Write-Host 'ProxyEnable:                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ProxyEnable" -ForegroundColor Green
    Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyEnable -Value "$ProxyEnable"
}
if ($ProxyOverride) {
    Write-Host 'ProxyOverride:                  ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ProxyOverride" -ForegroundColor Green
    Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyOverride -Value "$ProxyOverride"
}
if ($UserAgent) {
    Write-Host 'User Agent:                     ' -ForegroundColor Yellow -NoNewline
    Write-Host "$UserAgent" -ForegroundColor Green
    Set-ItemProperty -Path $ProxyRegistryKey -Name 'User Agent' -Value "$UserAgent"
}

#### Delete registry keys
Remove-Item -Path "HKCU:\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$RegistryPath\Temp" -Recurse -Force -ErrorAction SilentlyContinue
if ($WSL_DISTRO_NAME -eq $WSL_DEFAULT_DISTRO) {
    Set-ItemProperty -Path "$RegistryPath" -Name WSL_DISTRO_NAME -Value ''
}

#### Delete scheduled tasks
Write-Host ''
Write-Host "Deleting Windows' scheduled tasks" -ForegroundColor Yellow -BackgroundColor DarkBlue
if ($ScheduledTaskDns) {
    Start-Process cmd -ArgumentList '/c', 'schtasks.exe', '/Delete', '/f', '/tn', "`"$ScheduledTaskDns`"" -Wait -NoNewWindow
}
if ($ScheduledTaskStart) {
    Start-Process cmd -ArgumentList '/c', 'schtasks.exe', '/Delete', '/f', '/tn', "`"$ScheduledTaskStart`"" -Wait -NoNewWindow
}
if ($ScheduledTaskShutdown) {
    Start-Process cmd -ArgumentList '/c', 'schtasks.exe', '/Delete', '/f', '/tn', "`"$ScheduledTaskShutdown`"" -Wait -NoNewWindow
}
if ($ScheduledTaskReboot) {
    Start-Process cmd -ArgumentList '/c', 'schtasks.exe', '/Delete', '/f', '/tn', "`"$ScheduledTaskReboot`"" -Wait -NoNewWindow
}

#### Killing some processes
if ($aYes -ne $DebugMode) {
    Write-Host ''
    Write-Host 'Stopping somes processes' -ForegroundColor Yellow -BackgroundColor DarkBlue
    $vcxsrv = Get-Process vcxsrv -ErrorAction SilentlyContinue
    if ($vcxsrv) {
        # try gracefully first
        $vcxsrv.CloseMainWindow()
        # kill after five seconds
        Sleep 5
        if (!$vcxsrv.HasExited) {
            $vcxsrv | Stop-Process -Force | Out-Null
        }
    }
    Set-Location -Path $WSlRootBinDir
}

#### WSL shutdown
Write-Host ''
Write-Host "Terminating '$WSL_DISTRO_NAME' distro" -ForegroundColor Yellow -BackgroundColor DarkBlue
Do {
    wsl.exe --terminate "${WSL_DISTRO_NAME}"
    Start-Sleep -Seconds 2
}Until(!(wsl.exe --list --running | Where-Object { $_.Replace("`0", "") -match "$WSL_DISTRO_NAME" }))
wsl.exe --list --verbose

#### Uninstall WSL distribution
Write-Host ''
Write-Host "Uninstalling '$WSL_DISTRO_NAME' distro, please wait" -ForegroundColor Yellow -BackgroundColor DarkBlue
Set-Location -Path $WSlRootBinDir
wsl.exe --unregister $WSL_DISTRO_NAME

#### Delete residual folders
Write-Host ''
Write-Host 'Cleaning' -ForegroundColor Yellow -BackgroundColor DarkBlue
$UserDesktop = [Environment]::GetFolderPath('Desktop')
if (Test-Path -Path "$UserDesktop\Terminator $DesktopShorcutName.lnk") {
    Remove-Item "$UserDesktop\Terminator $DesktopShorcutName.lnk" -ErrorAction SilentlyContinue
}
$UserStartup = [Environment]::GetFolderPath('Startup')
if (Test-Path -Path "$UserStartup\$WSL_DISTRO_NAME Pre-Start.lnk") {
    Remove-Item "$UserStartup\$WSL_DISTRO_NAME Pre-Start.lnk" -ErrorAction SilentlyContinue
}
if (Test-Path -Path "$UserStartup\$WSL_DISTRO_NAME lnk") {
    Remove-Item "$UserStartup\$WSL_DISTRO_NAME lnk" -ErrorAction SilentlyContinue
}
$UserPrograms = [Environment]::GetFolderPath('Programs')
if (Test-Path -Path "$UserPrograms\Orange\WSL\$WSL_DISTRO_NAME") {
    Remove-Item "$UserPrograms\Orange\WSL\$WSL_DISTRO_NAME" -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path -Path "$WIN_DISTRO_DIR\rootfs") {
    Remove-Item "$WIN_DISTRO_DIR\rootfs" -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path -Path "$WIN_DISTRO_DIR\temp") {
    Remove-Item "$WIN_DISTRO_DIR\temp" -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path -Path "$WIN_DISTRO_DIR\scripts") {
    Remove-Item "$WIN_DISTRO_DIR\scripts" -Recurse -Force -ErrorAction SilentlyContinue
}
# if (Test-Path -Path "$WIN_DISTRO_DIR\install") {
#     Remove-Item "$WIN_DISTRO_DIR\install" -Recurse -Force -ErrorAction SilentlyContinue
# }
if (Test-Path -Path "$WIN_DISTRO_DIR\bin") {
    Remove-Item "$WIN_DISTRO_DIR\bin" -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path -Path "$WIN_DISTRO_DIR\fsserver") {
    Remove-Item "$WIN_DISTRO_DIR\fsserver" -ErrorAction SilentlyContinue
}
Remove-Item "$WIN_DISTRO_DIR\*.lnk" -ErrorAction SilentlyContinue
Remove-Item "$WIN_DISTRO_DIR\*.vhdx" -ErrorAction SilentlyContinue
Remove-Item "$WIN_DISTRO_DIR\*.log" -ErrorAction SilentlyContinue

if ($aYes -eq $DebugMode) {
    Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
}
