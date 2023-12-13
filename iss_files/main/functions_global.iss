function GetScalingFactor: Integer;
var
    OneHundredTwentyFive, OneHundredFifty, OneHundredSeventyFive, TwoHundred: Integer;
begin
    OneHundredTwentyFive := 120 // 125% scaling
    OneHundredFifty := 144 // 150% scaling
    OneHundredSeventyFive := 168 // 175% scaling
    TwoHundred :=  192 // 200% scaling

    if WizardForm.Font.PixelsPerInch >= TwoHundred then Result := -32
    else
    if WizardForm.Font.PixelsPerInch >= OneHundredSeventyFive then Result := -16
    else
    if WizardForm.Font.PixelsPerInch >= OneHundredFifty then Result := -8
    else
    if WizardForm.Font.PixelsPerInch >= OneHundredTwentyFive then Result := 20
    else Result := 40;
end;

// Check if the user is connected to the Orange network
function CheckUrlConnectivity(Url, Token: String): Boolean;
var
    Checked: Boolean;
    WinHttpReq: Variant;
    RequestResult: String;
begin
    Checked := False;
    Result := False;
    repeat
        try
            WinHttpReq := CreateOleObject('WinHttp.WinHttpRequest.5.1');
            WinHttpReq.Open('GET', Url, False);
            if Token <> '' then begin
                WinHttpReq.SetRequestHeader('PRIVATE-TOKEN', Token);
            end;
            WinHttpReq.Send('');
            Log('Connected to the server ' + Url + '; status: ' + IntToStr(WinHttpReq.Status) + ' ' + WinHttpReq.StatusText);
            if Token <> '' then begin
                RequestResult := Lowercase(WinHttpReq.StatusText);
                if Pos('unauthorized', RequestResult) <> 0 then begin
                    MsgBox(ExpandConstant('{cm:CheckGitlabAccessToken}'), mbError, MB_OK);
                    Checked := True;
                    Result := False;
                    Break;
                end;
                if Pos('not found', RequestResult) <> 0 then begin
                    Checked := True;
                    Result := False;
                    Break;
                end;
            end;

            Checked := True;
            Result := True;
        except
            Log('Error connecting to the server: ' + GetExceptionMessage);
            if WizardSilent then begin
                Log('Connection to the server is not available, aborting silent installation');
                Exit;
            end else
                if MsgBox(ExpandConstant('{cm:CannotReach,'+Url+'}') + #13#10#13#10 + ExpandConstant('{cm:CheckInternetConnection}'), mbError, MB_RETRYCANCEL) = IDRETRY then begin
                    Log('Retrying');
                end else begin
                    Log('Aborting');
                    Exit;
                end;
            end;
    until Checked;
end;

function ValidateEmail(strEmail : String) : boolean;
var
    strTemp  : String;
    nSpace   : Integer;
    nAt      : Integer;
    nDot     : Integer;
begin
    strEmail := Trim(strEmail);
    nSpace := Pos(' ', strEmail);
    nAt := Pos('@', strEmail);
    strTemp := Copy(strEmail, nAt + 1, Length(strEmail) - nAt + 1);
    nDot := Pos('.', strTemp) + nAt;
    Result := ((nSpace = 0) and (1 < nAt) and (nAt + 1 < nDot) and (nDot < Length(strEmail)));
end;

function CheckUSER_PASSWORD(LdapServer, LdapBase, Username, Password: String): Boolean;
var
    ExitCode: Integer;
    PasswordValidated: Boolean;
begin
    PasswordValidated := true;
    Log(Format('%s check --ldap-server %s --ldap-base %s --user-name %s', [ExpandConstant('{tmp}\{#GoLdapBinary}'), LdapServer, LdapBase, Username]))
    if Exec(ExpandConstant('{tmp}\{#GoLdapBinary}'), Format('check --ldap-server %s --ldap-base %s --user-name %s --user-password %s', [LdapServer, LdapBase, Username, Password]), '', SW_HIDE, ewWaitUntilTerminated, ExitCode) then begin
        if ExitCode <> 0 then begin
            PasswordValidated := false;
            MsgBox(ExpandConstant('{cm:GoldapBadPassword}'), mbError, MB_OK);
        end;
        Result := PasswordValidated;
    end else begin
        MsgBox(ExpandConstant('{cm:GoldapBadValidate}') + #13#10 + #13#10 + SysErrorMessage(ExitCode), mbError, MB_OK);
        Result := false;
    end
end;

function LogonUser(lpszUsername, lpszDomain, lpszPassword: string; dwLogonType, dwLogonProvider: DWORD; var phToken: THandle): BOOL;
external 'LogonUser{#AW}@advapi32.dll stdcall delayload setuponly';

function TryLogonUser(const Domain, UserCUID, Password: string; var ErrorCode: Longint): Boolean;
var
    Token: THandle;
begin
    Result := LogonUser(UserCUID, Domain, Password, LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, Token);
    ErrorCode := DLLGetLastError;
end;

function CheckWIN_USER_PASSWORD(UserCUID: String; Password: String): Boolean;
var
    Domain: string;
    ErrorCode: Longint;
begin
    ParseDomainUserName(Format('%s%s', [AddBackslash(GetEnv('USERDOMAIN')), UserCUID]), Domain, UserCUID);
    Result := TryLogonUser(GetEnv('USERDOMAIN'), UserCUID, Password, ErrorCode);

    case ErrorCode of
        ERROR_SUCCESS:
        Log('Windows logon successful for ' + AddBackslash(GetEnv('USERDOMAIN')) + UserCUID);
        ERROR_LOGON_FAILURE:
        begin
            MsgBox(ExpandConstant('{cm:WindowsBadPassword}') + #13#10 + #13#10 + SysErrorMessage(DLLGetLastError), mbError, MB_OK);
            Result := false;
        end;
    else begin
        Result := TryLogonUser(GetEnv('USERDOMAIN'), UserCUID, Password, ErrorCode);

        case ErrorCode of
            ERROR_SUCCESS:
            Log('Windows logon successful for ' + AddBackslash(GetEnv('USERDOMAIN')) + UserCUID);
            ERROR_LOGON_FAILURE:
                begin
                    MsgBox(ExpandConstant('{cm:WindowsBadPassword}') + #13#10 + #13#10 + SysErrorMessage(DLLGetLastError), mbError, MB_OK);
                    Result := false;
                end;
            else
                begin
                    MsgBox(ExpandConstant('{cm:WindowsBadValidate}') + #13#10 + SysErrorMessage(DLLGetLastError), mbError, MB_OK);
                    Result := false;
                end;
            end;
        end;
    end;
end;

// Install Windows tools
function CheckMustInstallTools: Boolean;
begin
    Result := MustInstallTools;
end;

function CheckWslVersion(ShowCmd: Integer; Wait: TExecWait; var ResultCode: Integer; var ResultString: String): Boolean;
var
    Command: String;
    ResultStringAnsi: AnsiString;
begin
    // Exec via cmd and redirect output to file.
    // Must use special string-behavior to work.
    Command := Format('"%s" /S /C ""wsl.exe" --version 2>&1 > "%s""', [ExpandConstant('{cmd}'), WslVersionFile]);
    Result := Exec(ExpandConstant('{cmd}'), Command, ExpandConstant('{#WslRootDir}'), ShowCmd, Wait, ResultCode);
    if not Result then
        Exit;
    LoadStringFromFile(WslVersionFile, ResultStringAnsi); // Cannot fail
    // See https://stackoverflow.com/q/20912510/850848
    ResultString := ResultStringAnsi;
    // Remove new-line at the end
    if (Length(ResultString) >= 2) and (ResultString[Length(ResultString) - 1] = #13) and
        (ResultString[Length(ResultString)] = #10) then
        Delete(ResultString, Length(ResultString) - 1, 2);
end;

function WindowsFunctionalities(): Boolean;
var
    ExitCode: Integer;
    Changed: Boolean;
begin
    begin
        Result := true;
        Changed := true;
        Log(Format('Start-Process -WindowStyle Maximized -Wait -Verb RunAs -PassThru -FilePath powershell.exe -ArgumentList """& %s" -WSL_DISTRO_NAME %s""', [ExpandConstant('{tmp}\{#PwsScriptRunAsAdmin}'), ExpandConstant('{#WSL_DISTRO_NAME}')]));
        if not Exec('powershell.exe', Format('Start-Process -WindowStyle Maximized -Wait -Verb RunAs -PassThru -FilePath powershell.exe -ArgumentList """& %s" -WSL_DISTRO_NAME %s""', [ExpandConstant('{tmp}\{#PwsScriptRunAsAdmin}'), ExpandConstant('{#WSL_DISTRO_NAME}')]), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ExitCode) then begin
            Changed := false;
            MsgBox(ExpandConstant('{cm:GlobalCanNotExecuteExit,{#PwsScriptRunAsAdmin}}') + #13#10 + #13#10 + SysErrorMessage(ExitCode), mbError, MB_OK);
            Result := Changed;
        end
    end;
end;

function WslInstall(): Boolean;
var
    ExitCode: Integer;
    Changed: Boolean;
begin
    begin
        Result := true;
        Changed := true;
        Log(Format('Start-Process -WindowStyle Maximized -Wait -PassThru -FilePath powershell.exe -ArgumentList """& %s" -WSL_DISTRO_NAME %s""', [ExpandConstant('{tmp}\{#PwsScriptWslInstall}'), ExpandConstant('{#WSL_DISTRO_NAME}')]));
        if not Exec('powershell.exe', Format('Start-Process -WindowStyle Maximized -Wait -PassThru -FilePath powershell.exe -ArgumentList """& %s" -WSL_DISTRO_NAME %s""', [ExpandConstant('{tmp}\{#PwsScriptWslInstall}'), ExpandConstant('{#WSL_DISTRO_NAME}')]), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ExitCode) then begin
            Changed := false;
            MsgBox(ExpandConstant('{cm:GlobalCanNotExecuteExit,{#PwsScriptWslInstall}}') + #13#10 + #13#10 + SysErrorMessage(ExitCode), mbError, MB_OK);
            Result := Changed;
        end
    end;
end;

function CheckSshKeyPassphrase(Passphrase: String): Boolean;
var
    i, PassphraseLength: integer;
    CheckLength, CheckDigit, CheckCapital, CheckSpecial, CheckAccented: boolean;
begin
    Result := false;
    CheckLength := false;
    CheckDigit := false;
    CheckCapital := false;
    CheckSpecial := false;
    CheckAccented := true;
    PassphraseLength := Length(Passphrase);

    // --> from 8 to 128 characters
    if (PassphraseLength >= 8) and (PassphraseLength <= 128) then begin
        CheckLength := true;
    end;

    // --> contain at least 1 digit
    for i:=1 to PassphraseLength do
        begin
            case Passphrase[i] of
            '0'..'9':
                begin
                    CheckDigit := true;
                    Break;
                end;
            end;
        end;

    // --> contain at least 1 capital letter
    for i:=1 to PassphraseLength do
        begin
            case Passphrase[i] of
            'A'..'Z':
                begin
                    CheckCapital := true;
                    Break;
                end;
            end;
      end;

    // --> must have at least one printable ASCII character
    for i:=1 to PassphraseLength do
        begin
            case Passphrase[i] of
            '!','#','$','%','&','(',')','*','/',':','<','>','?','@','^','_','{','|','}','~':
                begin
                    CheckSpecial := true;
                    Break;
                end;
            end;
      end;

    // --> NOT contain accented characters: àáâãäåçèéêëìíîïðòóôõöùúûüýÿ
    for i:=1 to PassphraseLength do
        begin
            case Passphrase[i] of
            'à','á','â','ã','ä','å','ç','è','é','ê','ë','ì','í','î','ï','ð','ò','ó','ô','õ','ö','ù','ú','û','ü','ý','ÿ':
                begin
                    CheckAccented := false;
                    Break;
                end;
            end;
      end;

    if CheckLength and CheckDigit and CheckCapital and CheckSpecial and CheckAccented then begin
        Result := true;
    end
end;

//Validate an IPv4 address
function ValidateIP(Input: String): Boolean;
var
    InputTemp : String;
    IP: Cardinal;
    i : Integer;
    Part: Integer;
    PartValue: Cardinal;
    PartValid: Boolean;
begin
    InputTemp := Input;
    Result := True;

    Part := 3;
    PartValue := 0;
    PartValid := False;
    IP := 0;
    // When a '.' is encountered, the previous part is processed. Force processing
    // the last part by adding a '.' to the input.
    Input := Input + '.';

    for i := 1 to Length(Input) do
    begin
        // Check next character
        if Input[i] = '.' then
        begin

        if PartValue <= 255 then
        begin
            if PartValid then
            begin
            // A valid part is encountered. Put it in the result.
            IP := IP or (PartValue shl (Part * 8));
            // Stop processing if this is the last '.' we put in ourselves.
            if i = Length(Input) then
                Break;
            // Else reset the temporary values.
            PartValid := False;
            PartValue := 0;
            Dec(Part);
            end
            else
            Result := False;
        end
        else
            Result := False;

        end
        else if ( (((Ord(Input[i]) - Ord('0'))) >= 0) and ((Ord(Input[i]) - Ord('0')) <= 9) ) then
        begin
        // A digit is found. Add it to the current part.
        PartValue := PartValue * 10 + Cardinal((Ord(Input[i]) - Ord('0')));
        PartValid := True;
        end
        else
        begin
        // Any other character
        Result := False;
        end;
        // If part < 0, we processed too many dots.
        if Part < 0 then
        Result := False;
    end;
    // Check if we found enough parts.
    if Part > 0 then
        Result := False;
    // If Part is not valid after the loop, the input ended in a dot.
    if not PartValid then
        Result := False;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
    GITLAB_HOST, WIN_USERNAME, USER_NAME, USER_PASSWORD, USER_PASSPHRASE, WIN_USER_PASSWORD: String;
    LDAP_HOST, LDAP_BASE, VDI_HOSTNAME, VDI_IPADDRESS, Url, Namespace: String;
    GITLAB_NAMESPACES, GITLAB_PRIVATE_TOKEN_DIOD, GITLAB_PRIVATE_TOKEN_SPIRIT, GitlabCurrentToken: String;
    UserHasLdap, UserHasVdi, UserHasBastion, UserProfile, BastionHost: String;
    CheckUserLdapPassword, CheckUserAdPassword, CheckGITLAB_HOST, USER_HAS_LDAPChecked, CheckUserMail: Boolean;
    GitlabDiodTokenChecked, GitlabSpiritTokenChecked, GitlabNamespacesChecked: Boolean;
    strArray: TArrayOfString;
    i: Integer;
begin
    Result := True;

    if CurPageID = PageUserProfile.ID then begin
        LDAP_HOST := '';
        LDAP_BASE := '';
        case USER_HAS_LDAPCombo.ItemIndex of
            0:
                begin
                LDAP_HOST := Trim(Lowercase(LDAP_HOSTCombo.Text));
                case LDAP_HOST of
                    '{#LdapHostFtiNet}':
                        begin
                        LDAP_BASE := '{#LdapBaseFtiNet}';
                        end;
                end;
                end;
        end;

        VDI_HOSTNAME := '';
        VDI_IPADDRESS := '';
        case USER_HAS_VDICombo.ItemIndex of
            0:
                begin
                VDI_HOSTNAME := Trim(Lowercase(VDI_HOSTNAMEEdit.Text));
                VDI_IPADDRESS := Trim(Lowercase(VDI_IPADDRESSEdit.Text));
                end;
        end;

        UserHasVdi := Trim(Lowercase(USER_HAS_VDICombo.Text))
        if (Length(UserHasVdi) = 0) then begin
            UserHasVdi := ExpandConstant('{cm:NoMessage}');
        end;
        UserHasLdap := Trim(Lowercase(USER_HAS_LDAPCombo.Text))
        if (Length(UserHasLdap) = 0) then begin
            UserHasLdap := ExpandConstant('{cm:NoMessage}');
        end;
        UserHasBastion := Trim(Lowercase(USER_HAS_BASTIONCombo.Text))
        if (Length(UserHasBastion) = 0) then begin
            UserHasBastion := ExpandConstant('{cm:NoMessage}');
        end;

        UserProfile := Trim(USER_PROFILECombo.Text);
        BastionHost := Trim(Lowercase(BASTION_HOSTCombo.Text));
        case UserHasLdap of
            'yes', 'y', 'oui', 'o', 'true', 't', '1':
                begin
                UserProfile := UserProfile + '_LDAP';

                case BastionHost of
                    '{#BastionPfcAdm}':
                        begin
                        UserProfile := UserProfile + '_ADM';
                        end;
                    '{#BastionPfcRsc}':
                        begin
                        UserProfile := UserProfile + '_RSC';
                        end;
                end;
            end;
        end;

        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'ROOTFS_ORIGIN', '{#ROOTFS_ORIGINComboLabel}');
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'DISTRO_VERSION', '{#DISTRO_VERSION}');
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'WSL_VERSION', '{#WSL_VERSION}');

        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_PROFILE', UserProfile);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_HAS_VDI', UserHasVdi);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_HAS_LDAP', UserHasLdap);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'LDAP_HOST', LDAP_HOST);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'LDAP_BASE', Trim(LDAP_BASE));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_HAS_BASTION', UserHasBastion);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'BASTION_HOST', BastionHost);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'INSTALL_LSW_ON_VDI', Trim(Lowercase(INSTALL_LSW_ON_VDICombo.Text)));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'VDI_HOSTNAME', VDI_HOSTNAME);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'VDI_IPADDRESS', VDI_IPADDRESS);
    end;

    if CurPageID = PageUserInformation.ID then begin
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'DEBFULLNAME', PageUserInformation.Values[0]);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'DEBEMAIL', Trim(PageUserInformation.Values[1]));

        CheckUserMail := ValidateEmail(Trim(PageUserInformation.Values[1]));
        if not CheckUserMail then begin
            Result := False;
            MsgBox(ExpandConstant('{cm:BadDEBEMAIL}'), mbError, MB_OK)
        end;
    end;

    if CurPageID = PageGitLabInformation.ID then begin
        GITLAB_HOST := Trim(Lowercase(GITLAB_HOSTCombo.Text));
        CheckGITLAB_HOST := CheckUrlConnectivity(Format('https://%s', [GITLAB_HOST]), '');

        // GitLab tokens
        GITLAB_PRIVATE_TOKEN_DIOD := Trim(PageGitLabInformation.Values[1]);
        GITLAB_PRIVATE_TOKEN_SPIRIT := Trim(PageGitLabInformation.Values[2]);
        GitlabDiodTokenChecked := CheckUrlConnectivity('https://{#GITLAB_HOSTDiod}/api/v4/personal_access_tokens', GITLAB_PRIVATE_TOKEN_DIOD);
        case GITLAB_HOSTCombo.Text of
        '{#GITLAB_HOSTDiod}':
                begin
                GitlabSpiritTokenChecked := True;
                GitlabCurrentToken := GITLAB_PRIVATE_TOKEN_DIOD;
                end;
        '{#GITLAB_HOSTSpirit}':
                begin
                GitlabSpiritTokenChecked := CheckUrlConnectivity('https://{#GITLAB_HOSTSpirit}/api/v4/personal_access_tokens', GITLAB_PRIVATE_TOKEN_SPIRIT);
                GitlabCurrentToken := GITLAB_PRIVATE_TOKEN_SPIRIT;
                end;
        end;

        // Namespaces
        GITLAB_NAMESPACES := Trim(PageGitLabInformation.Values[0]);
        Explode(strArray, GITLAB_NAMESPACES, ',');
        if GetArrayLength(strArray) = 0 then begin
            GitlabNamespacesChecked := True;
        end else begin
            GitlabNamespacesChecked := True;
            for i:=0 to GetArrayLength(strArray)-1 do begin
                Namespace := Trim(strArray[i]);
                if Namespace = '' then begin
                    Continue
                end;
                Url := Format('https://%s/api/v4/namespaces/%s', [GITLAB_HOSTCombo.Text, Namespace]);
                Log('GitLab namespace: '+Namespace+' '+Url);
                GitlabNamespacesChecked := CheckUrlConnectivity(Url, GitlabCurrentToken);
                if not GitlabNamespacesChecked then begin
                    if MsgBox(ExpandConstant('{cm:GitlabNamespaceNotFound,'+Namespace+'}'), mbError, MB_RETRYCANCEL) = IDRETRY then begin
                        Log('Retrying');
                    end else begin
                        Log('Aborting');
                        Exit;
                    end;
                end;
            end;
        end;

        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'GITLAB_HOST', GITLAB_HOST);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_GITLAB_NAMESPACES', Trim(PageGitLabInformation.Values[0]));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'GITLAB_PRIVATE_TOKEN_DIOD', GITLAB_PRIVATE_TOKEN_DIOD);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'GITLAB_PRIVATE_TOKEN_SPIRIT', GITLAB_PRIVATE_TOKEN_SPIRIT);

        Result := False;
        if CheckGITLAB_HOST and GitlabNamespacesChecked then begin
            Result := True;
        end;
    end;

    if CurPageID = PageCredentials.ID then begin
        WIN_USERNAME := Trim(WIN_USERNAMEEdit.Text);
        WIN_USER_PASSWORD := Trim(WIN_USER_PASSWORDEdit.Text);
        CheckUserAdPassword := CheckWIN_USER_PASSWORD(WIN_USERNAME, WIN_USER_PASSWORD);
        USER_HAS_LDAPChecked := (USER_HAS_LDAPCombo.Text = ExpandConstant('{cm:YesMessage}')) and (CompareText(LDAP_HOSTCombo.Text, '') <> 0);
        CheckUserLdapPassword := True;

        USER_NAME := Trim(Lowercase(WIN_USERNAME));
        USER_PASSWORD := WIN_USER_PASSWORD;

        if USER_HAS_LDAPChecked then begin
            LDAP_HOST := LDAP_HOSTCombo.Text
            RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'LDAP_BASE', LDAP_BASE)

            USER_NAME := Trim(USER_NAMEEdit.Text);
            USER_PASSWORD := Trim(USER_PASSWORDEdit.Text);
            CheckUserLdapPassword := CheckUSER_PASSWORD(LDAP_HOST, LDAP_BASE, USER_NAME, USER_PASSWORD);
        end;
        USER_PASSPHRASE := Trim(USER_PASSPHRASEEdit.Text);

        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'WIN_USERNAME', WIN_USERNAME);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'WIN_USER_PASSWORD', WIN_USER_PASSWORD);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_NAME', USER_NAME);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'USER_PASSWORD', USER_PASSWORD);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'USER_PASSPHRASE', USER_PASSPHRASE);

        // WSL install
        RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Windows Functionalities', 'Microsoft Windows Subsystem Linux', MicrosoftWsl);
        RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Windows Functionalities', 'Microsoft Virtual Machine Platform', MicrosoftVmp);
        RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'MicrosoftWsl_IsInstalled', MicrosoftWsl_IsInstalled);

        if CheckUserLdapPassword and CheckUserAdPassword then begin
            if (MicrosoftWsl = 'Enabled') and (MicrosoftVmp = 'Enabled') then begin
                WslInstall()
                RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'MicrosoftWsl_IsInstalled', MicrosoftWsl_IsInstalled);
            end
        end;
        RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'RestartRequired', RestartRequired);

        if (not AdminRequestIgnore) and (MicrosoftWsl_IsInstalled <> 'yes') then begin
            if MsgBox(ExpandConstant('{cm:WslNotInstalled}'), mbConfirmation, MB_OK) = IDOK then begin
                OpenBrowser('{#AppDocumentation}/knowledge-base/wsl/');
                ExitProcess(1);
            end;
        end;

        if not CheckUserLdapPassword or not CheckUserAdPassword or ((not AdminRequestIgnore) and (MicrosoftWsl_IsInstalled <> 'yes')) then begin
            Result := False;
        end
    end;

    if CurPageID = PageComponents.ID then begin
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'DOCKER', DOCKERCombo.Text);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'CLOUD_FOUNDRY', CFYCombo.Text);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'KUBERNETES', KUBERNETESCombo.Text);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PFC_WAMPAAS', PFC_WAMPAASCombo.Text);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PFC_MERCURY', PFC_MERCURYCombo.Text);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PFC_PICAASSO', PFC_PICAASSOCombo.Text);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'CHECKPACKAGES', PFC_PICAASSOCombo.Text);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'TICKET_MANAGER', ExpandConstant('{cm:YesMessage}'));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PFC_RICKAASTLEY', PFC_RICKAASTLEYCombo.Text);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PFC_METALLIKAAS', PFC_METALLIKAASCombo.Text);
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'SWARM_TENANT', Trim(SWARM_TENANTEdit.Text));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'SHELL_DEFAULT', Trim(SHELL_DEFAULTCombo.Text));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PYTHON', Trim(PYTHONCombo.Text));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PYTHON_PYENV', Trim(PYTHON_PYENVCombo.Text));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'GOLANG', Trim(GOLANGCombo.Text));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'NODEJS', Trim(NODEJSCombo.Text));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PHP', Trim(PHPCombo.Text));
        RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'WSL_WINDOWS_PROXY', Trim(WSL_WINDOWS_PROXYCombo.Text));

        Result := True;
    end;
end;
