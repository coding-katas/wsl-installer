
// #### Windows authentication - BoF ############################################
// https://stackoverflow.com/questions/15492357/verify-the-users-password-in-inno-setup
// https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-logonuserw
#ifdef UNICODE
    #define AW "W"
#else
    #define AW "A"
#endif
const
// #### Windows authentication - BoF ############################################
    LOGON32_LOGON_INTERACTIVE = 2;
    LOGON32_PROVIDER_DEFAULT = 0;
    ERROR_SUCCESS = 0;
    ERROR_LOGON_FAILURE = 1326;
// #### Windows authentication - EoF ############################################

// #### PowerShell - BoF ########################################################
    PwsColorTable05DefaultValue = 5645313;
    PwsFontFamilyDefaultValue = 54;
    PwsFontSizeDefaultValue = 917504;
    PwsFontWeightDefaultValue = 400;
    PwsQuickEditDefaultValue = 1;
    PwsScreenBufferSizeDefaultValue = 589891439;
    PwsScreenColorsDefaultValue = 7;
    PwsWindowSizeDefaultValue = 22415215;
    PwsTerminalScrollingDefaultValue = 0;
    PwsFaceNameDefaultValue = 'Lucida Console';

    PwsQuickEditSetup = 0;
    PwsWindowSizeSetup = 4784399;
    PwsColorTable05Setup = 000000;
    PwsTerminalScrolling = 1;
    PwsFaceName = 'MesloLGS NF';
// #### PowerShell - EoF ########################################################

// Global variables
var
    // Global
    AdminRequestIgnore, MustInstallTools, LdapCredzChecked, WslVersionCheck: Boolean;
    ResultCode, GlobalFontSize, ScaleFactor: Integer;
    ExecStdout, WslVersionFile: String;
    RestartRequired, MicrosoftWsl, MicrosoftVmp, MicrosoftWsl_IsInstalled: String;

    // PageUserInformation
    PageUserInformation: TInputQueryWizardPage;

    // PageUserProfile
    PageUserProfile: TInputQueryWizardPage;
    INSTALL_LSW_ON_VDICombo: TNewComboBox;
    USER_PROFILECombo, USER_HAS_BASTIONCombo, BASTION_HOSTCombo, USER_HAS_LDAPCombo: TNewComboBox;
    LDAP_HOSTCombo, USER_HAS_VDICombo: TNewComboBox;
    USER_HAS_BASTIONLabel, LDAP_HOSTLabel, BASTION_HOSTLabel, USER_HAS_VDILabel, USER_HAS_LDAPLabel: TLabel;
    VDICaution, VDIWontInstall, VdiTitle, VdiMessage, INSTALL_LSW_ON_VDILabel: TLabel;
    VDI_HOSTNAMELabel, VDI_IPADDRESSLabel, USER_PROFILEBastions, USER_PROFILEBastionsDoc: TLabel;
    VDI_HOSTNAMEEdit, VDI_IPADDRESSEdit: TNewEdit;

    // PageCredentials
    PageCredentials: TInputQueryWizardPage;
    AuthentCuidTitle, AuthentCuidMessage, AuthentWslMessage, AuthentLdapTitle, AuthentLdapMessage: TLabel;
    PageUserInformationMessage, SshPassphraseMessageLdap, USER_PASSPHRASELabel, USER_PASSWORDLabel, USER_NAMELabel: TLabel;
    WIN_USER_PASSWORDLabel, WIN_USERNAMELabel: TLabel;
    USER_PASSPHRASEEdit, USER_PASSWORDEdit, WIN_USER_PASSWORDEdit: TPasswordEdit;
    USER_NAMEEdit, WIN_USERNAMEEdit: TNewEdit;

    // PageGitLabInformation
    PageGitLabInformation: TInputQueryWizardPage;
    GITLAB_HOSTCombo: TNewComboBox;
    GitlabPrivateTokenDiodTitle, GitlabPrivateTokenDiodMessage: TLabel;
    GitlabPrivateTokenSpiritTitle, GitlabPrivateTokenSpiritMessage: TLabel;

    // PageComponents
    PageComponents: TInputQueryWizardPage;
    DOCKERCombo, CFYCombo, KUBERNETESCombo, SHELL_DEFAULTCombo, GOLANGCombo, NODEJSCombo, WSL_WINDOWS_PROXYCombo: TNewComboBox;
    PYTHONCombo, PYTHON_PYENVCombo, PHPCombo, PFC_PICAASSOCombo, PFC_WAMPAASCombo, PFC_MERCURYCombo: TNewComboBox;
    PFC_RICKAASTLEYCombo, PFC_METALLIKAASCombo: TNewComboBox;
    PreviousDOCKER, PreviousCFY, PreviousKUBERNETES, PreviousPFC_WAMPAAS, PreviousPFC_MERCURY: String;
    PreviousPFC_PICAASSO, PreviousGOLANG, PreviousNODEJS, PreviousPYTHON, PreviousPYTHON_PYENV, PreviousPFC_RICKAASTLEY: String;
    PreviousPFC_METALLIKAAS, PreviousSHELL_DEFAULT, PreviousWSL_WINDOWS_PROXY, PreviousPHP: String;
    SWARM_TENANTLabel: TLabel;
    SWARM_TENANTEdit: TNewEdit;

#ifdef ENTITY_NAME_LC
    #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\variables_global.iss")
        #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\variables_global.iss"
    #endif
#endif

// Procedures install
#include "..\iss_files\main\procedures_install.iss"
#ifdef ENTITY_NAME_LC
    #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\procedures_install.iss")
        #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\procedures_install.iss"
    #endif
#endif

// Procedures - global
#include "..\iss_files\main\procedures_global.iss"
#ifdef ENTITY_NAME_LC
    #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\procedures_global.iss")
        #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\procedures_global.iss"
    #endif
#endif

// Functions
#include "..\iss_files\main\functions_global.iss"
#ifdef ENTITY_NAME_LC
    #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\functions_global.iss")
        #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\functions_global.iss"
    #endif
#endif

// Procedures - pages
#include "..\iss_files\main\procedures_pages.iss"
#ifdef ENTITY_NAME_LC
    #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\procedures_pages.iss")
        #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\procedures_pages.iss"
    #endif
#endif

// ----------------------------------------------------------------------------
// InitializeSetup
// ----------------------------------------------------------------------------

function InitializeSetup(): Boolean;
var
    ExitCode: Integer;
    UserTempDirectoryRegistry: String;
    UserTempDirectoryWanted: String;
    AdminRequestValidated: Boolean;
    TempFolderValidated: Boolean;
    RegistryValue: String;
    GitPortable_IsInstalled, VScode_IsInstalled, WindowsTerminal_IsInstalled: String;
    JetBrainsToolbox_IsInstalled: String;
    //JetBrainsToolbox_Url: String;
    ANSIStr: AnsiString;
    FaceName: String;
    ColorTable05, FontFamily, FontSize, FontWeight, QuickEdit, ScreenBufferSize, ScreenColors, WindowSize, TerminalScrolling: Cardinal;
begin
    AdminRequestValidated := True;
    TempFolderValidated := True;
    MustInstallTools := True;
    WslVersionFile := ExpandConstant('{#WslRootDir}\wsl.version');

    if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'RestartRequired', RestartRequired) then begin
        RestartRequired := 'no';
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'RestartRequired', RestartRequired);
    end;
    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'RestartRequired', RestartRequired);
    Log('Restart needed: ' + RestartRequired);

    // PowerShell
    #include "..\iss_files\registry\0_powershell.iss"
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\registry\0_powershell.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\registry\0_powershell.iss"
        #endif
    #endif

    // Windows functionalities
    #include "..\iss_files\registry\1_win_functionalities.iss"
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\registry\1_win_functionalities.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\registry\1_win_functionalities.iss"
        #endif
    #endif

    // Components
    #include "..\iss_files\registry\2_components.iss"
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\registry\2_components.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\registry\2_components.iss"
        #endif
    #endif

    // WSL
    #include "..\iss_files\registry\3_wsl.iss"
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\registry\3_wsl.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\registry\3_wsl.iss"
        #endif
    #endif

    // LSW
    #include "..\iss_files\registry\3_distro.iss"
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\registry\3_distro.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\registry\3_distro.iss"
        #endif
    #endif

    // Temporary files extract
    ExtractTemporaryFile('{#PwsScriptRunAsAdmin}');
    ExtractTemporaryFile('{#PwsScriptWslInstall}');
    ExtractTemporaryFile('{#PwsScriptVariables}');
    ExtractTemporaryFile('{#PwsScriptFunctions}');
    // Extract GoLDAP for validate the LDAP user account
    ExtractTemporaryFile('{#GoLdapBinary}');

    // Execute as Admin ?
    if IsAdmin then begin
        if MsgBox(ExpandConstant('{cm:GlobalIsAdmin}'), mbInformation, MB_OK) = IDOK then begin
            Exit
        end
    end;

    // WSL version check
    WslVersionCheck := CheckWslVersion(SW_HIDE, ewWaitUntilTerminated, ResultCode, ExecStdout) and (ResultCode = 0);
    Log(Format('WslVersionCheck %s', [IntToStr(Integer(WslVersionCheck))]))

    // Check if the user's temporary directory is outside of the user's profile directory (ZoneCental problems)
    UserTempDirectoryWanted := GetShortName(Format('%s%s', ['{#MyProgramFiles}', '\Windows\Temp\1']));
    UserTempDirectoryRegistry := GetEnv('TEMP')
    Log('Current folder: ' + UserTempDirectoryRegistry + ', wanted folder: ' + UserTempDirectoryWanted);
    if UserTempDirectoryRegistry = UserTempDirectoryWanted then begin
        Log('Validated user temporary directory.');
    end else begin
        TempFolderValidated := False;
    end;

    // Check if the user is connected to the Orange network
    if not CheckUrlConnectivity('{#ArtifactoryURL}', '') then begin
        Exit
    end;

    // Deploy WSL ?
    if (not WslVersionCheck) or (MicrosoftWsl <> 'Enabled') or (MicrosoftVmp <> 'Enabled') or (MicrosoftWsl_IsInstalled <> 'yes') then begin
        case TaskDialogMsgBox(ExpandConstant('{cm:DeployWslTitle}'),
                ExpandConstant('{cm:DeployWslMsgBox}'),
                mbConfirmation,
                MB_YESNOCANCEL, [ExpandConstant('{cm:DeployWslContinue}'), ExpandConstant('{cm:DeployWslIgnore}')],
                IDYES) of
        IDYES: AdminRequestIgnore := False;
        IDNO: AdminRequestIgnore := True;
        IDCANCEL: Exit;
        end;
    end;

    if AdminRequestIgnore then begin
        AdminRequestValidated := True;
    end;

    // Windows functionalities as admin
    if not AdminRequestIgnore and ((MicrosoftWsl <> 'Enabled') or (MicrosoftVmp <> 'Enabled') or (MicrosoftWsl_IsInstalled <> 'yes')) then begin
        AdminRequestValidated := False;

        case TaskDialogMsgBox(ExpandConstant('{cm:WindowsAdminRequestTitle}'),
                ExpandConstant('{cm:WindowsAdminMsgBox}'),
                mbConfirmation,
                MB_YESNOCANCEL, [ExpandConstant('{cm:WindowsAdminRequestContinue}'), ExpandConstant('{cm:WindowsAdminRequestIgnore}')],
                IDYES) of
        IDYES: AdminRequestValidated := False;
        IDNO: AdminRequestValidated := True;
        IDCANCEL: Exit;
        end;
    end;

    if not AdminRequestIgnore and not AdminRequestValidated then begin
        ShellExec('open', 'https://opmcmprt3.rouen.francetelecom.fr/Adminute', '', '', SW_SHOW, ewNoWait, ExitCode);
        if MsgBox(ExpandConstant('{cm:WindowsAdminRequest0}') + #13#10#13#10 + ExpandConstant('{cm:WindowsAdminRequest1}') + #13#10#13#10 + ExpandConstant('{cm:WindowsAdminRequest2}'), mbInformation, MB_OK) = IDOK then begin
            case TaskDialogMsgBox(ExpandConstant('{cm:WindowsAdminRequestTitle}'),
                    ExpandConstant('{cm:WindowsAdminRequestMsgBox}') + #13#10#13#10 + ExpandConstant('{cm:WindowsAdminRequest1}') + #13#10#13#10 + ExpandConstant('{cm:WindowsAdminRequest2}'),
                    mbConfirmation,
                    MB_YESNOCANCEL, [ExpandConstant('{cm:WindowsAdminRequested}'), ExpandConstant('{cm:WindowsAdminRefused}')],
                    IDYES) of
            IDYES: RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'RestartRequired', 'yes');
            IDNO: Abort;
            end;
        end;
    end;

    // The WSL --version command must return the 'WSLg' string
    Log('WslVersionFile: ' + WslVersionFile);
    if AdminRequestIgnore then begin
        ANSIStr := 'WSLg';
        if not LoadStringFromFile(WslVersionFile, ANSIStr) then begin
            Log('Bad WSL version');
            MsgBox(ExpandConstant('{cm:BadWslVersion,{cm:DeployWslContinue}}'), mbError, MB_OK);
            Exit;
        end
    end;

    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'RestartRequired', RestartRequired);
    if not AdminRequestIgnore and AdminRequestValidated and (RestartRequired <> 'yes') and ((MicrosoftWsl <> 'Enabled') or (MicrosoftVmp <> 'Enabled')) then begin
        WindowsFunctionalities()
    end;

    // Install Windows tools
    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'GitPortable_IsInstalled', GitPortable_IsInstalled);
    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'VScode_IsInstalled', VScode_IsInstalled)
    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'WindowsTerminal_IsInstalled', WindowsTerminal_IsInstalled)
    Log('GitPortable_IsInstalled: ' + GitPortable_IsInstalled);
    Log('VScode_IsInstalled: ' + VScode_IsInstalled);
    Log('WindowsTerminal_IsInstalled: ' + WindowsTerminal_IsInstalled);
    if ((GitPortable_IsInstalled = 'yes') and (VScode_IsInstalled = 'yes') and (WindowsTerminal_IsInstalled = 'yes')) then begin
        MustInstallTools := False;
    end;

    // Check if the user's temporary directory is outside of the user's profile directory (ZoneCental problems)
    if not TempFolderValidated then begin
        ForceDirectories(Format('%s%s', ['{#MyProgramFiles}', '\Windows\Temp']))
        RegWriteStringValue(HKCU, 'Environment', 'TMP', Format('%s%s', ['{#MyProgramFiles}', '\Windows\Temp']));
        RegWriteStringValue(HKCU, 'Environment', 'TEMP', Format('%s%s', ['{#MyProgramFiles}', '\Windows\Temp']));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'RestartRequired', 'yes');
    end;

    // Reboot ?
    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'RestartRequired', RestartRequired);
    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Windows Functionalities', 'Microsoft Windows Subsystem Linux', MicrosoftWsl);
    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Windows Functionalities', 'Microsoft Virtual Machine Platform', MicrosoftVmp);
    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'MicrosoftWsl_IsInstalled', MicrosoftWsl_IsInstalled);
    Log('Restart needed: ' + RestartRequired);
    Log('Microsoft Windows Subsystem Linux: ' + MicrosoftWsl);
    Log('Microsoft Virtual Machine Platform: ' + MicrosoftVmp);
    Log('MicrosoftWsl_IsInstalled: ' + MicrosoftWsl_IsInstalled);

    if UserTempDirectoryRegistry = UserTempDirectoryWanted then begin
        TempFolderValidated := True;
    end;

    if AdminRequestIgnore then begin
        AdminRequestValidated := True;
    end;

    if not AdminRequestIgnore then begin
        if (RestartRequired = 'yes') and ((MicrosoftWsl <> 'Enabled') or (MicrosoftVmp <> 'Enabled') or (MicrosoftWsl_IsInstalled <> 'yes') or (not TempFolderValidated)) then begin
            RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'RestartRequired', 'no');
            if MsgBox(ExpandConstant('{cm:GlobalRebootComputer}'), mbInformation, MB_OK) = IDOK then begin
                // PowerShell
                RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'QuickEdit', QuickEdit);
                RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'WindowSize', WindowSize);
                RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ColorTable05', ColorTable05);
                RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'TerminalScrolling', TerminalScrolling);
                RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FaceName', FaceName);

                RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'QuickEdit', PwsQuickEditDefaultValue);
                RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'WindowSize', PwsWindowSizeDefaultValue);
                RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ColorTable05', PwsColorTable05DefaultValue);
                RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'TerminalScrolling', PwsTerminalScrollingDefaultValue);
                RegWriteStringValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FaceName', PwsFaceNameDefaultValue);

                Exit
            end
        end
    end;

    Result := True;
end;

// ----------------------------------------------------------------------------
// InitializeWizard
// ----------------------------------------------------------------------------

procedure InitializeWizard;
var
    MainPageWidth, MainPageHeight, BorderWidth: Integer;

    ShowPasswordCheckCredentials, ShowPasswordCheckGitlabInfos: TNewCheckBox;

    USER_PROFILECaution, USER_PROFILELabel: TLabel;
    GITLAB_HOSTLabel, GITLAB_NAMESPACESMessage, GITLAB_HOSTMessage: TLabel;

    PreviousUSER_NAME, PreviousWIN_USERNAME, PreviousDEBFULLNAME, PreviousDEBEMAIL, PreviousLDAP_HOST: String;
    PreviousINSTALL_LSW_ON_VDI, PreviousVDI_HOSTNAME, PreviousVDI_IPADDRESS, PreviousUSER_HAS_VDI: String;
    PreviousUSER_PROFILE, PreviousGITLAB_HOST, PreviousUSER_HAS_LDAP, PreviousSWARM_TENANT: String;
    PreviousGITLAB_NAMESPACES, PreviousUSER_PASSWORD, PreviousWIN_USER_PASSWORD, PreviousUSER_PASSPHRASE: String;
    PreviousGITLAB_PRIVATE_TOKEN_DIOD, PreviousGITLAB_PRIVATE_TOKEN_SPIRIT: String;
    PreviousUSER_HAS_BASTION, PreviousBASTION_HOST: String;

    SshPassphraseTitle, SshPassphraseMessageCommon: TLabel;

    ComponentsServicesTitle, ComponentsPfcPlatformsTitle: TLabel;
    DOCKERLabel, CFYLabel, KUBERNETESLabel, PFC_PICAASSOLabel, PFC_WAMPAASLabel, PFC_MERCURYLabel, PFC_RICKAASTLEYLabel: TLabel;
    EnvConfigLabel, ShellDefaultLabel, GolangLabel, PythonLabel, PythonPyenvLabel, WslProxyLabel, WslProxyMessage: TLabel;
    PFC_METALLIKAASLabel, NODEJSLabel, PHPLabel: TLabel;

    // Entity customize
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\InitializeWizard\vars.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\InitializeWizard\vars.iss"
        #endif
    #endif

begin
    GlobalFontSize := 8;
    ScaleFactor := GetScalingFactor;
    BorderWidth := 45 * 2;
    MainPageWidth := WizardForm.InnerPage.ClientWidth + ((WizardForm.InnerPage.ClientWidth * ScaleFactor) / 100) - BorderWidth;
    MainPageHeight := WizardForm.InnerPage.ClientHeight + ((WizardForm.InnerPage.ClientHeight * ScaleFactor) / 100) - BorderWidth;

    // Create pages
    // Pages order: wpWelcome, wpLicense, wpPassword, wpInfoBefore, wpUserInfo, wpSelectDir, wpSelectComponents, wpSelectProgramGroup, wpSelectTasks, wpReady, wpPreparing, wpInstalling, wpInfoAfter, wpFinished
    PageUserInformation := CreateInputQueryPage(wpWelcome, ExpandConstant('{cm:PageUserInformationTitle}'), ExpandConstant('{cm:PageUserInformationDescription}'), '');
    PageGitLabInformation := CreateInputQueryPage(wpPassword, ExpandConstant('{cm:PageGitLabInformationTitle}'), ExpandConstant('{cm:PageGitLabInformationDescription}'), '');
    PageCredentials := CreateInputQueryPage(wpPassword, ExpandConstant('{cm:PageCredentialsTitle}'), ExpandConstant('{cm:PageCredentialsDescription}'), '');
    PageUserProfile := CreateInputQueryPage(wpPassword, ExpandConstant('{cm:PageUserProfileDescription}'), '', '');
    PageComponents := CreateInputQueryPage(wpSelectComponents, ExpandConstant('{cm:PageComponentsTitle}'), ExpandConstant('{cm:PageComponentsDescription}'), '');

    // Load pages
    #include "..\iss_files\pages\PageUserInformation.iss"
    #include "..\iss_files\pages\PageUserProfile.iss"
    #include "..\iss_files\pages\PageCredentials.iss"
    #include "..\iss_files\pages\PageGitLabInformation.iss"
    #include "..\iss_files\pages\PageComponents.iss"

    // Entity customize
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\InitializeWizard\pages_define.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\InitializeWizard\pages_define.iss"
        #endif
    #endif

    // Entity customize
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\InitializeWizard\pages_adds.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\InitializeWizard\pages_adds.iss"
        #endif
    #endif

    // Entity customize
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\InitializeWizard\pages_contents.iss")
        #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\InitializeWizard\pages_contents.iss"
        #endif
    #endif
end;

procedure CurPageChanged(CurPageID: Integer);
begin
    // Entity customize
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\CurPageChanged\main.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\CurPageChanged\main.iss"
        #endif
    #endif
end;

procedure DeinitializeSetup();
var
    FaceName: String;
    QuickEdit, WindowSize, ColorTable05, TerminalScrolling: Cardinal;
begin
    // PowerShell
    RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'QuickEdit', QuickEdit);
    RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'WindowSize', WindowSize);
    RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ColorTable05', ColorTable05);
    RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'TerminalScrolling', TerminalScrolling);
    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FaceName', FaceName);

    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'QuickEdit', QuickEdit);
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'WindowSize', WindowSize);
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ColorTable05', ColorTable05);
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'TerminalScrolling', TerminalScrolling);
    RegWriteStringValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FaceName', FaceName);

    #if "no" == DebugMode
    // Delete sensistive data
    RegDeleteKeyIncludingSubkeys(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp');
    #endif

    // Entity customize
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\DeinitializeSetup\main.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\DeinitializeSetup\main.iss"
        #endif
    #endif
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
    // Entity customize
    #ifdef ENTITY_NAME_LC
        #if FileExists(".\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\CurUninstallStepChanged\main.iss")
            #include "..\entities\" + ENTITY_NAME_LC + "\builds\innosetup\iss_files\CurUninstallStepChanged\main.iss"
        #endif
    #endif
end;
