;#### Parameters - BoF ########################################################
; Develop Mode
#ifndef DebugMode
  #define DebugMode "no"
#endif
#if "yes" == DebugMode
  #define DebugModeParam "-Verbose"
  #define CompressionMode "nocompression"
#else
  #define DebugModeParam ""
  #define CompressionMode "nocompression"
#endif

; App infos
#ifndef LSW_VERSION
  #define LSW_VERSION "0.0.0"
#endif

#ifndef DISTRO_VERSION
  #define DISTRO_VERSION "20.04"
#endif

#ifndef WSL_VERSION
  #define WSL_VERSION "2"
#endif

#ifndef ROOTFS_ORIGIN
  #define ROOTFS_ORIGIN "docker"
#endif

#define BastionPfcAdm 'bastadm.front.secu.multis.p.fti.net'
#define BastionPfcRsc 'opbar.hbx.geo.francetelecom.fr'

#define GITLAB_HOSTDiod 'gitlab.tech.orange'
#define GITLAB_HOSTSpirit 'gitlab.si.francetelecom.fr'

#define LdapHostFtiNet 'ldap.infra.multis.p.fti.net'
#define LdapBaseFtiNet 'ou=FT,ou=People,dc=fti,dc=net'

#define ShellBash '/bin/bash'
#define ShellZsh '/bin/zsh'

#ifndef GITLAB_HOST
  #define GITLAB_HOST GITLAB_HOSTDiod
#endif

#ifndef ENTITY_NAME
  #define ENTITY_NAME "PFC"
#endif
#ifdef ENTITY_NAME
  #define ENTITY_NAME_LC Lowercase(ENTITY_NAME)
#endif
#ifndef ENTITY_REPO_PATH
  #define ENTITY_REPO_PATH ""
#endif
#ifndef ENTITY_REPO_GITLAB_HOST
  #define ENTITY_REPO_GITLAB_HOST "gitlab.si.francetelecom.fr"
#endif

#ifndef WSLVPNKIT_FILENAME
  #define WSLVPNKIT_FILENAME "wsl-vpnkit_v0.3.8-r0.1.0.tar.gz"
#endif

#ifndef InstallerVersion
  #define InstallerVersion "0.0.0"
#endif

; Projects Git branches
#ifndef BRANCH_LSW_REPO
  #define BRANCH_LSW_REPO "master"
#endif
#ifndef BRANCH_ENTITY_REPO
  #define BRANCH_ENTITY_REPO "master"
#endif
;#### Parameters - EoF ########################################################

;#### Variables - BoF #########################################################
; Directories
#define MyProgramFiles "C:\My Program Files"
#define WslRootDir MyProgramFiles + "\WSL"

; App infos
#define AppInstallerExeName WSL_DISTRO_NAME + "_Installer"
#define WIN_DISTRO_DIR MyProgramFiles + "\" + AppInstallerExeName
#define AppPublisher "Orange"

; Archives & Files
#define GoLdapBinary "GoLDAP-windows-amd64.exe"
#define PwsScriptRunAsAdmin "run-as-admin.ps1"
#define PwsScriptWslInstall "wsl-install.ps1"
#define PwsScriptVariables "01_variables.ps1"
#define PwsScriptFunctions "02_functions.ps1"

; RootFS origin combo labels
#ifdef ROOTFS_ORIGIN
  #if ROOTFS_ORIGIN == "docker"
    #define ROOTFS_ORIGINComboLabel 'PFC Docker image'
  #elif ROOTFS_ORIGIN == "vdi"
    #define ROOTFS_ORIGINComboLabel 'PFC VDI template'
  #elif ROOTFS_ORIGIN == "cloudimg"
    #define ROOTFS_ORIGINComboLabel 'Ubuntu Cloud images'
  #else
    #define ROOTFS_ORIGINComboLabel 'Bad RootFS origin selected...'
  #endif
#endif
; #define ROOTFS_ORIGINComboLabel1 'PFC Docker image'
; #define ROOTFS_ORIGINComboLabel2 'PFC VDI template'
; #define ROOTFS_ORIGINComboLabel3 'Ubuntu Cloud images'

#define ArtifactoryURL "https://artifactory.si.francetelecom.fr"
#define VdiPortalURL "https://vdi2.orangeportails.net/ "
#define AppURL "https://gitlab.tech.orange/getting-started/work-environment/lsw-projects/lsw"
#define AppDocumentation "https://lsw-doc.app.cf.sph.hbx.geo.francetelecom.fr"
#define BastionsDoc "https://equipespu.pages.gitlab.si.francetelecom.fr/postedevdfy/Bastion/bastion_presentation/"

#define MainBeveledLabel "Publisher: "+AppPublisher+" / Distro: "+WSL_DISTRO_NAME+" / Setup: "+InstallerVersion+" / LSW: "+LSW_VERSION

;#### Variables - EoF #########################################################

;#### Entities customizes - BoF ###############################################
#ifdef ENTITY_NAME_LC
  #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\defines.iss")
    #include ".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\defines.iss"
  #endif
#endif
;#### Entities customizes - EoF ###############################################

[Setup]
AppName={#WSL_DISTRO_NAME}
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={#WSL_DISTRO_NAME}
AppVersion={#InstallerVersion}
AppVerName={#WSL_DISTRO_NAME} {#InstallerVersion}/{#LSW_VERSION}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppDocumentation}
AppUpdatesURL={#AppURL}
DefaultDirName={#WslRootDir}\distros\{#WSL_DISTRO_NAME}
DisableDirPage=yes
DefaultGroupName={#AppPublisher}\WSL\{#WSL_DISTRO_NAME}
DisableProgramGroupPage=yes
; Uninstall
; Uninstallable=no
; CreateUninstallRegKey=no
; Remove the following line to run in administrative install mode (install for all users.)
PrivilegesRequired=lowest
OutputDir={#WIN_DISTRO_DIR}
OutputBaseFilename={#AppInstallerExeName}
SetupIconFile=.\icons\lsw.ico
Compression=none
;SolidCompression=yes
WizardStyle=modern
WizardResizable=no
; 120,120 = 300x200 pixels (280x180 usable)
; 140,140 = 420x280 pixels (400x260 usable)
WizardSizePercent=140,140
WizardSmallImageFile=.\icons\orange.bmp
AlwaysRestart=yes
; Windows version (https://jrsoftware.org/ishelp/index.php?topic=winvernotes)
MinVersion=10.0.19044
; Logging
SetupLogging=yes
; Permit to create EXE file bigger than 2Go (multiples files)
;DiskSpanning=yes
ArchitecturesInstallIn64BitMode=x64

[Messages]
BeveledLabel={#MainBeveledLabel}

[Languages]
#ifdef ENTITY_NAME_LC
    #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\languages\LSW_en.isl")
        Name: "en"; MessagesFile: "compiler:Default.isl,iss_files\languages\LSW_en.isl,entities\{#ENTITY_NAME_LC}\builds\innosetup\iss_files\languages\LSW_en.isl"
    #else
        Name: "en"; MessagesFile: "compiler:Default.isl,iss_files\languages\LSW_en.isl"
    #endif
    #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\languages\LSW_fr.isl")
        Name: "fr"; MessagesFile: "compiler:Languages\French.isl,iss_files\languages\LSW_fr.isl,entities\{#ENTITY_NAME_LC}\builds\innosetup\iss_files\languages\LSW_fr.isl"
    #else
        Name: "fr"; MessagesFile: "compiler:Languages\French.isl,iss_files\languages\LSW_fr.isl"
    #endif
#endif

[LangOptions]
DialogFontName=Tahoma
DialogFontSize=8
WelcomeFontName=Verdana
WelcomeFontSize=12
TitleFontName=Arial
TitleFontSize=29
CopyrightFontName=Arial
CopyrightFontSize=8
RightToLeft=no

[Dirs]
Name: "{#WslRootDir}\apps"; Flags: uninsneveruninstall
Name: "{#WslRootDir}\bin"; Flags: uninsneveruninstall
Name: "{#WslRootDir}\files"; Flags: uninsneveruninstall
Name: "{#WslRootDir}\x11\VcXsrv"; Flags: uninsneveruninstall
Name: "{#WslRootDir}\wsl-vpnkit"; Flags: uninsneveruninstall
Name: "{app}\scripts"; Flags: uninsneveruninstall
Name: "{app}\reg"; Flags: uninsneveruninstall
Name: "{app}\icons"; Flags: uninsneveruninstall

[Files]
; Temporary scripts
Source: "files\{#GoLdapBinary}"; Flags: dontcopy noencryption ignoreversion
; Components
Source: "files\wsl-*.tar.gz"; DestDir: "{#WslRootDir}\files"; Flags: noencryption ignoreversion {#CompressionMode}
; Binaries
Source: "bin\LxRun.exe"; DestDir: "{#WslRootDir}\bin"; Flags: noencryption uninsneveruninstall onlyifdoesntexist {#CompressionMode}
Source: "bin\runHidden.vbs"; DestDir: "{#WslRootDir}\bin"; Flags: noencryption uninsneveruninstall onlyifdoesntexist {#CompressionMode}
Source: "bin\get_dpi.ps1"; DestDir: "{#WslRootDir}\bin"; Flags: noencryption uninsneveruninstall ignoreversion onlyifdoesntexist {#CompressionMode}
Source: "bin\PwsQuickEdit.exe"; DestDir: "{#WslRootDir}\bin"; Flags: noencryption uninsneveruninstall ignoreversion onlyifdoesntexist {#CompressionMode}
Source: "bin\LxRun.exe"; DestDir: "{app}\bin"; Flags: noencryption uninsneveruninstall ignoreversion onlyifdoesntexist {#CompressionMode}
; Fonts - Install
Source: "fonts\MesloLGS NF Bold Italic.ttf"; DestDir: "{autofonts}"; Flags: noencryption onlyifdoesntexist uninsneveruninstall {#CompressionMode}; FontInstall: "MesloLGS NF Bold Italic"
Source: "fonts\MesloLGS NF Bold.ttf"; DestDir: "{autofonts}"; Flags: noencryption onlyifdoesntexist uninsneveruninstall {#CompressionMode}; FontInstall: "MesloLGS NF Bold"
Source: "fonts\MesloLGS NF Italic.ttf"; DestDir: "{autofonts}"; Flags: noencryption onlyifdoesntexist uninsneveruninstall {#CompressionMode}; FontInstall: "MesloLGS NF Italic"
Source: "fonts\MesloLGS NF Regular.ttf"; DestDir: "{autofonts}"; Flags: noencryption onlyifdoesntexist uninsneveruninstall {#CompressionMode}; FontInstall: "MesloLGS NF Regular"
; Fonts
Source: "fonts\*"; DestDir: "{app}\fonts"; Flags: noencryption onlyifdoesntexist {#CompressionMode}
; Install/Uninstall
Source: "install\*"; DestDir: "{app}\install"; Flags: noencryption ignoreversion {#CompressionMode}
; WSL-VPNkit
Source: "files\{#WSLVPNKIT_FILENAME}"; DestDir: "{#WslRootDir}\wsl-vpnkit"; Flags: noencryption ignoreversion onlyifdoesntexist {#CompressionMode}
; Keepass
Source: "apps\keepass\*"; DestDir: "{#WslRootDir}\apps\KeePass"; Flags: noencryption recursesubdirs uninsneveruninstall onlyifdoesntexist {#CompressionMode}
; VcXsrv
Source: "x11\vcxsrv\*"; DestDir: "{#WslRootDir}\x11\VcXsrv"; Flags: noencryption recursesubdirs uninsneveruninstall onlyifdoesntexist {#CompressionMode}
; Entity files
#ifdef ENTITY_NAME_LC
  #if DirExists("entities\" + ENTITY_NAME_LC)
    Source: "entities\{#ENTITY_NAME_LC}\*"; DestDir: "{app}\entities\{#ENTITY_NAME_LC}"; Flags: noencryption recursesubdirs uninsneveruninstall {#CompressionMode}
  #endif
#endif

[Icons]
Name: "{group}\{cm:ProgramOnTheWeb,{#WSL_DISTRO_NAME}}"; Filename: "{#AppURL}"
Name: "{group}\{cm:UninstallProgram,{#WSL_DISTRO_NAME}}"; Filename: "{uninstallexe}"

// ----------------------------------------------------------------------------
// [Code]
// ----------------------------------------------------------------------------

[Code]
#include ".\iss_files\main_code.iss"

// ----------------------------------------------------------------------------
// [Run]
// ----------------------------------------------------------------------------

[Run]
Filename: "powershell.exe"; \
    Parameters: "-WindowStyle Maximized -File ""{app}\install\tools-install.ps1"" \
        -WSL_DISTRO_NAME {#WSL_DISTRO_NAME} {#DebugModeParam}"; \
    Flags: runmaximized runascurrentuser waituntilterminated 64bit; \
    StatusMsg: "Installing some tools..."; \
    WorkingDir: "{app}"; \
    Check: CheckMustInstallTools;

Filename: "powershell.exe"; \
    Parameters: "-WindowStyle Maximized -File ""{app}\install\00_install.ps1"" \
        -WSL_DISTRO_NAME {#WSL_DISTRO_NAME} {#DebugModeParam}"; \
    Flags: runmaximized runascurrentuser waituntilterminated 64bit; \
    StatusMsg: "Preparing and installing WSL {#WSL_DISTRO_NAME} distro..."; \
    WorkingDir: "{app}";

// ----------------------------------------------------------------------------
// [UninstallRun]
// ----------------------------------------------------------------------------

[UninstallRun]
Filename: "powershell.exe"; \
    Parameters: "-WindowStyle Maximized -File ""{app}\install\uninstall.ps1"" \
        -WSL_DISTRO_NAME {#WSL_DISTRO_NAME} {#DebugModeParam}"; \
    Flags: runmaximized runascurrentuser waituntilterminated 64bit; \
    RunOnceId: "UninstallingWslDistro"; \
    WorkingDir: "{app}";

// ----------------------------------------------------------------------------
// [UninstallDelete]
// ----------------------------------------------------------------------------

[UninstallDelete]
Type: files; Name: "{app}\bin\*"
Type: files; Name: "{app}\files\*"
Type: filesandordirs; Name: "{app}"

// ----------------------------------------------------------------------------
// [Registry]
// ----------------------------------------------------------------------------

[Registry]
Root: HKCU; Subkey: "SOFTWARE\{#AppPublisher}\WSL\Temp"; Flags: uninsdeletekey
Root: HKCU; Subkey: "SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}"; Flags: uninsdeletekey
