param (
    [Parameter(Mandatory = $true)]
    [String]$WSL_DISTRO_NAME,
    [Parameter(Mandatory = $false)]
    [String]$DebugMode = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -Name DEBUG).DEBUG,
    [Parameter(Mandatory = $false)]
    [String]$WSL_VERSION = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -Name WSL_VERSION).WSL_VERSION
)

#### Global variables
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$ScriptName = $MyInvocation.MyCommand.Name
$LogFile = "$ScriptDirectory\$ScriptName.log"

Write-Host ''
Write-Host 'Variables' -ForegroundColor Yellow -BackgroundColor DarkBlue
Write-Host 'ScriptDirectory:                ' -ForegroundColor Yellow -NoNewline
Write-Host "$ScriptDirectory" -ForegroundColor Green
Write-Host 'ScriptName:                     ' -ForegroundColor Yellow -NoNewline
Write-Host "$ScriptName" -ForegroundColor Green
Write-Host 'LogFile:                        ' -ForegroundColor Yellow -NoNewline
Write-Host "$LogFile" -ForegroundColor Green
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
$PwsQuickEditExe = ((Get-ItemProperty "$RegistryPath" -Name WslRootDir).WslRootDir) + "\bin\PwsQuickEdit.exe"
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

# Logging start
$error[0] | Format-List * -Force | Out-Null
$Logging = Start-Transcript -Path "$LogFile" -Append
$ExitCode = 0

# ######################################################################################################################

#### Microsoft Windows Subsystem Linux
# Disable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart
Write-Host ''
Write-Host 'Activating Windows Optional Feature Windows Subsystem Linux' -ForegroundColor Yellow -BackgroundColor DarkBlue
$WSL_Status = (Get-ItemProperty "$RegistryPath\Windows Functionalities" -Name 'Microsoft Windows Subsystem Linux' -ErrorAction SilentlyContinue).'Microsoft Windows Subsystem Linux'
$wsl_feature_state = Get-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux'
if (($WSL_Status -ne 'Enabled') -And ($wsl_feature_state.State -eq "Enabled")) {
    $wsl_feature_state
    Write-Host "Windows Optional Feature Windows Subsystem Linux is already enabled" -ForegroundColor Green
}
else {
    if ($wsl_feature_state = Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All -NoRestart) {
        Set-Variable -Name 'RestartRequired' -Value 'yes'
        $wsl_feature_state
        Write-Host "Windows Optional Feature Windows Subsystem Linux is now enabled" -ForegroundColor Green
    }
    else {
        $ExitCode = $ExitCode + 2
        Write-Host 'Activating Windows Optional Feature Windows Subsystem Linux failed' -ForegroundColor DarkRed
        $wsl_feature_state
    }

    $wsl_feature_state = Get-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux'
}
Set-ItemProperty -Path "$RegistryPath\Windows Functionalities" -Name 'Microsoft Windows Subsystem Linux' -Value $wsl_feature_state.State

#### Virtual Machine feature for WSL 2
# Disable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -NoRestart
if ($WSL_VERSION -eq 2) {
    Write-Host ''
    Write-Host 'Activating Virtual Machine Platform for WSL 2' -ForegroundColor Yellow -BackgroundColor DarkBlue
    $VMP_Status = (Get-ItemProperty "$RegistryPath\Windows Functionalities" -Name 'Microsoft Virtual Machine Platform' -ErrorAction SilentlyContinue).'Microsoft Virtual Machine Platform'
    $vmp_feature_state = Get-WindowsOptionalFeature -Online -FeatureName 'VirtualMachinePlatform'
    if (($VMP_Status -ne 'Enabled') -And ($vmp_feature_state.State -eq "Enabled")) {
        $vmp_feature_state
        Write-Host "Virtual Machine Platform for WSL 2 is already enabled" -ForegroundColor Green
    }
    else {
        if ($vmp_feature_state = Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -All -NoRestart) {
            Set-Variable -Name 'RestartRequired' -Value 'yes'
            $vmp_feature_state
            Write-Host "Virtual Machine Platform for WSL 2 is now enabled" -ForegroundColor Green
        }
        else {
            $ExitCode = $ExitCode + 4
            Write-Host 'Activating Virtual Machine Platform for WSL 2 failed' -ForegroundColor DarkRed
            $vmp_feature_state
        }
    }
    $vmp_feature_state = Get-WindowsOptionalFeature -Online -FeatureName 'VirtualMachinePlatform'
    Set-ItemProperty -Path "$RegistryPath\Windows Functionalities" -Name 'Microsoft Virtual Machine Platform' -Value $vmp_feature_state.State
}

#### Installation of WSL for the admin user to unlock certain situations with the current user.
#### In some cases, it may not be possible to deploy WSL for the current user. To resolve this, you must first deploy WSL for the admin user.
if (!(."$ScriptDirectory\wsl-install.ps1" -WSL_DISTRO_NAME $WSL_DISTRO_NAME -GetProxy 'false')) {
    $ExitCode = $ExitCode + 8
}
else {
    Set-Variable -Name 'RestartRequired' -Value (Get-ItemProperty "$RegistryPath" -Name RestartRequired).RestartRequired
}

#### Uninstall Windows OpenSSH Client
Write-Host ''
Write-Host 'Uninstalling the Windows OpenSSH Client' -ForegroundColor Yellow -BackgroundColor DarkBlue
Remove-WindowsCapability -Name "OpenSSH.Client~~~~0.0.1.0" -Online

# ######################################################################################################################

# Logging stop
if ($Logging) { Stop-Transcript }

if ($ExitCode -ne 0) {
    Write-Host "Activation of some components failed (error $ExitCode)" -ForegroundColor DarkRed
    Write-Host "The installation of LSW does not continue." -ForegroundColor DarkRed
}
else {
    if ($aYes -eq $RestartRequired) {
        Set-ItemProperty -Path "$RegistryPath" -Name 'RestartRequired' -Value 'yes'
    }
}

if ($aYes -eq $DebugMode) {
    Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
}

exit $ExitCode
