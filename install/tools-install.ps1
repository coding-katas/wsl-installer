param (
    # Distro name
    [Parameter(Mandatory = $true)]
    [String]$WSL_DISTRO_NAME,
    # Install params
    [Parameter(Mandatory = $false)]
    [String]$DebugMode = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name DEBUG).DEBUG
)

# ######################################################################################################################

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

# #### Proxy
if (!(Get-Proxy)) {
    Write-Host 'No proxy configuration could be identified.' -ForegroundColor Magenta
    Write-Host

    Write-Host 'No functional configuration for the proxy was found.' -ForegroundColor DarkRed
    Write-Host 'The installation process will be stopped.' -ForegroundColor DarkRed
    Start-Sleep -Seconds 20
    Exit 1
}

# #### Git Portable
if (($GitPortable_PackageUrl) -And ($GitPortable_PackageName) -And ($GitPortable_DisplayName) -And ($GitPortable_MinorVersion) -And ($GitPortable_InstallDir)) {
    if (DownloadAndInstall `
            -DownloadFromUrl "$GitPortable_PackageUrl" `
            -SaveToPath "$GitPortable_FilePath" `
            -DisplayName "$GitPortable_DisplayName" `
            -MinorVersion "$GitPortable_MinorVersion" `
            -InstallDir "$GitPortable_InstallDir") {

        Set-ItemProperty -Path "$RegistryPath\Components" -Name "GitPortable_IsInstalled" -Value 'yes'
    }
}

# #### Visual Studio Code
if (($VScode_PackageUrl) -And ($VScode_PackageName) -And ($VScode_DisplayName)) {
    if (DownloadAndInstall `
            -DownloadFromUrl "$VScode_PackageUrl" `
            -SaveToPath "$VScode_FilePath" `
            -DisplayName "$VScode_DisplayName") {

        Set-ItemProperty -Path "$RegistryPath\Components" -Name "VScode_IsInstalled" -Value 'yes'
    }
    if (Test-Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" -PathType leaf) {
        if (!(Test-Path -Path "$WSlRootAppsDir\Microsoft VS Code\")) {
            New-Item -Path "$WSlRootAppsDir" -Name 'Microsoft VS Code' -ItemType 'directory' -Force -ErrorAction SilentlyContinue
        }
        Copy-Item -Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\*" -Destination "$WSlRootAppsDir\Microsoft VS Code\" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# #### Windows terminal
if (($VCLibsWindowsTerm_PackageUrl) -And ($VCLibsWindowsTerm_PackageName) -And ($VCLibsWindowsTerm_DisplayName) -And ($VCLibsWindowsTerm_MinorVersion)) {
    if (DownloadAndInstall `
            -DownloadFromUrl "$VCLibsWindowsTerm_PackageUrl" `
            -SaveToPath "$VCLibsWindowsTerm_FilePath" `
            -DisplayName "$VCLibsWindowsTerm_DisplayName" `
            -MinorVersion "$VCLibsWindowsTerm_MinorVersion") {

        Set-ItemProperty -Path "$RegistryPath\Components" -Name "VCLibsWindowsTerm_IsInstalled" -Value 'yes'
    }
}
if (($WindowsTerminal_PackageUrl) -And ($WindowsTerminal_PackageName) -And ($WindowsTerminal_DisplayName) -And ($WindowsTerminal_MinorVersion)) {
    if (DownloadAndInstall `
            -DownloadFromUrl "$WindowsTerminal_PackageUrl" `
            -SaveToPath "$WindowsTerminal_FilePath" `
            -DisplayName "$WindowsTerminal_DisplayName" `
            -MinorVersion "$WindowsTerminal_MinorVersion") {

        Set-ItemProperty -Path "$RegistryPath\Components" -Name "WindowsTerminal_IsInstalled" -Value 'yes'
    }
}

# #### JetBrains
if ($USER_PROFILE.ToLower() -match 'dev') {
    if (($JetBrainsToolbox_PackageUrl) -And ($JetBrainsToolbox_FilePath) -And ($JetBrainsToolbox_DisplayName)) {
        if (DownloadAndInstall `
                -DownloadFromUrl "$JetBrainsToolbox_PackageUrl" `
                -SaveToPath "$JetBrainsToolbox_FilePath" `
                -DisplayName "$JetBrainsToolbox_DisplayName") {

            Set-ItemProperty -Path "$RegistryPath\Components" -Name "VCLibsWindowsTerm_IsInstalled" -Value 'yes'
        }
    }
}
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
