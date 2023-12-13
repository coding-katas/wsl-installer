param (
    # Distro name
    [Parameter(Mandatory = $true)]
    [String]$WSL_DISTRO_NAME,
    # Install params
    [Parameter(Mandatory = $false)]
    [String]$DebugMode = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name DEBUG).DEBUG,
    # GitLab projects branches to use
    [Parameter(Mandatory = $false)]
    [String]$BRANCH_LSW_REPO = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name BRANCH_LSW_REPO).BRANCH_LSW_REPO,
    # Entity
    [Parameter(Mandatory = $false)]
    [String]$ENTITY_NAME = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name ENTITY_NAME).ENTITY_NAME,
    [Parameter(Mandatory = $false)]
    [String]$BRANCH_ENTITY_REPO = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name BRANCH_ENTITY_REPO).BRANCH_ENTITY_REPO,
    [Parameter(Mandatory = $false)]
    [String]$ENTITY_REPO_PATH = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name ENTITY_REPO_PATH).ENTITY_REPO_PATH,
    [Parameter(Mandatory = $false)]
    [String]$ENTITY_REPO_GITLAB_HOST = (Get-ItemProperty "Registry::HKCU\SOFTWARE\Orange\WSL\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name ENTITY_REPO_GITLAB_HOST).ENTITY_REPO_GITLAB_HOST
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

if ($aYes -ne $DebugMode) {
    Remove-Item -Path "$RegistryPath\Temp" -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path "$RegistryPath\Temp" -ErrorAction SilentlyContinue | Out-Null
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

if ($ENTITY_NAME) {
    try {
        if (Test-Path -Path "$ScriptDirectory\..\entities\$ENTITY_NAME_LC\builds\innosetup\install\01_variables.ps1" -PathType Leaf) {
            . ("$ScriptDirectory\..\entities\$ENTITY_NAME_LC\builds\innosetup\install\01_variables.ps1")
        }
        if (Test-Path -Path "$ScriptDirectory\..\entities\$ENTITY_NAME_LC\builds\innosetup\install\02_functions.ps1" -PathType Leaf) {
            . ("$ScriptDirectory\..\entities\$ENTITY_NAME_LC\builds\innosetup\install\02_functions.ps1")
        }
        Write-Host 'Entity:                         ' -ForegroundColor Yellow -NoNewline
        Write-Host "$ENTITY_NAME" -ForegroundColor Green
        if ($BRANCH_ENTITY_REPO) {
            Write-Host 'Entity repository branch:       ' -ForegroundColor Yellow -NoNewline
            Write-Host "$BRANCH_ENTITY_REPO" -ForegroundColor Green
        }
        if ($ENTITY_REPO_PATH) {
            Write-Host 'Entity repository path:         ' -ForegroundColor Yellow -NoNewline
            Write-Host "$ENTITY_REPO_PATH" -ForegroundColor Green
        }
        if ($ENTITY_REPO_GITLAB_HOST) {
            Write-Host 'Entity GitLab host:             ' -ForegroundColor Yellow -NoNewline
            Write-Host "$ENTITY_REPO_GITLAB_HOST" -ForegroundColor Green
        }
    }
    catch {
        Write-Host 'Error occured' -ForegroundColor DarkRed
        Write-Warning "$_"
    }
}

if ($aYes -eq $DebugMode) {
    Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
}

#### Create directories
if (!(Test-Path -Path $WindowsTemp)) {
    Write-Host ''
    Write-Host "Creating $MyProgramFiles\Windows\Temp directory" -ForegroundColor Yellow -BackgroundColor DarkBlue
    New-Item -Path $MyProgramFiles -Name 'Windows\Temp' -ItemType 'directory'
}
if (!(Test-Path -Path "$WIN_DISTRO_DIR\shortcuts")) {
    Write-Host ''
    Write-Host "Creating $WIN_DISTRO_DIR\shortcuts directory" -ForegroundColor Yellow -BackgroundColor DarkBlue
    New-Item -Path $WIN_DISTRO_DIR -Name 'shortcuts' -ItemType 'directory'
}

#### Create registry path and keys
if (!(Test-Path 'Registry::HKCU\SOFTWARE\Orange')) {
    Write-Host ''
    Write-Host 'Creating Windows registry path and keys' -ForegroundColor Yellow -BackgroundColor DarkBlue
    Set-ItemProperty -Path 'Registry::HKCU\SOFTWARE\Orange' -Name WSL -Value ''
}

#### Stop all WSL distro for avoid network conflicts
Write-Host ''
Write-Host "Stopping all WSL distros to avoid network conflicts" -ForegroundColor Yellow -BackgroundColor DarkBlue
WslShutdown

#### Proxy
if (!(Get-Proxy)) {
    Write-Host 'No proxy configuration could be identified.' -ForegroundColor Magenta
    Write-Host

    Write-Host 'No functional configuration for the proxy was found.' -ForegroundColor DarkRed
    Write-Host 'The installation process will be stopped.' -ForegroundColor DarkRed
    Start-Sleep -Seconds 20
    Exit 1
}

#### WSL-VPNkit image
Try {
    Write-Host ''
    Write-Host "Checking WSL-VPNkit archive" -ForegroundColor Yellow -BackgroundColor DarkBlue

    if (!(Test-Path -Path "$WslVpnkitTargzPath" -PathType Leaf) -Or (Get-Item "$WslVpnkitTargzPath").length -eq 0) {
        Write-Host "$WslVpnkitTargzPath not found, trying to find other WSL-VPNkit archive locally" -ForegroundColor Yellow

        $local_file = (Get-ChildItem ("$WslVpnkitTargzPath" | Split-Path -Parent) | Where-Object { $_.Name -match '^wsl-vpnkit_.*.tar.gz$' }).FullName
        if ($local_file) {
            $WslVpnkitTargzPath = $local_file
            Write-Host "WSL-VPNkit archive found: $WslVpnkitTargzPath" -ForegroundColor DarkGreen
        }
        else {
            Write-Host "No WSL-VPNkit archive found locally, try to download it" -ForegroundColor Yellow

            Write-Host ''
            Write-Host 'Downloading WSL-VPNkit archive' -ForegroundColor Yellow -BackgroundColor DarkBlue

            DownloadFile -DownloadFromUrl "$WslVpnKitTargzUrl" -SaveToPath "$WslVpnkitTargzPath"
        }
    }
    else {
        Write-Host "WSL-VPNkit archive found: $WslVpnkitTargzPath" -ForegroundColor DarkGreen
    }

    if (!(Test-Path -Path "$WslVpnkitTargzPath" -PathType Leaf) -Or (Get-Item "$WslVpnkitTargzPath").length -eq 0) {
        Write-Host 'Error occured' -ForegroundColor DarkRed
        Write-Warning "$_"
        $AreThereAnyErrors++
    }
}
Catch [System.Exception] {
    Write-Host 'Error occured' -ForegroundColor DarkRed
    Write-Warning "$_"
    $AreThereAnyErrors++
}
if ($AreThereAnyErrors -ne 0) {
    Write-Error 'Error encountered, script stopped'
    Write-Host 'The installation process will be stopped.' -ForegroundColor DarkRed
    Start-Sleep -Seconds 20
    Exit 1
}

#### WSL Distro image
Try {
    Write-Host ''
    Write-Host "Checking $WSL_DISTRO_NAME archive" -ForegroundColor Yellow -BackgroundColor DarkBlue

    if (!(Test-Path -Path $WslImageTargzPath -PathType Leaf) -Or (Get-Item "$WslImageTargzPath").length -eq 0) {
        Write-Host "$WslImageTargzPath not found, trying to find other WSL-VPNkit archive locally" -ForegroundColor Yellow

        $regex = '^' + $WSL_DISTRO_NAME.ToLower() + '-.*.tar.gz$'
        $local_file = (Get-ChildItem "$WSlRootFilesDir" | Where-Object { $_.Name -match "$regex" }).FullName
        if ($local_file) {
            $WslImageTargzPath = $local_file
            Write-Host "WSL-VPNkit archive found: $WslImageTargzPath" -ForegroundColor DarkGreen
        }
        else {
            Write-Host "No $WslImageTargzPath archive found locally, try to download it" -ForegroundColor Yellow

            Write-Host ''
            Write-Host 'Downloading RootFS archive' -ForegroundColor Yellow -BackgroundColor DarkBlue

            DownloadFile -DownloadFromUrl "$WslImageTargzUrl" -SaveToPath "$WslImageTargzPath"
        }
    }
    else {
        Write-Host "RootFS archive found: $WslImageTargzPath" -ForegroundColor DarkGreen
    }

    if (!(Test-Path -Path $WslImageTargzPath -PathType Leaf) -Or (Get-Item "$WslImageTargzPath").length -eq 0) {
        Write-Host 'Error occured' -ForegroundColor DarkRed
        Write-Warning "$_"
        $AreThereAnyErrors++
    }
}
Catch [System.Exception] {
    Write-Host 'Error occured' -ForegroundColor DarkRed
    Write-Warning "$_"
    $AreThereAnyErrors++
}

if ($AreThereAnyErrors -ne 0) {
    Write-Error 'Error encountered, script stopped'
    Write-Host 'The installation process will be stopped.' -ForegroundColor DarkRed
    Start-Sleep -Seconds 20
    Exit 1
}

#### Windows environment variables
Write-Host ''
Write-Host 'Editing Windows environment variables' -ForegroundColor Yellow -BackgroundColor DarkBlue

$CurrentTempValue = (Get-ItemProperty "Registry::HKCU\Environment" -ErrorAction SilentlyContinue -Name TEMP).TEMP
$CurrentTmpValue = (Get-ItemProperty "Registry::HKCU\Environment" -ErrorAction SilentlyContinue -Name TMP).TMP
if (($CurrentTempValue -ne $WindowsTemp) -Or ($CurrentTmpValue -ne $WindowsTemp)) {
    Set-Variable -Name 'RebootNeeded' -Value $true
}
[System.Environment]::SetEnvironmentVariable('WSL_ROOT_BIN', $WSlRootBinDir, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('TEMP', $WindowsTemp, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('TMP', $WindowsTemp, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('SSH_AUTH_SOCK', '%USERPROFILE%\.ssh\cyglockfile', [System.EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User) + ";$WSlRootBinDir;$GitPortable_InstallDir\bin;$GitPortable_InstallDir\usr\bin;" + 'C:\Windows\system32', [EnvironmentVariableTarget]::User)
# Clean Path
$CurrentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$SplittedPath = $CurrentPath -split ';'
$CleanedPath = $SplittedPath | Sort-Object -Unique
$NewPath = $CleanedPath -join ';'
[Environment]::SetEnvironmentVariable('Path', $NewPath, 'User')
Write-Host 'TEMP:           ' -ForegroundColor Yellow -NoNewline
Write-Host "$env:TEMP" -ForegroundColor Green
Write-Host 'TMP:            ' -ForegroundColor Yellow -NoNewline
Write-Host "$env:TMP" -ForegroundColor Green
Write-Host 'SSH_AUTH_SOCK:  ' -ForegroundColor Yellow -NoNewline
Write-Host "$env:SSH_AUTH_SOCK" -ForegroundColor Green
Write-Host 'PATH:           ' -ForegroundColor Yellow -NoNewline
Write-Host "$NewPath" -ForegroundColor Green

#### WSL-VPNkit
Write-Host ''
Write-Host "Installing WSL-VPNkit distro in $WslRootDir\distros\WSL-VPNkit" -ForegroundColor Yellow -BackgroundColor DarkBlue
Try {
    Write-Host "Expected WSL-VPNkit archive: $WslVpnkitTargzPath" -ForegroundColor Yellow

    if (!(wsl.exe --list | Where-Object { $_.Replace("`0", "") -match 'WSL-VPNkit' })) {
        Write-Host 'Please wait' -ForegroundColor Yellow
        wsl.exe --import WSL-VPNkit --version $WSL_VERSION "$WslRootDir\distros\WSL-VPNkit" "$WslVpnkitTargzPath"
        if ($?) {
            Write-Host 'done' -ForegroundColor DarkGreen
        }
        else {
            Write-Host "failed" -ForegroundColor DarkRed
            $AreThereAnyErrors++
        }
    }
    else {
        $VpnkitCurrentVersion = (wsl.exe -d WSL-VPNkit -- cat /app/version) -replace "`r`n", ""
        $VpnkitNewVersion = [regex]::matches($WSLVPNKIT_FILENAME, 'v[0-9]{1,}.[0-9]{1,}.[0-9]{1,}-r[0-9]{1,}.[0-9]{1,}.[0-9]{1,}').value

        if (!($WSLVPNKIT_FILENAME | Where-Object { $_.Replace("`0", "") -match "$VpnkitCurrentVersion" })) {
            Write-Host "WSL-VPNkit distro is installed with an oldest version '$VpnkitCurrentVersion'" -ForegroundColor Yellow
            Write-Host "Updating WSL-VPNkit distro to $VpnkitNewVersion" -ForegroundColor Yellow -BackgroundColor DarkBlue

            Write-Host 'Please wait ... ' -ForegroundColor Yellow -NoNewline
            wsl.exe --unregister WSL-VPNkit

            if (Test-Path -Path "$WslRootDir\distros\WSL-VPNkit") {
                Remove-Item "$WslRootDir\distros\WSL-VPNkit" -Recurse -Force | Out-Null
            }

            wsl.exe --import WSL-VPNkit --version $WSL_VERSION "$WslRootDir\distros\WSL-VPNkit" "$WslVpnkitTargzPath"
            if ($?) {
                Write-Host 'done' -ForegroundColor DarkGreen
            }
            else {
                Write-Host "failed" -ForegroundColor DarkRed
                $AreThereAnyErrors++
            }
        }

        Write-Host "WSL-VPNkit distro is already installed ($VpnkitCurrentVersion)" -ForegroundColor DarkGreen
    }
}
Catch [System.Exception] {
    Write-Host 'Error occured' -ForegroundColor DarkRed
    Write-Warning "$_"
    $AreThereAnyErrors++
}
if ($AreThereAnyErrors -ne 0) {
    Write-Error 'Error encountered, script stopped'
    Write-Host 'The installation process will be stopped.' -ForegroundColor DarkRed
    Start-Sleep -Seconds 20
    Exit 1
}

Write-Host ''
Write-Host "Starting WSL-VPNkit service" -ForegroundColor Yellow -BackgroundColor DarkBlue
if (!(wsl.exe -d WSL-VPNkit --cd /app service wsl-vpnkit status | Where-Object { $_.Replace("`0", "") -match 'is running' })) {
    wsl.exe -d WSL-VPNkit --cd /app service wsl-vpnkit restart
    wsl.exe -d WSL-VPNkit --cd /app service wsl-vpnkit status
}
else {
    wsl.exe -d WSL-VPNkit --cd /app service wsl-vpnkit status
    Write-Host "WSL-VPNkit service is already running" -ForegroundColor DarkGreen
}

#### WSL Distro
Write-Host ''
Write-Host "Installing $WSL_DISTRO_NAME distro in $WIN_DISTRO_DIR" -ForegroundColor Yellow -BackgroundColor DarkBlue
Try {
    Write-Host "Expected $WSL_DISTRO_NAME archive: $WslImageTargzPath" -ForegroundColor Yellow
    if (Test-Path -Path $WslImageTargzPath -PathType Leaf) {
        Write-Host 'Please wait' -ForegroundColor Yellow
        $IsInstalled = $false
        $Count = 0
        Do {
            Start-Sleep -Seconds 2
            wsl.exe --status > $null

            wsl.exe --version > $null

            wsl.exe --terminate "$WSL_DISTRO_NAME"  > $null

            wsl.exe --import "$WSL_DISTRO_NAME" --version $WSL_VERSION "$WIN_DISTRO_DIR" "$WslImageTargzPath"
            if ($?) {
                Write-Host 'done' -ForegroundColor DarkGreen
                $Count = 4
                $IsInstalled = $true
            }
            else {
                WslShutdown

                wsl.exe -d WSL-VPNkit --cd /app service wsl-vpnkit restart > $null
            }
        }Until($Count -le 4)

        if (!($IsInstalled)) {
            Write-Host "failed" -ForegroundColor DarkRed
            $AreThereAnyErrors++
        }
    }
    else {
        Write-Host "File '$WslImageTargzPath' not found" -ForegroundColor DarkRed
        $AreThereAnyErrors++
    }
}
Catch [System.Exception] {
    Write-Host 'Error occured' -ForegroundColor DarkRed
    Write-Warning "$_"
    $AreThereAnyErrors++
}

Write-Host ''
Write-Host "WSL distro" -ForegroundColor Yellow -BackgroundColor DarkBlue
wsl.exe --list --verbose

if ($aYes -eq $DebugMode) {
    Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
}

if ($AreThereAnyErrors -ne 0) {
    Write-Error 'Error encountered, script stopped'
    Write-Host 'The installation process will be stopped.' -ForegroundColor DarkRed
    Start-Sleep -Seconds 20
    Exit 1
}

# Creating a file to store the installation log
wsl.exe --distribution "$WSL_DISTRO_NAME" --user root -- /bin/bash -c "touch /opt/lsw-install.log; chmod 777 /opt/lsw-install.log"

# Delete unused files & directories created during RootFS builds
wsl.exe --distribution "$WSL_DISTRO_NAME" --user root -- /bin/bash -c 'rm -rfv /.dockerenv /install /etc/orange/* /scripts /home/jdoe/.ssh/* | tee -a /opt/lsw-install.log'

#### Configure distro
WslDistroConfigure

# 03_create_user.sh
Write-Host ''
Write-Host "Activating user '$USER_NAME'" -ForegroundColor Yellow -BackgroundColor DarkBlue
wsl.exe --distribution "$WSL_DISTRO_NAME" --user root -- /bin/bash -c "bash '/mnt/c/My Program Files/WSL/distros/$WSL_DISTRO_NAME/install/03_create_user.sh' | tee -a /opt/lsw-install.log"

if ($aYes -ne $DebugMode) {
    Write-Host ''
    Write-Host "Terminating '$WSL_DISTRO_NAME' distro" -ForegroundColor Yellow -BackgroundColor DarkBlue
    Do {
        wsl.exe --terminate "$WSL_DISTRO_NAME"
        Start-Sleep -Seconds 2
    }Until(!(wsl.exe --list --running | Where-Object { $_.Replace("`0", "") -match "$WSL_DISTRO_NAME" }))
    wsl.exe --list --verbose
}

# 04_environment.sh
Write-Host ''
Write-Host "Preparing WSL environment for $WSL_DISTRO_NAME" -ForegroundColor Yellow -BackgroundColor DarkBlue
Try {
    wsl.exe --distribution "$WSL_DISTRO_NAME" --user $USER_NAME -- /bin/bash -c "sudo -E '/mnt/c/My Program Files/WSL/distros/$WSL_DISTRO_NAME/install/04_environment.sh' | tee -a /opt/lsw-install.log"
}
Catch [System.Exception] {
    Write-Host 'Error occured' -ForegroundColor DarkRed
    Write-Warning "$_"
    $AreThereAnyErrors++
}

if ($aYes -eq $DebugMode) {
    Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
}

# 05_ssh_key.sh
Write-Host ''
Write-Host "Creating a new SSH key for '$USER_NAME'" -ForegroundColor Yellow -BackgroundColor DarkBlue
wsl.exe --distribution "$WSL_DISTRO_NAME" --user $USER_NAME -- /bin/bash -c "sudo -E '/mnt/c/My Program Files/WSL/distros/$WSL_DISTRO_NAME/install/05_ssh_key.sh' | tee -a /opt/lsw-install.log"

if ($aYes -eq $DebugMode) {
    Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
}

#### Proxy
if (!(Get-Proxy)) {
    Write-Host 'No proxy configuration could be identified.' -ForegroundColor Magenta
    Write-Host

    Write-Host 'No functional configuration for the proxy was found.' -ForegroundColor DarkRed
    Write-Host 'The installation process will be stopped.' -ForegroundColor DarkRed
    Start-Sleep -Seconds 20
    Write-Host 'The installation process will be stopped.' -ForegroundColor DarkRed
    Start-Sleep -Seconds 20
    Exit 1
}

#### SSH key
Write-Host ''
Write-Host 'Adding the SSH key on GitLab' -ForegroundColor Yellow -BackgroundColor DarkBlue
# Get keys:     curl --request GET --header "PRIVATE-TOKEN: <private_token>" "https://gitlab.tech.orange/api/v4/user/keys"
# Delete key:   curl --request DELETE --header "PRIVATE-TOKEN: <private_token>" "https://gitlab.tech.orange/api/v4/user/keys/:key_id"
# Add key:      curl --request POST --header "PRIVATE-TOKEN: <private_token>" "https://gitlab.tech.orange/api/v4/user/keys"
#                   - title (required) - new SSH key’s title
#                   - key (required) - new SSH key
#                   - expires_at (optional) - The expiration date of the SSH key in ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ)
$SshKeyPath = "$WIN_DISTRO_DIR\rootfs\home\$USER_NAME\.ssh\id_rsa.pub"
if ($WSL_VERSION -eq 2) {
    $SshKeyPath = "\\wsl$\$WSL_DISTRO_NAME\home\$USER_NAME\.ssh\id_rsa.pub"
}
if ([System.IO.File]::Exists($SshKeyPath)) {
    $SshKeyPub = Get-Content "$SshKeyPath"
    Set-ItemProperty -Path "$RegistryPath\Temp" -Name 'UserSshKey' -Value "$SshKeyPub"
}
else {
    $SshKeyPub = (Get-ItemProperty "$RegistryPath\Temp" -ErrorAction SilentlyContinue -Name UserSshKey).UserSshKey
}

# Get all keys and delete all previous temporary_key keys
if ($SshKeyPub) {
    Set-Variable -Name 'aGITLAB_HOSTS' -Value @(
        'gitlab.tech.orange'
    )
    if ($GITLAB_HOST -eq 'gitlab.si.francetelecom.fr') {
        $aGITLAB_HOSTS += 'gitlab.si.francetelecom.fr'
    }

    foreach ($gitlab_host in $aGITLAB_HOSTS) {
        switch ($gitlab_host) {
            'gitlab.si.francetelecom.fr' {
                $Headers = @{'PRIVATE-TOKEN' = "$GITLAB_PRIVATE_TOKEN_SPIRIT" }
            }
            default {
                $Headers = @{'PRIVATE-TOKEN' = "$GITLAB_PRIVATE_TOKEN_DIOD" }
            }
        }

        Try {
            $all_keys = Wait-Retry-Command -ScriptBlock {
                Invoke-RestMethod -Uri https://$gitlab_host/api/v4/user/keys -Method Get -Headers $Headers
            } -Maximum 10 -Delay 5 -Message "Getting all SSH keys from '$gitlab_host'"

            foreach ($key in $all_keys) {
                if (($($key.title) -eq 'temporary_key') -Or ($($key.title) -Match "$DEBEMAIL - [0-9]{1,}.[0-9]{1,}.[0-9]{1,}")) {
                    Wait-Retry-Command -ScriptBlock {
                        Invoke-RestMethod -Uri https://$gitlab_host/api/v4/user/keys/$($key.id) -Method Delete -Headers $Headers
                    } -Maximum 10 -Delay 5 -Message "Deleting oldest SSH key in '$gitlab_host'"
                }
            }
            # Add the new SSH key
            $body = @{
                title = "$DEBEMAIL - $LSW_VERSION"
                key   = "$SshKeyPub"
            }
            Wait-Retry-Command -ScriptBlock {
                Invoke-RestMethod -Uri https://$gitlab_host/api/v4/user/keys -Method Post -Headers $Headers -Body $body
            } -Maximum 10 -Delay 5 -Message "Adding the new SSH temporary key in '$gitlab_host'"
        }
        Catch [System.Exception] {
            Write-Host 'Error occured' -ForegroundColor DarkRed
            Write-Warning "$_"
            $AreThereAnyErrors++
        }
    }
}
else {
    Write-Warning 'Missing SSH key, aborting'
    $AreThereAnyErrors++
}
if ($AreThereAnyErrors -ne 0) {
    Write-Error 'Error encountered, script stopped'
    Write-Host 'The installation process will be stopped.' -ForegroundColor DarkRed
    Start-Sleep -Seconds 20
    Exit 1
}

if ($aYes -eq $DebugMode) {
    Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
}

#### DNS
Write-Host ''
Write-Host 'Getting current Windows DNS' -ForegroundColor Yellow -BackgroundColor DarkBlue
$current_dns = (netsh.exe interface ipv4 show dnsservers | Select-String -Pattern '\d{1,3}(\.\d{1,3}){3}' -AllMatches | Get-Unique).Matches.Value
Foreach ($dns in $current_dns) {
    Write-Host "$dns" -ForegroundColor Green
    if ($formated_dns) {
        $formated_dns = $formated_dns + ' ' + $dns
    }
    else {
        $formated_dns = $dns
    }
}
if ($formated_dns) {
    Set-ItemProperty -Path "$RegistryPath" -Name DNS -Value "$formated_dns"
}

# 06_clone_projects
Write-Host ''
Write-Host 'Cloning LSW project' -ForegroundColor Yellow -BackgroundColor DarkBlue
wsl.exe --distribution "$WSL_DISTRO_NAME" --user $USER_NAME -- /bin/bash -c "sudo -E '/mnt/c/My Program Files/WSL/distros/$WSL_DISTRO_NAME/install/06_clone_projects.sh' | tee -a /opt/lsw-install.log"

if ($aYes -eq $DebugMode) {
    Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
}

if ($aYes -ne $DebugMode) {
    Write-Host ''
    Write-Host "Terminating '$WSL_DISTRO_NAME' distro" -ForegroundColor Yellow -BackgroundColor DarkBlue
    Do {
        wsl.exe --terminate "$WSL_DISTRO_NAME"
        Start-Sleep -Seconds 2
    }Until(!(wsl.exe --list --running | Where-Object { $_.Replace("`0", "") -match "$WSL_DISTRO_NAME" }))
    wsl.exe --list --verbose
}

#### LSW install
if ($AreThereAnyErrors -eq 0) {
    Write-Host ''
    Write-Host "Starting installation of $WSL_DISTRO_NAME" -ForegroundColor Yellow -BackgroundColor DarkBlue
    wsl.exe --distribution "$WSL_DISTRO_NAME" --user $USER_NAME -- /bin/bash -c "sudo -E '$LSW_DIR/install/install.sh' | tee -a /opt/lsw-install.log"
}

#### Install LSW on VDI
if (($AreThereAnyErrors -eq 0) -And ($aYes -eq $INSTALL_LSW_ON_VDI)) {
    Write-Host ''
    Write-Host 'Starting LSW installation on VDI' -ForegroundColor Yellow -BackgroundColor DarkBlue
    if ($aYes -eq $DebugMode) {
        Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
    }
    wsl.exe --distribution "$WSL_DISTRO_NAME" --user $USER_NAME -- /bin/bash -c "sudo -E '/mnt/c/My Program Files/WSL/distros/$WSL_DISTRO_NAME/install/07_vdi.sh' | tee -a /opt/lsw-install.log"
}

#### Clean
Write-Host ''
Write-Host 'Cleaning' -ForegroundColor Yellow -BackgroundColor DarkBlue
Remove-Item "$WIN_DISTRO_DIR\install\*.sh" -Recurse -Force | Out-Null
Remove-Item "$WSlRootFilesDir\*.lock" -Recurse -Force | Out-Null
$aFilesToDeleteAfterInstall = @(
    "$WIN_DISTRO_DIR\install\00_install.ps1"
)
foreach ( $sFile in $aFilesToDeleteAfterInstall ) {
    if (Test-Path -Path "$sFile" -PathType Leaf) {
        Remove-Item "$sFile" -Force | Out-Null
    }
}
if ($aYes -ne $DebugMode) {
    Remove-Item -Path "$RegistryPath\Temp" -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path "$RegistryPath\Temp" -ErrorAction SilentlyContinue | Out-Null
}

$aDirsToDeleteAfterInstall = @(
    "$WIN_DISTRO_DIR\entities"
)
foreach ( $sDir in $aDirsToDeleteAfterInstall ) {
    if (Test-Path -Path "$sDir") {
        Remove-Item "$sDir" -Recurse -Force | Out-Null
    }
}
wsl.exe --distribution "$WSL_DISTRO_NAME" --user root -- /bin/bash -c 'rm -rfv /etc/sudoers.d/wsl-installation /etc/profile.d/lsw-*.sh /tmp/* | tee -a /opt/lsw-install.log'
wsl.exe --distribution "$WSL_DISTRO_NAME" --user root -- /bin/bash -c 'sed -i "/INSTALL_MODE/d;/CREATE_LOCAL_SSHKEY/d;/CREATE_BASTION_SSHKEY/d;" /etc/orange/user | tee -a /opt/lsw-install.log'

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
