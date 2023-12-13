# Global ###############################################################################################################

Set-Variable -Name 'RebootNeeded' -Value $false
Set-Variable -Name 'RegistryPath' -Value 'Registry::HKCU\SOFTWARE\Orange\WSL'
Set-Variable -Name 'MyProgramFiles' -Value 'C:\My Program Files'
Set-Variable -Name 'WindowsTemp' -Value "$MyProgramFiles\Windows\Temp"
Set-Variable -Name 'CurrentBuild' -Value (Get-ItemProperty 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuild -ErrorAction SilentlyContinue).CurrentBuild
Set-Variable -Name 'aYes' -Value @('yes', 'y', 'oui', 'o', 'true', 't', '1')
Set-Variable -Name 'aNo' -Value @('no', 'n', 'non', 'false', 'f', '0')

$CurrentSession = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
Set-Variable -Name 'CurrentSessionIsAdmin' -Value $CurrentSession.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Errors ?
Set-Variable -Name 'AreThereAnyErrors' -Value 0

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-variable?view=powershell-7.1
if (-not $WSL_DISTRO_NAME) {
    Set-Variable -Name 'WSL_DISTRO_NAME' -Value 'WSL-Ubuntu-20.04-PFC'
}
Write-Host 'WSL_DISTRO_NAME:                ' -ForegroundColor Yellow -NoNewline
Write-Host "$WSL_DISTRO_NAME" -ForegroundColor Green

Set-Variable -Name 'WINDOWS_FQDN' -Value ($env:COMPUTERNAME + "." + $env:USERDNSDOMAIN.ToLower())
Write-Host 'WINDOWS_FQDN:                   ' -ForegroundColor Yellow -NoNewline
Write-Host "$WINDOWS_FQDN" -ForegroundColor Green

# Orange ###############################################################################################################

if (-not $ENTITY_NAME) {
    Set-Variable -Name 'ENTITY_NAME' -Value 'PFC'
}
Set-Variable -Name 'ENTITY_NAME_LC' -Value "$ENTITY_NAME".ToLower()
Write-Host 'ENTITY_NAME:                    ' -ForegroundColor Yellow -NoNewline
Write-Host "$ENTITY_NAME ($ENTITY_NAME_LC)" -ForegroundColor Green

Set-Variable -Name 'BRANCH_LSW_REPO' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name BRANCH_LSW_REPO -ErrorAction SilentlyContinue).BRANCH_LSW_REPO
Write-Host 'BRANCH_LSW_REPO                 ' -ForegroundColor Yellow -NoNewline
Write-Host "$BRANCH_LSW_REPO" -ForegroundColor Green

If (($ScriptName -eq '00_install.ps1') -Or ($ScriptName -eq 'uninstall.ps1') -Or ($ScriptName -eq 'tools-install.ps1')) {
    Set-Variable -Name 'USER_PROFILE' -Value (Get-ItemProperty "$RegistryPath" -Name USER_PROFILE -ErrorAction SilentlyContinue).USER_PROFILE
    Write-Host 'USER_PROFILE:                   ' -ForegroundColor Yellow -NoNewline
    Write-Host "$USER_PROFILE" -ForegroundColor Green
}
If (($ScriptName -eq '00_install.ps1') -Or ($ScriptName -eq 'tools-install.ps1') -Or ($ScriptName -eq 'wsl-install.ps1')) {
    Set-Variable -Name 'USER_HAS_LDAP' -Value (Get-ItemProperty "$RegistryPath" -Name USER_HAS_LDAP -ErrorAction SilentlyContinue).USER_HAS_LDAP
    Write-Host 'USER_HAS_LDAP                   ' -ForegroundColor Yellow -NoNewline
    Write-Host "$USER_HAS_LDAP" -ForegroundColor Green
    Set-Variable -Name 'LDAP_HOST' -Value ''
    Set-Variable -Name 'LDAP_BASE' -Value ''
    if ($aYes -eq $USER_HAS_LDAP) {
        Set-Variable -Name 'LDAP_HOST' -Value (Get-ItemProperty "$RegistryPath" -Name LDAP_HOST -ErrorAction SilentlyContinue).LDAP_HOST
        Set-Variable -Name 'LDAP_BASE' -Value (Get-ItemProperty "$RegistryPath" -Name LDAP_BASE -ErrorAction SilentlyContinue).LDAP_BASE
        Write-Host 'LDAP_HOST                       ' -ForegroundColor Yellow -NoNewline
        Write-Host "$LDAP_HOST ($LDAP_BASE)" -ForegroundColor Green
    }

    Set-Variable -Name 'USER_HAS_BASTION' -Value (Get-ItemProperty "$RegistryPath" -Name USER_HAS_BASTION -ErrorAction SilentlyContinue).USER_HAS_BASTION
    Write-Host 'USER_HAS_BASTION                ' -ForegroundColor Yellow -NoNewline
    Write-Host "$USER_HAS_BASTION" -ForegroundColor Green
    Set-Variable -Name 'BASTION_HOST' -Value ''
    if ($aYes -eq $USER_HAS_LDAP) {
        Set-Variable -Name 'BASTION_HOST' -Value (Get-ItemProperty "$RegistryPath" -Name BASTION_HOST -ErrorAction SilentlyContinue).BASTION_HOST
        Write-Host 'BASTION_HOST                    ' -ForegroundColor Yellow -NoNewline
        Write-Host "$BASTION_HOST" -ForegroundColor Green
    }
}
If (($ScriptName -eq '00_install.ps1') -Or ($ScriptName -eq 'tools-install.ps1')) {
    Set-Variable -Name 'GITLAB_HOST' -Value (Get-ItemProperty "$RegistryPath" -Name GITLAB_HOST -ErrorAction SilentlyContinue).GITLAB_HOST
    Write-Host 'GITLAB_HOST                     ' -ForegroundColor Yellow -NoNewline
    Write-Host "$GITLAB_HOST" -ForegroundColor Green
}

# WSL Distro ###########################################################################################################

Set-Variable -Name 'WIN_DISTRO_DIR' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name WIN_DISTRO_DIR -ErrorAction SilentlyContinue).WIN_DISTRO_DIR
Write-Host 'WIN_DISTRO_DIR:                 ' -ForegroundColor Yellow -NoNewline
Write-Host "$WIN_DISTRO_DIR" -ForegroundColor Green

Set-Variable -Name 'WslRootDir' -Value (Get-ItemProperty "$RegistryPath" -Name WslRootDir -ErrorAction SilentlyContinue).WslRootDir
Set-Variable -Name 'WSlDistroInstallDir' -Value "$WIN_DISTRO_DIR\install"
Set-Variable -Name 'WSlDistroIconsDir' -Value "$WIN_DISTRO_DIR\icons"
Set-Variable -Name 'WSlRootBinDir' -Value "$WslRootDir\bin"
Set-Variable -Name 'WSlRootAppsDir' -Value "$WslRootDir\apps"
Set-Variable -Name 'WSlRootFilesDir' -Value "$WslRootDir\files"
if (!(Test-Path -Path $WSlRootFilesDir)) {
    $null = New-Item -Path "$WslRootDir" -Name 'files' -ItemType 'directory'
}
Set-Variable -Name 'WSlDistroBinDir' -Value "$WIN_DISTRO_DIR\bin"
Set-Variable -Name 'WSlDistroConfDir' -Value "$WIN_DISTRO_DIR\conf"
Set-Variable -Name 'WslIcoPath' -Value "$WSlDistroIconsDir\ubuntu.ico"
Set-Variable -Name 'DesktopShorcutName' -Value $WSL_DISTRO_NAME.Replace('-', ' ')

Set-Variable -Name 'DISTRO_VERSION' -Value ((Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name DISTRO_VERSION -ErrorAction SilentlyContinue).DISTRO_VERSION)
Write-Host 'DISTRO_VERSION:                 ' -ForegroundColor Yellow -NoNewline
Write-Host "$DISTRO_VERSION" -ForegroundColor Green

Set-Variable -Name 'WSL_VERSION' -Value ((Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name WSL_VERSION -ErrorAction SilentlyContinue).WSL_VERSION)
Write-Host 'WSL_VERSION                     ' -ForegroundColor Yellow -NoNewline
Write-Host "$WSL_VERSION" -ForegroundColor Green

Set-Variable -Name 'LSW_VERSION' -Value ((Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name LSW_VERSION -ErrorAction SilentlyContinue).LSW_VERSION)
Write-Host 'LSW_VERSION                     ' -ForegroundColor Yellow -NoNewline
Write-Host "$LSW_VERSION" -ForegroundColor Green

Set-Variable -Name 'ROOTFS_ORIGIN' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name ROOTFS_ORIGIN -ErrorAction SilentlyContinue).ROOTFS_ORIGIN
Write-Host 'ROOTFS_ORIGIN                   ' -ForegroundColor Yellow -NoNewline
Write-Host "$ROOTFS_ORIGIN" -ForegroundColor Green -NoNewline
if ($ROOTFS_ORIGIN -eq 'PFC Docker image') {
    Set-Variable -Name 'ROOTFS_ORIGIN' -Value 'docker'
}
elseif ($ROOTFS_ORIGIN -eq 'Ubuntu Cloud images') {
    Set-Variable -Name 'ROOTFS_ORIGIN' -Value 'cloudimg'
}
elseif ($ROOTFS_ORIGIN -eq 'PFC VDI template') {
    Set-Variable -Name 'ROOTFS_ORIGIN' -Value 'vdi'
}
else {
    Set-Variable -Name 'ROOTFS_ORIGIN' -Value 'docker'
}
Write-Host " ($ROOTFS_ORIGIN)" -ForegroundColor Green

Set-Variable -Name 'LSW_DIR' -Value '/opt/orange/lsw'
Write-Host 'LSW_DIR                         ' -ForegroundColor Yellow -NoNewline
Write-Host "$LSW_DIR" -ForegroundColor Green

# User info ############################################################################################################

If (($ScriptName -eq '00_install.ps1') -Or ($ScriptName -eq 'tools-install.ps1') -Or ($ScriptName -eq 'uninstall.ps1') -Or ($ScriptName -eq 'wsl-install.ps1')) {
    Set-Variable -Name 'DEBFULLNAME' -Value (Get-ItemProperty "$RegistryPath" -Name DEBFULLNAME -ErrorAction SilentlyContinue).DEBFULLNAME
    if (!($DEBFULLNAME)) {
        Set-Variable -Name 'DEBFULLNAME' -Value (Get-ItemProperty 'Registry::HKLM\SOFTWARE\e-buro' -Name LastUserName -ErrorAction SilentlyContinue).LastUserName
    }
    Write-Host 'DEBFULLNAME                     ' -ForegroundColor Yellow -NoNewline
    Write-Host "$DEBFULLNAME" -ForegroundColor Green

    Set-Variable -Name 'DEBEMAIL' -Value (Get-ItemProperty "$RegistryPath" -Name DEBEMAIL -ErrorAction SilentlyContinue).DEBEMAIL
    if (!($DEBEMAIL)) {
        Set-Variable -Name 'DEBEMAIL' -Value (Get-ItemProperty 'Registry::HKLM\SOFTWARE\e-buro' -Name LastUserEmail -ErrorAction SilentlyContinue).LastUserEmail
    }
    Write-Host 'DEBEMAIL                        ' -ForegroundColor Yellow -NoNewline
    Write-Host "$DEBEMAIL" -ForegroundColor Green

    Set-Variable -Name 'USER_HAS_VDI' -Value (Get-ItemProperty "$RegistryPath" -Name USER_HAS_VDI -ErrorAction SilentlyContinue).USER_HAS_VDI
    Write-Host 'USER_HAS_VDI                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$USER_HAS_VDI" -ForegroundColor Green

    Set-Variable -Name 'INSTALL_LSW_ON_VDI' -Value (Get-ItemProperty "$RegistryPath" -Name INSTALL_LSW_ON_VDI -ErrorAction SilentlyContinue).INSTALL_LSW_ON_VDI
    Write-Host 'INSTALL_LSW_ON_VDI              ' -ForegroundColor Yellow -NoNewline
    Write-Host "$INSTALL_LSW_ON_VDI" -ForegroundColor Green

    Set-Variable -Name 'VDI_HOSTNAME' -Value (Get-ItemProperty "$RegistryPath" -Name VDI_HOSTNAME -ErrorAction SilentlyContinue).VDI_HOSTNAME
    Set-Variable -Name 'VDI_IPADDRESS' -Value (Get-ItemProperty "$RegistryPath" -Name VDI_IPADDRESS -ErrorAction SilentlyContinue).VDI_IPADDRESS
    if ($VDI_HOSTNAME) {
        Write-Host 'VDI_HOSTNAME                    ' -ForegroundColor Yellow -NoNewline
        Write-Host "$VDI_HOSTNAME ($VDI_IPADDRESS)" -ForegroundColor Green
    }

    Set-Variable -Name 'USER_NAME' -Value (Get-ItemProperty "$RegistryPath" -Name USER_NAME -ErrorAction SilentlyContinue).USER_NAME
    Write-Host 'USER_NAME                       ' -ForegroundColor Yellow -NoNewline
    Write-Host "$USER_NAME" -ForegroundColor Green

    Set-Variable -Name 'WIN_USERNAME' -Value (Get-ItemProperty "$RegistryPath" -Name WIN_USERNAME -ErrorAction SilentlyContinue).WIN_USERNAME
    if (!($WIN_USERNAME)) {
        Set-Variable -Name 'WIN_USERNAME' -Value (Get-ItemProperty 'Registry::HKLM\SOFTWARE\e-buro' -Name LastUser -ErrorAction SilentlyContinue).LastUser
    }
    Write-Host 'WIN_USERNAME                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$WIN_USERNAME" -ForegroundColor Green

    Set-Variable -Name 'WSL_DEFAULT_DISTRO' -Value (Get-ItemProperty "$RegistryPath" -Name WSL_DEFAULT_DISTRO -ErrorAction SilentlyContinue).WSL_DEFAULT_DISTRO
    if ($WSL_DEFAULT_DISTRO) {
        Write-Host 'WSL_DEFAULT_DISTRO              ' -ForegroundColor Yellow -NoNewline
        Write-Host "$WSL_DEFAULT_DISTRO" -ForegroundColor Green
    }
}

If (($ScriptName -eq '00_install.ps1') -Or ($ScriptName -eq 'tools-install.ps1') -Or ($ScriptName -eq 'uninstall.ps1')) {
    Set-Variable -Name 'SHELL_DEFAULT' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name SHELL_DEFAULT -ErrorAction SilentlyContinue).SHELL_DEFAULT
    Write-Host 'SHELL_DEFAULT                   ' -ForegroundColor Yellow -NoNewline
    Write-Host "$SHELL_DEFAULT" -ForegroundColor Green

    Set-Variable -Name 'DOCKER' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name DOCKER -ErrorAction SilentlyContinue).DOCKER
    Write-Host 'DOCKER                          ' -ForegroundColor Yellow -NoNewline
    Write-Host "$DOCKER" -ForegroundColor Green

    Set-Variable -Name 'PYTHON' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name PYTHON -ErrorAction SilentlyContinue).PYTHON
    Write-Host 'PYTHON                          ' -ForegroundColor Yellow -NoNewline
    Write-Host "$PYTHON" -ForegroundColor Green

    Set-Variable -Name 'PYTHON_PYENV' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name PYTHON_PYENV -ErrorAction SilentlyContinue).PYTHON_PYENV
    Write-Host 'PYTHON_PYENV                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$PYTHON_PYENV" -ForegroundColor Green

    Set-Variable -Name 'GOLANG' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name GOLANG -ErrorAction SilentlyContinue).GOLANG
    Write-Host 'GOLANG                          ' -ForegroundColor Yellow -NoNewline
    Write-Host "$GOLANG" -ForegroundColor Green

    Set-Variable -Name 'PHP' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name PHP -ErrorAction SilentlyContinue).PHP
    Write-Host 'PHP                             ' -ForegroundColor Yellow -NoNewline
    Write-Host "$PHP" -ForegroundColor Green

    Set-Variable -Name 'NODEJS' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name NODEJS -ErrorAction SilentlyContinue).NODEJS
    Write-Host 'NODEJS                          ' -ForegroundColor Yellow -NoNewline
    Write-Host "$NODEJS" -ForegroundColor Green

    Set-Variable -Name 'WSL_WINDOWS_PROXY' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name WSL_WINDOWS_PROXY -ErrorAction SilentlyContinue).WSL_WINDOWS_PROXY
    Write-Host 'WSL_WINDOWS_PROXY               ' -ForegroundColor Yellow -NoNewline
    Write-Host "$WSL_WINDOWS_PROXY" -ForegroundColor Green

    Set-Variable -Name 'CLOUD_FOUNDRY' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name CLOUD_FOUNDRY -ErrorAction SilentlyContinue).CLOUD_FOUNDRY
    Write-Host 'CLOUD_FOUNDRY                   ' -ForegroundColor Yellow -NoNewline
    Write-Host "$CLOUD_FOUNDRY" -ForegroundColor Green

    Set-Variable -Name 'KUBERNETES' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name KUBERNETES -ErrorAction SilentlyContinue).KUBERNETES
    Write-Host 'KUBERNETES                      ' -ForegroundColor Yellow -NoNewline
    Write-Host "$KUBERNETES" -ForegroundColor Green

    Set-Variable -Name 'PFC_WAMPAAS' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name PFC_WAMPAAS -ErrorAction SilentlyContinue).PFC_WAMPAAS
    Write-Host 'PFC_WAMPAAS                     ' -ForegroundColor Yellow -NoNewline
    Write-Host "$PFC_WAMPAAS" -ForegroundColor Green

    Set-Variable -Name 'PFC_MERCURY' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name PFC_MERCURY -ErrorAction SilentlyContinue).PFC_MERCURY
    Write-Host 'PFC_MERCURY                     ' -ForegroundColor Yellow -NoNewline
    Write-Host "$PFC_MERCURY" -ForegroundColor Green

    Set-Variable -Name 'PFC_RICKAASTLEY' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name PFC_RICKAASTLEY -ErrorAction SilentlyContinue).PFC_RICKAASTLEY
    Write-Host 'PFC_RICKAASTLEY                 ' -ForegroundColor Yellow -NoNewline
    Write-Host "$PFC_RICKAASTLEY" -ForegroundColor Green

    Set-Variable -Name 'PFC_METALLIKAAS' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name PFC_METALLIKAAS -ErrorAction SilentlyContinue).PFC_METALLIKAAS
    Write-Host 'PFC_METALLIKAAS                 ' -ForegroundColor Yellow -NoNewline
    Write-Host "$PFC_METALLIKAAS" -ForegroundColor Green

    Set-Variable -Name 'PFC_PICAASSO' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name PFC_PICAASSO -ErrorAction SilentlyContinue).PFC_PICAASSO
    Write-Host 'PFC_PICAASSO                    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$PFC_PICAASSO" -ForegroundColor Green

    Set-Variable -Name 'CHECKPACKAGES' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name CHECKPACKAGES -ErrorAction SilentlyContinue).CHECKPACKAGES
    Write-Host 'CHECKPACKAGES                   ' -ForegroundColor Yellow -NoNewline
    Write-Host "$CHECKPACKAGES" -ForegroundColor Green

    Set-Variable -Name 'TICKET_MANAGER' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name TICKET_MANAGER -ErrorAction SilentlyContinue).TICKET_MANAGER
    Write-Host 'TICKET_MANAGER                  ' -ForegroundColor Yellow -NoNewline
    Write-Host "$TICKET_MANAGER" -ForegroundColor Green

    Set-Variable -Name 'SWARM_TENANT' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -Name SWARM_TENANT -ErrorAction SilentlyContinue).SWARM_TENANT
    if ($SWARM_TENANT) {
        Write-Host 'SWARM_TENANT                    ' -ForegroundColor Yellow -NoNewline
        Write-Host "$SWARM_TENANT" -ForegroundColor Green
    }

    Set-Variable -Name 'USER_GITLAB_NAMESPACES' -Value (Get-ItemProperty "$RegistryPath" -Name USER_GITLAB_NAMESPACES -ErrorAction SilentlyContinue).USER_GITLAB_NAMESPACES
    Write-Host 'USER_GITLAB_NAMESPACES          ' -ForegroundColor Yellow -NoNewline
    Write-Host "$USER_GITLAB_NAMESPACES" -ForegroundColor Green
}
If (($ScriptName -eq '00_install.ps1') -Or ($ScriptName -eq 'tools-install.ps1') -Or ($ScriptName -eq 'wsl-install.ps1')) {
    if (!($USER_PASSWORD)) {
        Set-Variable -Name 'USER_PASSWORD' -Value (Get-ItemProperty "$RegistryPath\Temp" -Name USER_PASSWORD -ErrorAction SilentlyContinue).USER_PASSWORD
    }
    if (!($WIN_USER_PASSWORD)) {
        Set-Variable -Name 'WIN_USER_PASSWORD' -Value (Get-ItemProperty "$RegistryPath\Temp" -Name WIN_USER_PASSWORD -ErrorAction SilentlyContinue).WIN_USER_PASSWORD
    }
    if ($USER_PASSWORD) {
        Set-Variable -Name 'SecuredCredentialsLdap' -Value (New-Object System.Management.Automation.PSCredential $USER_NAME, (ConvertTo-SecureString "$USER_PASSWORD" -AsPlainText -Force))
    }
    if ($WIN_USER_PASSWORD) {
        Set-Variable -Name 'SecuredCredentialsAd' -Value (New-Object System.Management.Automation.PSCredential "AD\$WIN_USERNAME", (ConvertTo-SecureString "$WIN_USER_PASSWORD" -AsPlainText -Force))
    }
    Set-Variable -Name 'USER_PASSPHRASE' -Value (Get-ItemProperty "$RegistryPath\Temp" -Name USER_PASSPHRASE -ErrorAction SilentlyContinue).USER_PASSPHRASE
}
If (($ScriptName -eq '00_install.ps1') -Or ($ScriptName -eq 'tools-install.ps1')) {
    Set-Variable -Name 'GITLAB_PRIVATE_TOKEN_DIOD' -Value (Get-ItemProperty "$RegistryPath\Temp" -Name GITLAB_PRIVATE_TOKEN_DIOD -ErrorAction SilentlyContinue).GITLAB_PRIVATE_TOKEN_DIOD
    Set-Variable -Name 'GITLAB_PRIVATE_TOKEN_SPIRIT' -Value (Get-ItemProperty "$RegistryPath\Temp" -Name GITLAB_PRIVATE_TOKEN_SPIRIT -ErrorAction SilentlyContinue).GITLAB_PRIVATE_TOKEN_SPIRIT
}

# AD Values
# $AdSearcher=[adsisearcher]"(sAMAccountName=$WIN_USERNAME)"
# $AdSearcher.SearchRoot="LDAP://$(([adsi]'').distinguishedName)"
# $AdSearcher.SearchRoot=$AdSearcher.FindOne().Path
# $Result = $AdSearcher.FindAll()
# $UserFirstName = (Get-Culture).TextInfo.ToTitleCase($Result.Properties.givenname)
# $UserLastName = $Result.Properties.sn.ToUpper()
# $DEBEMAIL = $Result.Properties.description

# Proxy settings #######################################################################################################

$PSDefaultParameterValues.Clear()
$global:WebClient = New-Object System.Net.WebClient
$global:WebClient.Headers['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:111.0) Gecko/20100101 Firefox/111.0';
Set-Variable -Name 'ProxyRegistryKey' -Value 'Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
Set-Variable -Name 'aProxyServers' -Value @(
    'proxyhbx.gtm.hbx.geo.francetelecom.fr:8080',
    'oppr5vdr1-prd01.si.fr.intraorange:8080',
    'oppr5vdr2-prd01.si.fr.intraorange:8080',
    'oppr5aub1-prd01.si.fr.intraorange:8080'
)
Set-Variable -Name 'ProxyPacNtlm' -Value 'http://proxypac.si.francetelecom.fr:8080'
Set-Variable -Name 'ProxyPacBasic' -Value 'https://proxy-pac-pfco365.app.cf.bgl.hbx.geo.francetelecom.fr/PFCo365.pac'
Set-Variable -Name 'aProxyTestUrl' -Value @(
    'https://github.com/about',
    'https://marketplace.visualstudio.com/',
    'https://gitlab.si.francetelecom.fr/',
    'https://gitlab.tech.orange/',
    'https://artifactory.si.francetelecom.fr/'
)

# Sofrecom
if ($env:USERDOMAIN.ToLower() -match "sofrecom") {
    Set-Variable -Name 'aProxyServers' -Value @(
        'proxyparfil.si.fr.intraorange:8080'
    )
    Set-Variable -Name 'ProxyPacNtlm' -Value 'http://proxypac.sofrecom.fr/wpad.dat'
    Set-Variable -Name 'ProxyPacBasic' -Value ''
}

# Setup ################################################################################################################

# Environment variables to sets in distro
if ($aYes -eq $DebugMode) {
    $INSTALL_MODE = '2'
}
else {
    $INSTALL_MODE = '1'
}
Write-Host 'INSTALL_MODE                    ' -ForegroundColor Yellow -NoNewline
Write-Host "$INSTALL_MODE" -ForegroundColor Green


# Others ###############################################################################################################

if (($WSL_VERSION -eq 2) -And ($ScriptName -eq 'uninstall.ps1')) {
    Set-Variable -Name 'ScheduledTaskDns' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name ScheduledTaskDns).ScheduledTaskDns
    Write-Host 'ScheduledTaskDns                ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ScheduledTaskDns" -ForegroundColor Green

    Set-Variable -Name 'ScheduledTaskStart' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name ScheduledTaskStart).ScheduledTaskStart
    Write-Host 'ScheduledTaskStart              ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ScheduledTaskStart" -ForegroundColor Green

    Set-Variable -Name 'ScheduledTaskShutdown' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name ScheduledTaskShutdown).ScheduledTaskShutdown
    Write-Host 'ScheduledTaskShutdown           ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ScheduledTaskShutdown" -ForegroundColor Green

    Set-Variable -Name 'ScheduledTaskReboot' -Value (Get-ItemProperty "$RegistryPath\Distros\$WSL_DISTRO_NAME" -ErrorAction SilentlyContinue -Name ScheduledTaskReboot).ScheduledTaskReboot
    Write-Host 'ScheduledTaskReboot             ' -ForegroundColor Yellow -NoNewline
    Write-Host "$ScheduledTaskReboot" -ForegroundColor Green
}

Set-Variable -Name 'WSLVPNKIT_FILENAME' -Value (Get-ItemProperty "$RegistryPath" -Name WSLVPNKIT_FILENAME -ErrorAction SilentlyContinue).WSLVPNKIT_FILENAME
Set-Variable -Name 'WslVpnkitTargzPath' -Value "$WSLVPNKIT_FILENAME"
Set-Variable -Name 'WslVpnKitTargzUrl' -Value ("https://artifactory.si.francetelecom.fr/artifactory/dom-oasis-generic/LSW/WSL/WSL-VPNkit/" + ($WSLVPNKIT_FILENAME | Split-Path -Leaf))
Write-Host 'WslVpnkitTargzPath              ' -ForegroundColor Yellow -NoNewline
Write-Host "$WslVpnkitTargzPath" -ForegroundColor Green

Set-Variable -Name 'WslImageTargzUrl' -Value "https://artifactory.si.francetelecom.fr/artifactory/dom-oasis-generic/LSW/RootFS/$BRANCH_LSW_REPO/wsl-ubuntu-$DISTRO_VERSION-$ENTITY_NAME_LC-$ROOTFS_ORIGIN.tar.gz"
Set-Variable -Name 'WslImageTargzPath' -Value ("$WSlRootFilesDir\" + ($WslImageTargzUrl | Split-Path -Leaf))
Write-Host 'WslImageTargzPath               ' -ForegroundColor Yellow -NoNewline
Write-Host "$WslImageTargzPath" -ForegroundColor Green

# Components ###########################################################################################################

If (($ScriptName -eq 'wsl-install.ps1') -Or ($ScriptName -eq 'run-as-admin.ps1')) {
    # WSL infos
    Set-Variable -Name 'MicrosoftWsl_DisplayName' -Value 'Microsoft MicrosoftWsl'
    Set-Variable -Name 'MicrosoftWsl_MinorVersion' -Value '1.2.5'
    Set-Variable -Name 'MicrosoftWsl_StableVersion' -Value '2.0.9'
    Set-Variable -Name 'MicrosoftWsl_PackageName' -Value "Microsoft.WSL_$MicrosoftWsl_StableVersion.0_x64_ARM64.msixbundle"
    Set-Variable -Name 'MicrosoftWsl_PackageUrl' -Value "https://artifactory.si.francetelecom.fr/dom-oasis-generic/LSW/WSL/Releases/$MicrosoftWsl_PackageName"
    Set-Variable -Name 'MicrosoftWsl_FilePath' -Value "$WSlRootFilesDir\$MicrosoftWsl_PackageName"
    Set-Variable -Name 'MicrosoftWsl_IsInstalled' -Value (Get-ItemProperty "$RegistryPath\Components" -Name MicrosoftWsl_IsInstalled -ErrorAction SilentlyContinue).MicrosoftWsl_IsInstalled
    Set-Variable -Name 'WslVersionMustContains' -Value 'WSLg'
    if (!($MicrosoftWsl_IsInstalled)) {
        Set-ItemProperty -Path "$RegistryPath\Components" -Name MicrosoftWsl_IsInstalled -Value 'no'
    }
    Write-Host 'MicrosoftWsl_DisplayName        ' -ForegroundColor Yellow -NoNewline
    Write-Host "$MicrosoftWsl_DisplayName" -ForegroundColor Green
    Write-Host 'MicrosoftWsl_MinorVersion       ' -ForegroundColor Yellow -NoNewline
    Write-Host "$MicrosoftWsl_MinorVersion" -ForegroundColor Green
    Write-Host 'MicrosoftWsl_StableVersion      ' -ForegroundColor Yellow -NoNewline
    Write-Host "$MicrosoftWsl_StableVersion" -ForegroundColor Green
    Write-Host 'MicrosoftWsl_PackageName        ' -ForegroundColor Yellow -NoNewline
    Write-Host "$MicrosoftWsl_PackageName" -ForegroundColor Green
    Write-Host 'MicrosoftWsl_PackageUrl         ' -ForegroundColor Yellow -NoNewline
    Write-Host "$MicrosoftWsl_PackageUrl" -ForegroundColor Green
    Write-Host 'MicrosoftWsl_FilePath           ' -ForegroundColor Yellow -NoNewline
    Write-Host "$MicrosoftWsl_FilePath" -ForegroundColor Green
    Write-Host 'MicrosoftWsl_IsInstalled        ' -ForegroundColor Yellow -NoNewline
    Write-Host "$MicrosoftWsl_IsInstalled" -ForegroundColor Green
}

If ($ScriptName -eq 'tools-install.ps1') {
    # Git for Windows
    Set-Variable -Name 'GitPortable_InstallDir' -Value "$WSlRootAppsDir\Git"
    Set-Variable -Name 'GitPortable_DisplayName' -Value 'Git Portable'
    Set-Variable -Name 'GitPortable_MinorVersion' -Value '2.41.0'
    Set-Variable -Name 'GitPortable_PackageName' -Value 'GitPortable.exe'
    Set-Variable -Name 'GitPortable_PackageUrl' -Value "https://artifactory.si.francetelecom.fr/artifactory/dom-oasis-generic/LSW/Build/Git/PortableGit-$GitPortable_MinorVersion.3-64-bit.7z.exe"
    Set-Variable -Name 'GitPortable_FilePath' -Value "$WSlRootFilesDir\$GitPortable_PackageName"
    Set-Variable -Name 'GitPortable_IsInstalled' -Value (Get-ItemProperty "$RegistryPath\Components" -Name GitPortable_IsInstalled -ErrorAction SilentlyContinue).GitPortable_IsInstalled
    if (!($GitPortable_IsInstalled)) {
        Set-ItemProperty -Path "$RegistryPath\Components" -Name GitPortable_IsInstalled -Value 'no'
    }
    Write-Host 'GitPortable_DisplayName         ' -ForegroundColor Yellow -NoNewline
    Write-Host "$GitPortable_DisplayName" -ForegroundColor Green
    Write-Host 'GitPortable_MinorVersion        ' -ForegroundColor Yellow -NoNewline
    Write-Host "$GitPortable_MinorVersion" -ForegroundColor Green
    Write-Host 'GitPortable_PackageName         ' -ForegroundColor Yellow -NoNewline
    Write-Host "$GitPortable_PackageName" -ForegroundColor Green
    Write-Host 'GitPortable_PackageUrl          ' -ForegroundColor Yellow -NoNewline
    Write-Host "$GitPortable_PackageUrl" -ForegroundColor Green
    Write-Host 'GitPortable_FilePath            ' -ForegroundColor Yellow -NoNewline
    Write-Host "$GitPortable_FilePath" -ForegroundColor Green
    Write-Host 'GitPortable_InstallDir          ' -ForegroundColor Yellow -NoNewline
    Write-Host "$GitPortable_InstallDir" -ForegroundColor Green
    Write-Host 'GitPortable_IsInstalled         ' -ForegroundColor Yellow -NoNewline
    Write-Host "$GitPortable_IsInstalled" -ForegroundColor Green

    # Visual Studio Code
    Set-Variable -Name 'VScode_DisplayName' -Value 'Visual Studio Code'
    Set-Variable -Name 'VScode_PackageName' -Value 'vscode-install.exe'
    Set-Variable -Name 'VScode_PackageUrl' -Value "https://aka.ms/win32-x64-user-stable"
    Set-Variable -Name 'VScode_FilePath' -Value "$WSlRootFilesDir\$VScode_PackageName"
    Set-Variable -Name 'VScode_IsInstalled' -Value (Get-ItemProperty "$RegistryPath\Components" -Name VScode_IsInstalled -ErrorAction SilentlyContinue).VScode_IsInstalled
    if (!($VScode_IsInstalled)) {
        Set-ItemProperty -Path "$RegistryPath\Components" -Name VScode_IsInstalled -Value 'no'
    }
    Write-Host 'VScode_DisplayName              ' -ForegroundColor Yellow -NoNewline
    Write-Host "$VScode_DisplayName" -ForegroundColor Green
    Write-Host 'VScode_PackageName              ' -ForegroundColor Yellow -NoNewline
    Write-Host "$VScode_PackageName" -ForegroundColor Green
    Write-Host 'VScode_PackageUrl               ' -ForegroundColor Yellow -NoNewline
    Write-Host "$VScode_PackageUrl" -ForegroundColor Green
    Write-Host 'VScode_FilePath                 ' -ForegroundColor Yellow -NoNewline
    Write-Host "$VScode_FilePath" -ForegroundColor Green
    Write-Host 'VScode_IsInstalled              ' -ForegroundColor Yellow -NoNewline
    Write-Host "$VScode_IsInstalled" -ForegroundColor Green

    # Microsoft VCLibs (Windows Terminal)
    Set-Variable -Name 'VCLibsWindowsTerm_DisplayName' -Value 'Microsoft VCLibs'
    Set-Variable -Name 'VCLibsWindowsTerm_MinorVersion' -Value '14.00'
    Set-Variable -Name 'VCLibsWindowsTerm_PackageName' -Value 'Microsoft.VCLibs.appx'
    Set-Variable -Name 'VCLibsWindowsTerm_PackageUrl' -Value "https://artifactory.si.francetelecom.fr/artifactory/dom-oasis-generic/LSW/Microsoft/VCLibs/Microsoft.VCLibs.x64.$VCLibsWindowsTerm_MinorVersion.Desktop.appx"
    Set-Variable -Name 'VCLibsWindowsTerm_FilePath' -Value "$WSlRootFilesDir\$VCLibsWindowsTerm_PackageName"
    Set-Variable -Name 'VCLibsWindowsTerm_IsInstalled' -Value (Get-ItemProperty "$RegistryPath\Components" -Name VCLibsWindowsTerm_IsInstalled -ErrorAction SilentlyContinue).VCLibsWindowsTerm_IsInstalled
    if (!($VCLibsWindowsTerm_IsInstalled)) {
        Set-ItemProperty -Path "$RegistryPath\Components" -Name VCLibsWindowsTerm_IsInstalled -Value 'no'
    }

    # Windows Terminal
    Set-Variable -Name 'WindowsTerminal_DisplayName' -Value 'Microsoft WindowsTerminal'
    Set-Variable -Name 'WindowsTerminal_MinorVersion' -Value '1.17.11461.0'
    Set-Variable -Name 'WindowsTerminal_PackageName' -Value 'Microsoft.WindowsTerminal_Win10.msixbundle'
    Set-Variable -Name 'WindowsTerminal_PackageUrl' -Value "https://artifactory.si.francetelecom.fr/artifactory/dom-oasis-generic/LSW/Microsoft/WindowsTerminal/Microsoft.WindowsTerminal_${WindowsTerminal_MinorVersion}_8wekyb3d8bbwe.msixbundle"
    Set-Variable -Name 'WindowsTerminal_FilePath' -Value "$WSlRootFilesDir\$WindowsTerminal_PackageName"
    Set-Variable -Name 'WindowsTerminal_IsInstalled' -Value (Get-ItemProperty "$RegistryPath\Components" -Name WindowsTerminal_IsInstalled -ErrorAction SilentlyContinue).WindowsTerminal_IsInstalled
    if (!($WindowsTerminal_IsInstalled)) {
        Set-ItemProperty -Path "$RegistryPath\Components" -Name WindowsTerminal_IsInstalled -Value 'no'
    }
    Write-Host 'WindowsTerminal_DisplayName     ' -ForegroundColor Yellow -NoNewline
    Write-Host "$WindowsTerminal_DisplayName" -ForegroundColor Green
    Write-Host 'WindowsTerminal_MinorVersion    ' -ForegroundColor Yellow -NoNewline
    Write-Host "$WindowsTerminal_MinorVersion" -ForegroundColor Green
    Write-Host 'WindowsTerminal_PackageName     ' -ForegroundColor Yellow -NoNewline
    Write-Host "$WindowsTerminal_PackageName" -ForegroundColor Green
    Write-Host 'WindowsTerminal_PackageUrl      ' -ForegroundColor Yellow -NoNewline
    Write-Host "$WindowsTerminal_PackageUrl" -ForegroundColor Green
    Write-Host 'WindowsTerminal_FilePath        ' -ForegroundColor Yellow -NoNewline
    Write-Host "$WindowsTerminal_FilePath" -ForegroundColor Green
    Write-Host 'WindowsTerminal_IsInstalled     ' -ForegroundColor Yellow -NoNewline
    Write-Host "$WindowsTerminal_IsInstalled" -ForegroundColor Green

    # JetBrains Toolbox
    Set-Variable -Name 'JetBrainsToolbox_DisplayName' -Value 'JetBrains Toolbox'
    Set-Variable -Name 'JetBrainsToolbox_PackageName' -Value 'jetbrains-toolbox.exe'
    Set-Variable -Name 'JetBrainsToolbox_PackageUrl' -Value (Get-ItemProperty "$RegistryPath\Components" -Name JetBrainsToolbox_Url -ErrorAction SilentlyContinue).JetBrainsToolbox_Url
    Set-Variable -Name 'JetBrainsToolbox_FilePath' -Value "$WSlRootFilesDir\$JetBrainsToolbox_PackageName"
    Set-Variable -Name 'JetBrainsToolbox_IsInstalled' -Value (Get-ItemProperty "$RegistryPath\Components" -Name JetBrainsToolbox_IsInstalled -ErrorAction SilentlyContinue).JetBrainsToolbox_IsInstalled
    if (!($JetBrainsToolbox_IsInstalled)) {
        Set-ItemProperty -Path "$RegistryPath\Components" -Name JetBrainsToolbox_IsInstalled -Value 'no'
    }
    if ($USER_PROFILE.ToLower() -match 'dev') {
        Write-Host 'JetBrainsToolbox_DisplayName    ' -ForegroundColor Yellow -NoNewline
        Write-Host "$JetBrainsToolbox_DisplayName" -ForegroundColor Green
        Write-Host 'JetBrainsToolbox_PackageName    ' -ForegroundColor Yellow -NoNewline
        Write-Host "$JetBrainsToolbox_PackageName" -ForegroundColor Green
        Write-Host 'JetBrainsToolbox_PackageUrl     ' -ForegroundColor Yellow -NoNewline
        Write-Host "$JetBrainsToolbox_PackageUrl" -ForegroundColor Green
        Write-Host 'JetBrainsToolbox_FilePath       ' -ForegroundColor Yellow -NoNewline
        Write-Host "$JetBrainsToolbox_FilePath" -ForegroundColor Green
        Write-Host 'JetBrainsToolbox_IsInstalled    ' -ForegroundColor Yellow -NoNewline
        Write-Host "$JetBrainsToolbox_IsInstalled" -ForegroundColor Green
    }
}

if ($aYes -eq $DebugMode) {
    Read-Host -Prompt 'Press Enter to continue or CTRL+C to quit'
}
