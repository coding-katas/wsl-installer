#### Functions
function Wait-For() {
    param(
        [Parameter(Mandatory = $true)]
        [Int]$Seconds
    )

    $doneDT = (Get-Date).AddSeconds($Seconds)
    while ($doneDT -gt (Get-Date)) {
        $SecondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $Percent = ($Seconds - $SecondsLeft) / $Seconds * 100
        Write-Progress -Activity 'Sleeping' -Status 'Sleeping...' -SecondsRemaining $SecondsLeft -PercentComplete $Percent
        [System.Threading.Thread]::Sleep(500)
    }
    Write-Progress -Activity 'Sleeping' -Status 'Sleeping...' -SecondsRemaining 0 -Completed
}

function Show-Message {
    param (
        [string]$Message = 'Veuillez entrer votre message',
        [string]$Titre = 'Titre de la fenêtre',
        [switch]$OKCancel,
        [switch]$AbortRetryIgnore,
        [switch]$YesNoCancel,
        [switch]$YesNo,
        [switch]$RetryCancel,
        [switch]$IconErreur,
        [switch]$IconQuestion,
        [switch]$IconAvertissement,
        [switch]$IconInformation
    )

    # Affecter la valeur selon le type de boutons choisis
    if ($OKCancel) { $Btn = 1 }
    elseif ($AbortRetryIgnore) { $Btn = 2 }
    elseif ($YesNoCancel) { $Btn = 3 }
    elseif ($YesNo) { $Btn = 4 }
    elseif ($RetryCancel) { $Btn = 5 }
    else { $Btn = 0 }

    # Affecter la valeur pour l'icone
    if ($IconErreur) { $Icon = 16 }
    elseif ($IconQuestion) { $Icon = 32 }
    elseif ($IconAvertissement) { $Icon = 48 }
    elseif ($IconInformation) { $Icon = 64 }
    else { $Icon = 0 }


    # Charger la bibliotheque d'objets graphiques Windows.Forms
    [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null

    # Afficher la boite de dialogue et renvoyer la valeur de retour (bouton appuye)
    $Reponse = [System.Windows.Forms.MessageBox]::Show($Message, $Titre , $Btn, $Icon)
    Return $Reponse
}

function CheckVersion {
    param (
        [string]$FnRegistryPath,
        [string]$FnDisplayName,
        [string]$FnMinorVersion
    )

    Try {
        Write-Host ''
        Write-Host "Checking version for '$FnDisplayName'" -ForegroundColor Yellow -BackgroundColor DarkBlue

        $CurrentVersion = (Get-Software -DisplayName "$FnDisplayName" | Select-Object -Property DisplayVersion).DisplayVersion
        if (-not $CurrentVersion) {
            $CurrentVersion = (Get-ItemProperty "$FnRegistryPath\$FnDisplayName" -Name DisplayVersion -ErrorAction SilentlyContinue).DisplayVersion

            if (!($CurrentVersion)) {
                return $false
            }
        }

        if ($CurrentVersion) {
            if ([version]$CurrentVersion -lt [version]$FnMinorVersion) {
                Write-Host "$CurrentVersion is less than $FnMinorVersion" -ForegroundColor Magenta
                return $false
            }
            else {
                Write-Host "The installed version is greater than or equal to $FnMinorVersion" -ForegroundColor DarkGreen
                return $true
            }
        }
    }
    Catch [System.Management.Automation.ItemNotFoundException] {
        Write-Host 'Error occured' -ForegroundColor DarkRed
        Write-Warning "$_"
        $AreThereAnyErrors++
        return $True
    }
    return $False
}

function DownloadAndInstall {
    param (
        [Parameter(Mandatory = $true)]
        [string]$DownloadFromUrl,
        [Parameter(Mandatory = $true)]
        [string]$SaveToPath,
        [Parameter(Mandatory = $true)]
        [string]$DisplayName,
        [Parameter(Mandatory = $false)]
        [string]$MinorVersion,
        [Parameter(Mandatory = $false)]
        [string]$InstallDir
    )

    $PackageName = $SaveToPath | Split-Path -Leaf

    if (CheckVersion -FnRegistryPath "$RegistryPath" -FnDisplayName $DisplayName -FnMinorVersion $MinorVersion) {
        return $True
    }

    Write-Host "Installing $PackageName" -NoNewline -ForegroundColor Cyan
    Try {
        if (($PackageName.ToLower() -match 'microsoft.windowsterminal.*.msixbundle$') -Or ($PackageName.ToLower() -match 'microsoft.vclibs.*.appx$')) {
            Write-Host ' (msixbundle/appx package)' -ForegroundColor Cyan
            if (Test-Path "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -PathType leaf) {
                Write-Host "$SaveToPath is already installed" -ForegroundColor Green
                return $True
            }
            if (!(Test-Path -Path "$SaveToPath" -PathType Leaf) -Or (Get-Item "$SaveToPath").length -eq 0) {
                DownloadFile -DownloadFromUrl $DownloadFromUrl -SaveToPath $SaveToPath
            }

            Add-AppxPackage "$SaveToPath" -ErrorAction SilentlyContinue -ForceApplicationShutdown
            $result = Get-AppxPackage -Name ($DisplayName.Replace(' ', '.'))
            if (!($result) -And ($MinorVersion)) {
                $result = Get-AppxPackage -Name ($DisplayName.Replace(' ', '.') + '.' + $MinorVersion.Split('.')[0] + '*')
            }
            if (!($result)) {
                $result = Get-AppxPackage -Name ($DisplayName.Replace(' ', '.') + '*')
            }
            if ($result) {
                Write-Host "$SaveToPath installed" -ForegroundColor Green
                return $True
            }
            return $False
        }
        elseif (($PackageName.ToLower() -match 'microsoft.WSL.*.msixbundle$') -Or ($PackageName.ToLower() -match 'microsoft.vclibs.*.appx$')) {
            Write-Host ' (msixbundle/appx package)' -ForegroundColor Cyan
            if (($PackageName.ToLower() -match 'microsoft.vclibs.*.appx$') -And (Test-Path "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -PathType leaf)) {
                Write-Host "$SaveToPath is already installed" -ForegroundColor Green
                return $True
            }
            if (!(Test-Path -Path "$SaveToPath" -PathType Leaf) -Or (Get-Item "$SaveToPath").length -eq 0) {
                DownloadFile -DownloadFromUrl $DownloadFromUrl -SaveToPath $SaveToPath
            }

            Add-AppxPackage "$SaveToPath" -ErrorAction SilentlyContinue -ForceApplicationShutdown
            $result = Get-AppxPackage -Name ($DisplayName.Replace(' ', '.'))
            if (!($result) -And ($MinorVersion)) {
                $result = Get-AppxPackage -Name ($DisplayName.Replace(' ', '.') + '.' + $MinorVersion.Split('.')[0] + '*')
            }
            if (!($result)) {
                $result = Get-AppxPackage -Name ($DisplayName.Replace(' ', '.') + '*')
            }
            if ($result) {
                Write-Host "$SaveToPath installed" -ForegroundColor Green
                return $True
            }
            return $False
        }
        elseif ($PackageName.ToLower() -Match 'gitportable.exe') {
            Write-Host ' (EXE package)' -ForegroundColor Cyan
            if (Test-Path "$GitPortable_InstallDir\usr\bin\ssh.exe" -PathType leaf) {
                Write-Host "$SaveToPath is already installed" -ForegroundColor Green
                return $True
            }
            if (!(Test-Path -Path "$SaveToPath" -PathType Leaf) -Or (Get-Item "$SaveToPath").length -eq 0) {
                DownloadFile -DownloadFromUrl $DownloadFromUrl -SaveToPath $SaveToPath
            }

            ."$SaveToPath" -y -o "$InstallDir"

            if (Test-Path "$GitPortable_InstallDir\usr\bin\ssh.exe" -PathType leaf) {
                Write-Host "$SaveToPath installed" -ForegroundColor Green
                return $True
            }
            return $False
        }
        elseif (($PackageName.ToLower() -Match 'vscode-install') -Or ($PackageName.ToLower() -Match 'jetbrains')) {
            Write-Host ' (EXE package)' -ForegroundColor Cyan
            if ($PackageName -Match 'vscode-install') {
                if (Test-Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" -PathType leaf) {
                    Write-Host "$SaveToPath is already installed" -ForegroundColor Green
                    return $True
                }
            }
            if ($PackageName.ToLower() -Match 'jetbrains-toolbox') {
                if (Test-Path "$env:LOCALAPPDATA\JetBrains\Toolbox\bin\jetbrains-toolbox.exe" -PathType leaf) {
                    Write-Host "$SaveToPath is already installed" -ForegroundColor Green
                    return $True
                }
            }

            if (!(Test-Path -Path "$SaveToPath" -PathType Leaf) -Or (Get-Item "$SaveToPath").length -eq 0) {
                DownloadFile -DownloadFromUrl $DownloadFromUrl -SaveToPath $SaveToPath
            }

            Start-Process -Wait -FilePath "$SaveToPath" -ArgumentList '/SILENT /CLOSEAPPLICATIONS /NORESTARTAPPLICATIONS /MERGETASKS=!runcode' -NoNewWindow -ErrorAction SilentlyContinue

            if ($PackageName -Match 'vscode-install') {
                if (Test-Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" -PathType leaf) {
                    Write-Host "$SaveToPath installed" -ForegroundColor Green
                    return $True
                }
            }
            if ($PackageName -Match 'jetbrains-toolbox') {
                if (Test-Path "$env:LOCALAPPDATA\JetBrains\Toolbox\bin\jetbrains-toolbox.exe" -PathType leaf) {
                    Write-Host "$SaveToPath installed" -ForegroundColor Green
                    return $True
                }
            }
            return $False
        }
        elseif ($PackageName -match 'wsl_update_x64.msi$') {
            Write-Host ' (MSI package)' -ForegroundColor Cyan
            if (!(Test-Path -Path "$SaveToPath" -PathType Leaf) -Or (Get-Item "$SaveToPath").length -eq 0) {
                DownloadFile -DownloadFromUrl $DownloadFromUrl -SaveToPath $SaveToPath
            }

            if ((Start-Process "msiexec.exe" -ArgumentList "/i ""$SaveToPath"" /passive /log ""$ScriptDirectory\wsl-2-kernel.log""" -Wait -PassThru).ExitCode -eq 0) {
                Write-Host "$SaveToPath installed" -ForegroundColor Green
                return $True
            }
            else {
                $ExitCode = $ExitCode + 8
                Write-Host "$SaveToPath failed" -ForegroundColor DarkRed

                Set-ItemProperty -Path "$RegistryPath" -Name 'RestartNeeded' -Value 'yes'
            }
            return $False
        }
        else {
            Write-Host ' (EXE package)' -ForegroundColor Cyan
            Start-Process -Wait -FilePath cmd -ArgumentList '/c', "`"$SaveToPath`"" -ErrorAction SilentlyContinue
        }
    }
    Catch [System.Exception] {
        Write-Host 'Error occured' -ForegroundColor DarkRed
        Write-Warning "$_"
        $AreThereAnyErrors++
        return $False
    }
}

function DownloadFile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param(
        [Parameter(Mandatory = $true)]
        [String]$DownloadFromUrl,
        [Parameter(Mandatory = $false)]
        [String]$SaveToPath = (Join-Path $pwd.Path $DownloadFromUrl.SubString($DownloadFromUrl.LastIndexOf('/')))
    )

    begin {
        $Global:downloadComplete = $false
        $Global:DPCEventArgs = $false
        Register-ObjectEvent $global:WebClient DownloadFileCompleted `
            -ErrorAction SilentlyContinue `
            -SourceIdentifier WebClient.DownloadFileComplete `
            -Action { $Global:downloadComplete = $true } | Out-Null
        Register-ObjectEvent $global:WebClient DownloadProgressChanged `
            -ErrorAction SilentlyContinue `
            -SourceIdentifier WebClient.DownloadProgressChanged `
            -Action { $Global:DPCEventArgs = $EventArgs } | Out-Null
    }
    process {
        Write-Progress -Activity 'Downloading file' -Status $DownloadFromUrl
        $global:WebClient.DownloadFileAsync($DownloadFromUrl, $SaveToPath)

        Try {
            $cnt = 0
            $Maximum = 3
            do {
                $cnt++
                if (!(Test-Path -Path "$SaveToPath" -PathType Leaf) -Or (Get-Item "$SaveToPath").length -eq 0) {
                    while (!($Global:downloadComplete)) {
                        $pc = $Global:DPCEventArgs.ProgressPercentage
                        if ($null -ne $pc) {
                            Write-Progress -Activity 'Downloading file' -Status $DownloadFromUrl -PercentComplete $pc
                        }
                    }
                }
                else {
                    Break
                }
                Start-Sleep 3
            } while ($cnt -le $Maximum)
        }
        Catch [System.Net.WebException] {
            Write-Host 'Error occured' -ForegroundColor DarkRed
            Write-Warning "$_"
            $AreThereAnyErrors++
        }

        Write-Progress -Activity 'Downloading file' -Status $DownloadFromUrl -Completed
    }
    end {
        Unregister-Event -SourceIdentifier WebClient.DownloadProgressChanged
        Unregister-Event -SourceIdentifier WebClient.DownloadFileComplete
        $global:WebClient.Dispose()
        $Global:downloadComplete = $null
        $Global:DPCEventArgs = $null
        [GC]::Collect()
        if ((Test-Path -Path "$SaveToPath" -PathType Leaf) -And (Get-Item "$SaveToPath").length -gt 0) {
            Write-Host "File saved: $SaveToPath" -ForegroundColor Green
            return $True
        }
        else {
            Write-Host "Corrupted file: $SaveToPath" -ForegroundColor Magenta
            Remove-Item -Path "$SaveToPath" -Force
            return $False
        }
    }
}

function Get-Software {
    # https://powershell.one/code/5.html
    <#
        .SYNOPSIS
        Reads installed software from registry

        .PARAMETER DisplayName
        Name or part of name of the software you are looking for

        .EXAMPLE
        Get-Software -DisplayName *Office*
        returns all software with "Office" anywhere in its name
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
    param(
        # emit only software that matches the value you submit:
        [string]$DisplayName = '*'
    )


    #region define friendly texts:
    $Scopes = @{
        HKLM = 'All Users'
        HKCU = 'Current User'
    }

    $Architectures = @{
        $true  = '32-Bit'
        $false = '64-Bit'
    }
    #endregion

    #region define calculated custom properties:
    # add the scope of the software based on whether the key is located
    # in HKLM: or HKCU:
    $Scope = @{
        Name       = 'Scope'
        Expression = {
            $Scopes[$_.PSDrive.Name]
        }
    }

    # add architecture (32- or 64-bit) based on whether the registry key
    # contains the parent key WOW6432Node:
    $Architecture = @{
        Name       = 'Architecture'
        Expression = { $Architectures[$_.PSParentPath -like '*\WOW6432Node\*'] }
    }
    #endregion

    #region define the properties (registry values) we are after
    # define the registry values that you want to include into the result:
    $Values = 'AuthorizedCDFPrefix',
    'Comments',
    'Contact',
    'DisplayName',
    'DisplayVersion',
    'EstimatedSize',
    'HelpLink',
    'HelpTelephone',
    'InstallDate',
    'InstallLocation',
    'InstallSource',
    'Language',
    'ModifyPath',
    'NoModify',
    'PSChildName',
    'PSDrive',
    'PSParentPath',
    'PSPath',
    'PSProvider',
    'Publisher',
    'Readme',
    'Size',
    'SystemComponent',
    'UninstallString',
    'URLInfoAbout',
    'URLUpdateInfo',
    'Version',
    'VersionMajor',
    'VersionMinor',
    'WindowsInstaller',
    'Scope',
    'Architecture'
    #endregion

    #region Define the VISIBLE properties
    # define the properties that should be visible by default
    # keep this below 5 to produce table output:
    [string[]]$visible = 'DisplayName', 'DisplayVersion', 'Scope', 'Architecture'
    [Management.Automation.PSMemberInfo[]]$visibleProperties = [System.Management.Automation.PSPropertySet]::new('DefaultDisplayPropertySet', $visible)
    #endregion

    #region read software from all four keys in Windows Registry:
    # read all four locations where software can be registered, and ignore non-existing keys:
    Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction Ignore |
    # exclude items with no DisplayName:
    Where-Object DisplayName |
    # include only items that match the user filter:
    Where-Object { $_.DisplayName -like $DisplayName } |
    # add the two calculated properties defined earlier:
    Select-Object -Property *, $Scope, $Architecture |
    # create final objects with all properties we want:
    Select-Object -Property $values |
    # sort by name, then scope, then architecture:
    Sort-Object -Property DisplayName, Scope, Architecture |
    # add the property PSStandardMembers so PowerShell knows which properties to
    # display by default:
    Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $visibleProperties -PassThru
    #endregion
}

function Wait-Retry-Command {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]$ScriptBlock,
        [Parameter(Position = 1, Mandatory = $false)]
        [int]$Maximum = 5,
        [Parameter(Position = 2, Mandatory = $false)]
        [int]$DelayInSeconds = 2,
        [Parameter(Position = 3, Mandatory = $false)]
        [string]$Message = 'Launching command'
    )

    Begin {
        $cnt = 0
    }

    Process {
        do {
            $cnt++
            Write-Host "$Message, attempt $cnt/$Maximum..." -ForegroundColor Yellow
            try {
                $ScriptBlock.Invoke()
                return
            }
            catch [System.Management.Automation.RuntimeException] {
                if ($_.Exception.Message.Contains("already been taken")) {
                    Write-Host -ForegroundColor DarkGreen "The SSH key already exists"
                    return
                }
            }
            catch {
                Write-Error $_.Exception.InnerException.Message -ErrorAction Continue
                Wait-For -Seconds $DelayInSeconds
            }
        } while ($cnt -lt $Maximum)
        $AreThereAnyErrors++

        # Throw an error after $Maximum unsuccessful invocations. Doesn't need
        # a condition, since the function returns upon successful invocation.
        throw 'Execution failed.'
    }
}

function Set-Proxy {
    Param(
        [Parameter(Mandatory = $false)]
        [string]$ProxyAuthentication,
        [Parameter(Mandatory = $false)]
        [pscredential]$SecuredCredentials,
        [Parameter(Mandatory = $false)]
        [bool]$DefaultCredentials = $false,
        [Parameter(Mandatory = $false)]
        [string]$ProxyServer,
        [Parameter(Mandatory = $false)]
        [string]$AutoConfigURL,
        [Parameter(Mandatory = $false)]
        [string]$ProxyEnable
    )

    if ($ProxyServer) {
        Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyServer -Value "$ProxyServer"
    }
    if ($AutoConfigURL) {
        Set-ItemProperty -Path $ProxyRegistryKey -Name AutoConfigURL -Value "$AutoConfigURL"
    }
    if ($ProxyEnable) {
        Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyEnable -Value $ProxyEnable
    }

    $PSDefaultParameterValues.Clear()
    $PSDefaultParameterValues.Add('Start-BitsTransfer:Proxy', "$Proxy")
    $PSDefaultParameterValues.Add('Start-BitsTransfer:ProxyAuthentication', "$ProxyAuthentication")
    $PSDefaultParameterValues.Add('Start-BitsTransfer:Authentication', "$ProxyAuthentication") # Basic / NTLM / ...
    $PSDefaultParameterValues.Add('Start-BitsTransfer:ProxyCredential', $SecuredCredentials)
    $PSDefaultParameterValues.Add('Start-BitsTransfer:ProxyUseDefaultCredentials', $DefaultCredentials)
    $PSDefaultParameterValues.Add('Start-BitsTransfer:ProxyUsage', 'SystemDefault') # SystemDefault / NoProxy / AutoDetect / Override

    $Proxy = [System.Net.WebRequest]::GetSystemWebProxy()
    $Proxy.Credentials = $SecuredCredentials
    $global:WebClient = New-Object System.Net.WebClient
    $global:WebClient.Proxy = $Proxy
}

function Get-Proxy {
    Write-Host ''
    Write-Host "Checking proxy configuration" -ForegroundColor Yellow -BackgroundColor DarkBlue

    # Backup current proxy configuration
    $AutoConfigURL = (Get-ItemProperty "$ProxyRegistryKey" -Name AutoConfigURL -ErrorAction SilentlyContinue).AutoConfigURL
    $ProxyServer = (Get-ItemProperty "$ProxyRegistryKey" -Name ProxyServer -ErrorAction SilentlyContinue).ProxyServer
    $ProxyEnable = (Get-ItemProperty "$ProxyRegistryKey" -Name ProxyEnable -ErrorAction SilentlyContinue).ProxyEnable
    $ProxyOverride = (Get-ItemProperty "$ProxyRegistryKey" -Name ProxyOverride -ErrorAction SilentlyContinue).ProxyOverride
    $UserAgent = (Get-ItemProperty "$ProxyRegistryKey" -Name 'User Agent' -ErrorAction SilentlyContinue).'User Agent'

    if (!(Get-ItemProperty -Path "$RegistryPath\Proxy" -ErrorAction SilentlyContinue)) {
        New-Item -Path "$RegistryPath\Proxy" -ErrorAction SilentlyContinue
    }
    Set-ItemProperty -Path "$RegistryPath\Proxy" -Name AutoConfigURL -Value "$AutoConfigURL"
    Set-ItemProperty -Path "$RegistryPath\Proxy" -Name ProxyServer -Value "$ProxyServer"
    Set-ItemProperty -Path "$RegistryPath\Proxy" -Name ProxyEnable -Value "$ProxyEnable"
    Set-ItemProperty -Path "$RegistryPath\Proxy" -Name ProxyOverride -Value "$ProxyOverride"
    Set-ItemProperty -Path "$RegistryPath\Proxy" -Name 'User Agent' -Value "$UserAgent"

    # Whithout changes
    Write-Host ''

    Set-Proxy -DefaultCredentials $true

    Write-Host 'AutoConfigURL:                  ' -ForegroundColor Yellow -NoNewline
    Write-Host "$AutoConfigURL" -ForegroundColor Green
    Write-Host 'ProxyServer:                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ProxyServer" -ForegroundColor Green
    Write-Host 'ProxyEnable:                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ProxyEnable" -ForegroundColor Green
    Write-Host 'ProxyOverride:                  ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ProxyOverride" -ForegroundColor Green
    Write-Host 'UserAgent:                      ' -ForegroundColor Yellow -NoNewline
    Write-Host "$UserAgent" -ForegroundColor Green
    Write-Host 'SecuredCredentialsAd:           ' -ForegroundColor Yellow -NoNewline
    Write-Host "$SecuredCredentialsAd" -ForegroundColor Green
    Write-Host 'SecuredCredentialsLdap:         ' -ForegroundColor Yellow -NoNewline
    Write-Host "$SecuredCredentialsLdap" -ForegroundColor Green
    Write-Host 'PSDefaultParameterValues:       ' -ForegroundColor Yellow
    $PSDefaultParameterValues.GetEnumerator() | ForEach-Object {
        Write-Host "    -> $($_.Key): $($_.Value)" -ForegroundColor Yellow
    }

    $proxy_validated = $true
    foreach ($test_url in $aProxyTestUrl) {
        Write-Host 'Checking access: ' -ForegroundColor Yellow -NoNewline
        Try {
            $global:WebClient.DownloadString("$test_url")
            Write-Host "$test_url" -ForegroundColor Green
        }
        Catch [System.Management.Automation.MethodInvocationException] {
            Write-Host "$test_url" -ForegroundColor Red
            if ($aYes -eq $DebugMode) {
                Write-Warning "$($error[0])"
            }
            $proxy_validated = $false
        }
    }

    if ($proxy_validated) {
        Write-Host ''
        Write-Host 'The current proxy configuration is suitable' -ForegroundColor Green

        Set-ItemProperty -Path "$RegistryPath" -Name PROXY_USER_AUTHENTICATION -Value 'dns'
        wsl.exe --distribution "$WSL_DISTRO_NAME" --user root -- /bin/bash -c "
cat <<EOT >/etc/profile.d/lsw-proxy.sh
export PROXY_USER_AUTHENTICATION='dns'
EOT"

        return $true;
    }

    if (($aYes -eq $USER_HAS_LDAP) -And ($SecuredCredentialsLdap)) {
        Write-Host 'The current proxy configuration is not suitable, trying with LDAP authentication' -ForegroundColor Magenta

        Set-Proxy -ProxyAuthentication 'Basic' -SecuredCredentials $SecuredCredentialsLdap

        Write-Host ''
        Write-Host 'AutoConfigURL:                  ' -ForegroundColor Yellow -NoNewline
        Write-Host "$AutoConfigURL" -ForegroundColor Green
        Write-Host 'ProxyServer:                    ' -ForegroundColor Yellow -NoNewline
        Write-Host "$proxy_server" -ForegroundColor Green
        Write-Host 'ProxyEnable:                    ' -ForegroundColor Yellow -NoNewline
        Write-Host "$ProxyEnable" -ForegroundColor Green
        Write-Host 'Authentication:                 ' -ForegroundColor Yellow -NoNewline
        Write-Host "LDAP (Basic)" -ForegroundColor Green
        Write-Host 'PSDefaultParameterValues:       ' -ForegroundColor Yellow
        $PSDefaultParameterValues.GetEnumerator() | ForEach-Object {
            Write-Host "    -> $($_.Key): $($_.Value)" -ForegroundColor Yellow
        }

        $proxy_validated = $true
        foreach ($test_url in $aProxyTestUrl) {
            Write-Host 'Checking access: ' -ForegroundColor Yellow -NoNewline
            Try {
                $global:WebClient.DownloadString("$test_url")
                Write-Host "$test_url" -ForegroundColor Green
            }
            Catch [System.Management.Automation.MethodInvocationException] {
                Write-Host "$test_url" -ForegroundColor Red
                if ($aYes -eq $DebugMode) {
                    Write-Warning "$($error[0])"
                }
                $proxy_validated = $false
            }
        }

        if ($proxy_validated) {
            Set-ItemProperty -Path "$RegistryPath" -Name PROXY_USER_AUTHENTICATION -Value 'dns'
            wsl.exe --distribution "$WSL_DISTRO_NAME" --user root -- /bin/bash -c "
cat <<EOT >/etc/profile.d/lsw-proxy.sh
export PROXY_USER_AUTHENTICATION='dns'
EOT"


            return $true;
        }
    }

    Write-Host ''
    Write-Host 'The current proxy configuration is not suitable with LDAP authentication, trying without proxy' -ForegroundColor Magenta

    # Without proxy
    $AutoConfigURL = ''
    $ProxyServer = ''
    $ProxyEnable = 0
    Set-ItemProperty -Path $ProxyRegistryKey -Name AutoConfigURL -Value "$AutoConfigURL"
    Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyServer -Value "$ProxyServer"
    Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyEnable -Value $ProxyEnable

    $global:WebClient = New-Object System.Net.WebClient
    $PSDefaultParameterValues.Clear()
    $PSDefaultParameterValues.Add('*:ProxyUsage', 'NoProxy')

    Write-Host ''
    Write-Host 'AutoConfigURL:                  ' -ForegroundColor Yellow -NoNewline
    Write-Host "$AutoConfigURL" -ForegroundColor Green
    Write-Host 'ProxyServer:                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ProxyServer" -ForegroundColor Green
    Write-Host 'ProxyEnable:                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ProxyEnable" -ForegroundColor Green
    Write-Host 'PSDefaultParameterValues:       ' -ForegroundColor Yellow
    $PSDefaultParameterValues.GetEnumerator() | ForEach-Object {
        Write-Host "    -> $($_.Key): $($_.Value)" -ForegroundColor Yellow
    }

    $proxy_validated = $true
    foreach ($test_url in $aProxyTestUrl) {
        Write-Host 'Checking access: ' -ForegroundColor Yellow -NoNewline
        Try {
            $global:WebClient.DownloadString("$test_url")
            Write-Host "$test_url" -ForegroundColor Green
        }
        Catch [System.Management.Automation.MethodInvocationException] {
            Write-Host "$test_url" -ForegroundColor Red
            if ($aYes -eq $DebugMode) {
                Write-Warning "$($error[0])"
            }
            $proxy_validated = $false
        }
    }

    if ($proxy_validated) {
        Set-ItemProperty -Path "$RegistryPath" -Name PROXY_USER_AUTHENTICATION -Value 'dns'
        wsl.exe --distribution "$WSL_DISTRO_NAME" --user root -- /bin/bash -c "
cat <<EOT >/etc/profile.d/lsw-proxy.sh
export PROXY_USER_AUTHENTICATION='dns'
EOT"

        return $true;
    }

    Write-Host ''
    Write-Host 'The no proxy configuration is not suitable, trying all proxy servers' -ForegroundColor Magenta

    # With proxy
    $AutoConfigURL = ''
    $ProxyServer = ''
    $ProxyEnable = 1
    foreach ($proxy_server in $aProxyServers) {
        $ProxyServer = "$proxy_server"
        $AutoConfigURL = "$ProxyPacNtlm"
        $ProxySecuredCredentials = $SecuredCredentialsAd
        $ProxyAuthentication = 'NTLM'
        $cntlm_user_authentication = 'group'
        $authentication = 'CUID'

        if (($aYes -eq $USER_HAS_LDAP) -And ($SecuredCredentialsLdap)) {
            if ($proxy_server | Where-Object { $_.Replace("`0", "") -match "proxyhbx" }) {
                $AutoConfigURL = "$ProxyPacBasic"
                $ProxySecuredCredentials = $SecuredCredentialsLdap
                $ProxyAuthentication = 'LDAP'
                $cntlm_user_authentication = 'dns'
                $authentication = 'LDAP'
            }
        }

        Set-ItemProperty -Path $ProxyRegistryKey -Name AutoConfigURL -Value "$AutoConfigURL"
        Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyServer -Value "$ProxyServer"
        Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyEnable -Value $ProxyEnable

        Set-Proxy -ProxyAuthentication "$ProxyAuthentication" -SecuredCredentials $ProxySecuredCredentials

        Write-Host ''
        Write-Host 'AutoConfigURL:                  ' -ForegroundColor Yellow -NoNewline
        Write-Host "$AutoConfigURL" -ForegroundColor Green
        Write-Host 'ProxyServer:                    ' -ForegroundColor Yellow -NoNewline
        Write-Host "$ProxyServer" -ForegroundColor Green
        Write-Host 'ProxyEnable:                    ' -ForegroundColor Yellow -NoNewline
        Write-Host "$ProxyEnable" -ForegroundColor Green
        Write-Host 'Authentication:                 ' -ForegroundColor Yellow -NoNewline
        Write-Host "$ProxyAuthentication ($authentication)" -ForegroundColor Green
        Write-Host 'PSDefaultParameterValues:       ' -ForegroundColor Yellow
        $PSDefaultParameterValues.GetEnumerator() | ForEach-Object {
            Write-Host "    -> $($_.Key): $($_.Value)" -ForegroundColor Yellow
        }

        $proxy_validated = $true
        foreach ($test_url in $aProxyTestUrl) {
            Write-Host 'Checking access: ' -ForegroundColor Yellow -NoNewline
            Try {
                $global:WebClient.DownloadString("$test_url")
                Write-Host "$test_url" -ForegroundColor Green
            }
            Catch [System.Management.Automation.MethodInvocationException] {
                Write-Host "$test_url" -ForegroundColor Red
                if ($aYes -eq $DebugMode) {
                    Write-Warning "$($error[0])"
                }
                $proxy_validated = $false
            }
        }

        if ($proxy_validated) {
            Set-ItemProperty -Path "$RegistryPath" -Name PROXY_USER_AUTHENTICATION -Value "$cntlm_user_authentication"
            wsl.exe --distribution "$WSL_DISTRO_NAME" --user root -- /bin/bash -c "
cat <<EOT >/etc/profile.d/lsw-proxy.sh
export PROXY_USER_AUTHENTICATION='$cntlm_user_authentication'
EOT"

            return $true;
        }

        Write-Host 'The configuration is not suitable' -ForegroundColor Magenta
    }

    Write-Host ''
    Write-Host "Restoring user proxy configuration" -ForegroundColor Yellow -BackgroundColor DarkBlue

    $AutoConfigURL = (Get-ItemProperty "$RegistryPath\Proxy" -Name AutoConfigURL -ErrorAction SilentlyContinue).AutoConfigURL
    $ProxyServer = (Get-ItemProperty "$RegistryPath\Proxy" -Name ProxyServer -ErrorAction SilentlyContinue).ProxyServer
    $ProxyEnable = (Get-ItemProperty "$RegistryPath\Proxy" -Name ProxyEnable -ErrorAction SilentlyContinue).ProxyEnable
    $ProxyOverride = (Get-ItemProperty "$RegistryPath\Proxy" -Name ProxyOverride -ErrorAction SilentlyContinue).ProxyOverride
    $UserAgent = (Get-ItemProperty "$RegistryPath\Proxy" -Name 'User Agent' -ErrorAction SilentlyContinue).'User Agent'

    Write-Host 'AutoConfigURL:                  ' -ForegroundColor Yellow -NoNewline
    Write-Host "$AutoConfigURL" -ForegroundColor Green
    Write-Host 'ProxyServer:                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$proxy_server" -ForegroundColor Green
    Write-Host 'ProxyEnable:                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ProxyEnable" -ForegroundColor Green
    Write-Host 'ProxyOverride:                  ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ProxyOverride" -ForegroundColor Green
    Write-Host 'User Agent:                     ' -ForegroundColor Yellow -NoNewline
    Write-Host "$UserAgent" -ForegroundColor Green

    Set-ItemProperty -Path $ProxyRegistryKey -Name AutoConfigURL -Value "$AutoConfigURL"
    Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyServer -Value "$ProxyServer"
    Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyEnable -Value "$ProxyEnable"
    Set-ItemProperty -Path $ProxyRegistryKey -Name ProxyOverride -Value "$ProxyOverride"
    Set-ItemProperty -Path $ProxyRegistryKey -Name 'User Agent' -Value "$UserAgent"

    return $false;
}

function WslDistroConfigure {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '')]
    param()

    Write-Host ''
    Write-Host "Configuring of $WSL_DISTRO_NAME distro" -ForegroundColor Yellow -BackgroundColor DarkBlue
    Set-Location -Path $WSlDistroBinDir

    wsl.exe --distribution "$WSL_DISTRO_NAME" --user root -- /bin/bash -c "
cat <<EOT >/etc/profile.d/lsw-install.sh
export LSW_DIR='$LSW_DIR'
export USER_NAME='$USER_NAME'
export USER_GROUP='$USER_NAME'
export USER_HOME='/home/$USER_NAME'
export DEBFULLNAME='$DEBFULLNAME'
export DEBEMAIL='$DEBEMAIL'
export USER_PASSWORD='${USER_PASSWORD}'
export USER_PASSPHRASE='$USER_PASSPHRASE'
export WIN_USER_PASSWORD='$WIN_USER_PASSWORD'
export USER_PROFILE='$USER_PROFILE'
export INSTALL_MODE='$INSTALL_MODE'
export BRANCH_LSW_REPO='$BRANCH_LSW_REPO'
export WINDOWS_FQDN='$WINDOWS_FQDN'
export WSL_WANTED_VERSION='$WSL_VERSION'
export VDI_HOSTNAME='$VDI_HOSTNAME'
export VDI_IPADDRESS='$VDI_IPADDRESS'
export GITLAB_HOST='$GITLAB_HOST'
export GITLAB_PRIVATE_TOKEN_DIOD='$GITLAB_PRIVATE_TOKEN_DIOD'
export GITLAB_PRIVATE_TOKEN_SPIRIT='$GITLAB_PRIVATE_TOKEN_SPIRIT'
export USER_GITLAB_NAMESPACES='$USER_GITLAB_NAMESPACES'
export WIN_USERNAME='$WIN_USERNAME'
export SWARM_TENANT='$SWARM_TENANT'
export ENTITY_NAME='$ENTITY_NAME'
export ENTITY_NAME_LC='$ENTITY_NAME_LC'
export DOCKER='$DOCKER'
export GOLANG='$GOLANG'
export PHP='$PHP'
export NODEJS='$NODEJS'
export PYTHON='$PYTHON'
export PYTHON_PYENV='$PYTHON_PYENV'
export WSL_WINDOWS_PROXY='$WSL_WINDOWS_PROXY'
export CLOUD_FOUNDRY='$CLOUD_FOUNDRY'
export KUBERNETES='$KUBERNETES'
export PFC_WAMPAAS='$PFC_WAMPAAS'
export PFC_MERCURY='$PFC_MERCURY'
export PFC_RICKAASTLEY='$PFC_RICKAASTLEY'
export PFC_METALLIKAAS='$PFC_METALLIKAAS'
export PFC_PICAASSO='$PFC_PICAASSO'
export CHECKPACKAGES='$CHECKPACKAGES'
export TICKET_MANAGER='$TICKET_MANAGER'
export SHELL_DEFAULT='$SHELL_DEFAULT'
export LDAP_HOST='$LDAP_HOST'
export LDAP_BASE='$LDAP_BASE'
export BASTION_HOST='$BASTION_HOST'
export INSTALL_LSW_ON_VDI='$INSTALL_LSW_ON_VDI'
EOT"

    if (Get-Command 'WslDistroConfigureEntity' -ErrorAction SilentlyContinue) {
        #### Configure entity distro
        WslDistroConfigureEntity
    }
}

function WslShutdown {
    if ($aYes -eq $DebugMode) {
        return $true
    }

    if ($CurrentSessionIsAdmin) {
        wsl.exe --shutdown > $null 2> $null

        Start-Sleep -Seconds 2
        return $true
    }

    Set-Variable -Name 'aXservers' -Value @(
        'vcxsrv.exe',
        'x410.exe'
    )

    Write-Host 'WSL distros shutdown in progress ' -ForegroundColor Yellow -NoNewline
    Do {
        Write-Host '.' -ForegroundColor Yellow -NoNewline
        foreach ($xserver in $aXservers) {
            $nPid = (Get-Process | `
                    Where-Object { $_.Path -match "$xserver".Replace('/', '\\') } | `
                    Sort-Object -Property StartTime -Descending | `
                    Select-Object -First 1).Id
            if ($nPid) { Stop-Process -Id $nPid > $null }
        }
        wsl.exe --shutdown > $null 2> $null

        Start-Sleep -Seconds 2
    }Until(
        wsl.exe --list --running | Where-Object {
            (
                $_.Replace("`0", "") -match 'aucune distribution' -or
                $_.Replace("`0", "") -match 'no running distribution' -or
                $_.Replace("`0", "") -match '--help'
            )
        }
    )
    Write-Host '' -ForegroundColor Yellow
}


function WslVersionsCompare {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$WslMinimal,
        [Parameter(Mandatory = $true)]
        [string]$WslCurrent
    )

    $WslMinimal = New-Object -TypeName System.Version -ArgumentList $WslMinimal
    $WslCurrent = New-Object -TypeName System.Version -ArgumentList $WslCurrent

    if ([version]$WslCurrent -lt [version]$WslMinimal) {
        Write-Host "The current version '$WslCurrent' is less than minimal version '$WslMinimal'" -ForegroundColor Magenta
        return $false
    }

    Write-Host "The installed version '$WslCurrent' is greater than or equal to minimal version '$WslMinimal'" -ForegroundColor DarkGreen
    return $true
}
