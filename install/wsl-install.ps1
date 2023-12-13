param (
    # Distro name
    [Parameter(Mandatory = $true)]
    [String]$WSL_DISTRO_NAME,
    # Install params
    [Parameter(Mandatory = $false)]
    [String]$DebugMode = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name DEBUG).DEBUG,
    # Get proxy ?
    [Parameter(Mandatory = $false)]
    [String]$GetProxy = 'true'
)

# ######################################################################################################################

#### Global variables
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$ScriptName = $MyInvocation.MyCommand.Name
$LogFile = "$ScriptDirectory\$ScriptName.log"
$WslIsUpToDate = $false

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

# Logging start
$error[0] | Format-List * -Force | Out-Null
$Logging = Start-Transcript -Path "$LogFile" -Append

# ######################################################################################################################

#### Stop all WSL distro for avoid network conflicts
Write-Host ''
Write-Host "Stopping all WSL distros to avoid network conflicts" -ForegroundColor Yellow -BackgroundColor DarkBlue
WslShutdown

#### Create registry path and keys
if (!(Test-Path 'Registry::HKCU\SOFTWARE\Orange')) {
    Write-Host ''
    Write-Host 'Creating Windows registry path and keys' -ForegroundColor Yellow -BackgroundColor DarkBlue
    Set-ItemProperty -Path 'Registry::HKCU\SOFTWARE\Orange' -Name WSL -Value ''
    Set-ItemProperty -Path "$RegistryPath" -Name WSL_FILENAME -Value ''
}

#### Proxy
if ($GetProxy -eq 'true') {
    if (!(Get-Proxy)) {
        Write-Host 'No proxy configuration could be identified.' -ForegroundColor Magenta
        Write-Host

        Write-Host 'No functional configuration for the proxy was found.' -ForegroundColor DarkRed
        Write-Host 'The installation process will be stopped.' -ForegroundColor DarkRed
        Start-Sleep -Seconds 20
        Exit 1
    }
}

#### WSL update
Write-Host ''
Write-Host 'Checking WSL version' -ForegroundColor Yellow -BackgroundColor DarkBlue
$WslAllVersions = (wsl.exe --version) | Where-Object { $_.Replace("`0", "") }
if (!($WslAllVersions | Where-Object { $_.Replace("`0", "") -match "$WslVersionMustContains" })) {
    Write-Host "The 'wsl.exe --version' command does not contain the string '$WslVersionMustContains'." -ForegroundColor Magenta
    Write-Host "The current version of WSL is not recent enough." -ForegroundColor Magenta
    Write-Host "The latest stable version '$MicrosoftWsl_StableVersion' of WSL will be installed." -ForegroundColor Magenta
}
else {
    $WslVersion = (($WslAllVersions -split '\n')[0] -split ':')[1].Replace("`0", "").Trim()

    if (WslVersionsCompare -WslMinimal $MicrosoftWsl_MinorVersion -WslCurrent $WslVersion) {
        $WslIsUpToDate = $true
        Set-ItemProperty -Path "$RegistryPath\Components" -Name 'MicrosoftWsl_IsInstalled' -Value 'yes'
        Set-ItemProperty -Path "$RegistryPath" -Name WSL_FILENAME -Value "$MicrosoftWsl_FilePath"
        $WslAllVersions
        Write-Host "The current WSL version '$WslVersion' is up to date." -ForegroundColor DarkGreen
    }
}

if (!($WslIsUpToDate) `
        -And ($aYes -ne $MicrosoftWsl_IsInstalled) -And ($MicrosoftWsl_PackageUrl) -And ($MicrosoftWsl_FilePath) `
        -And ($MicrosoftWsl_DisplayName) -And ($MicrosoftWsl_StableVersion)) {

    if (DownloadAndInstall `
            -DownloadFromUrl "$MicrosoftWsl_PackageUrl" `
            -SaveToPath "$MicrosoftWsl_FilePath" `
            -DisplayName "$MicrosoftWsl_DisplayName" `
            -MinorVersion "$MicrosoftWsl_StableVersion") {

        WslShutdown

        # Need to reboot before continue ?
        $WslError = (wsl.exe --list --running) | Where-Object { $_.Replace("`0", "") }
        $WslAllVersions = (wsl.exe --version) | Where-Object { $_.Replace("`0", "") }
        if (
            ($WslError | Where-Object { $_.Replace("`0", "") -match 'error code' }) -Or `
            (!($WslAllVersions | Where-Object { $_.Replace("`0", "") -match "$WslVersionMustContains" }))
        ) {
            Set-ItemProperty -Path "$RegistryPath" -Name 'RestartRequired' -Value 'yes'
            Write-Host 'You need to restart your computer to validate the WSL installation.' -ForegroundColor DarkYellow
            Write-Host 'You can then restart the LSW installation.' -ForegroundColor DarkYellow
            Start-Sleep -Seconds 20
        }

        if ((Get-ItemProperty "$RegistryPath" -Name RestartRequired).RestartRequired -eq 'yes') {
            $WslIsUpToDate = $true
        }
        else {
            $WslAllVersions = (wsl.exe --version) | Where-Object { $_.Replace("`0", "") }
            if (!($WslAllVersions | Where-Object { $_.Replace("`0", "") -match "$WslVersionMustContains" })) {
                Set-ItemProperty -Path "$RegistryPath" -Name 'RestartRequired' -Value 'yes'

                Write-Host "The 'wsl.exe --version' command does not contain the string '$WslVersionMustContains'." -ForegroundColor Magenta
                Write-Host "The current version of WSL is not recent enough." -ForegroundColor Magenta
                Write-Host "The latest stable version '$MicrosoftWsl_StableVersion' of WSL will be installed." -ForegroundColor Magenta
            }
            else {
                $WslVersion = (($WslAllVersions -split '\n')[0] -split ':')[1].Replace("`0", "").Trim()

                if (WslVersionsCompare -WslMinimal $MicrosoftWsl_MinorVersion -WslCurrent $WslVersion) {
                    $WslIsUpToDate = $true
                    Set-ItemProperty -Path "$RegistryPath\Components" -Name 'MicrosoftWsl_IsInstalled' -Value 'yes'
                    $WslAllVersions
                    Write-Host "The current WSL version '$WslVersion' is up to date." -ForegroundColor DarkGreen
                }
            }
        }
    }
}

# if (!($WslIsUpToDate)) {
#     Write-Host ''
#     Write-Host 'Updating Microsoft Windows Subsystem Linux using latest Microsoft Store version' -ForegroundColor Yellow -BackgroundColor DarkBlue
#     Write-Host 'Command: ' -ForegroundColor Yellow -NoNewline
#     Write-Host "wsl.exe --update" -ForegroundColor Green

#     wsl.exe --update

#     WslShutdown

#     $WslAllVersions = (wsl.exe --version) | Where-Object { $_.Replace("`0", "") }
#     if ($WslAllVersions | Where-Object { $_.Replace("`0", "") -match "$WslVersionMustContains" }) {
#         $WslVersion = (($WslAllVersions -split '\n')[0] -split ':')[1].Replace("`0", "").Trim()

#         if (WslVersionsCompare -WslMinimal $MicrosoftWsl_MinorVersion -WslCurrent $WslVersion) {
#             $WslIsUpToDate = $true
#             Set-ItemProperty -Path "$RegistryPath\Components" -Name 'MicrosoftWsl_IsInstalled' -Value 'yes'
#             $WslAllVersions
#             Write-Host "The current WSL version '$WslVersion' is up to date." -ForegroundColor DarkGreen
#         }
#     }
# }

# if (!($WslIsUpToDate)) {
#     Write-Host ''
#     Write-Host 'Updating Microsoft Windows Subsystem Linux using latest GitHub version' -ForegroundColor Yellow -BackgroundColor DarkBlue
#     Write-Host 'Command: ' -ForegroundColor Yellow -NoNewline
#     Write-Host "wsl.exe --update --web-download" -ForegroundColor Green

#     wsl.exe --update --web-download

#     WslShutdown

#     $WslAllVersions = (wsl.exe --version) | Where-Object { $_.Replace("`0", "") }
#     if ($WslAllVersions | Where-Object { $_.Replace("`0", "") -match "$WslVersionMustContains" }) {
#         $WslVersion = (($WslAllVersions -split '\n')[0] -split ':')[1].Replace("`0", "").Trim()

#         if (WslVersionsCompare -WslMinimal $MicrosoftWsl_MinorVersion -WslCurrent $WslVersion) {
#             $WslIsUpToDate = $true
#             Set-ItemProperty -Path "$RegistryPath\Components" -Name 'MicrosoftWsl_IsInstalled' -Value 'yes'
#             $WslAllVersions
#             Write-Host "The current WSL version '$WslVersion' is up to date." -ForegroundColor DarkGreen
#         }
#     }
# }

if (!($WslIsUpToDate)) {
    Write-Host 'It is not possible to update WSL from the Microsoft Store' -ForegroundColor DarkRed
    Write-Host 'WSL must be installed/activated manually in order to install LSW.' -ForegroundColor DarkRed
    Write-Host 'Please restart the installation of LSW once WSL has been activated.' -ForegroundColor DarkRed
    Start-Sleep -Seconds 20
    Exit 1
}

Start-Sleep -Seconds 5

# ######################################################################################################################

# }
# catch {
#     Write-Host 'Error occured' -ForegroundColor DarkRed
#     Write-Warning "$_"

#     # Logging stop
#     if ($Logging) {
#         Clear-Variable Logging
#         Stop-Transcript
#     }
# }

# Logging stop
if ($Logging) { Stop-Transcript }

if ($aYes -eq $DebugMode) {
    Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
}
