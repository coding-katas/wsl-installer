procedure ValidatePagePageUserProfile;
var
    VDI_HOSTNAME, VDI_IPADDRESS: string;
    UserProfileChecked: Boolean;
    USER_HAS_LDAPChecked, LDAP_HOSTChecked: Boolean;
    USER_HAS_BASTIONChecked, BASTION_HOSTChecked: Boolean;
    VdiChecked, INSTALL_LSW_ON_VDIChecked: Boolean;
begin
    case USER_HAS_LDAPCombo.Text of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            LDAP_HOSTLabel.Visible := True;
            LDAP_HOSTCombo.Visible := True;
            SshPassphraseMessageLdap.Visible := True;
            AuthentLdapMessage.Visible := True;
            USER_HAS_BASTIONLabel.Visible := True;
            USER_HAS_BASTIONCombo.Visible := True;

            PFC_PICAASSOCombo.Enabled := True;
            PFC_WAMPAASCombo.Enabled := True;
            PFC_WAMPAASCombo.ItemIndex := 0;
            PFC_RICKAASTLEYCombo.Enabled := True;
            PFC_RICKAASTLEYCombo.ItemIndex := 0;
            end;
        'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            LDAP_HOSTLabel.Visible := False;
            LDAP_HOSTCombo.Visible := False;
            LDAP_HOSTCombo.ItemIndex := -1;
            SshPassphraseMessageLdap.Visible := False;
            AuthentLdapMessage.Visible := False;
            USER_HAS_BASTIONLabel.Visible := False;
            USER_HAS_BASTIONCombo.Visible := False;
            USER_HAS_BASTIONCombo.ItemIndex := -1;
            BASTION_HOSTLabel.Visible := False;
            BASTION_HOSTCombo.Visible := False;

            PFC_PICAASSOCombo.Enabled := False;
            PFC_PICAASSOCombo.ItemIndex := 1;
            PFC_WAMPAASCombo.Enabled := False;
            PFC_WAMPAASCombo.ItemIndex := 1;
            PFC_RICKAASTLEYCombo.Enabled := False;
            PFC_RICKAASTLEYCombo.ItemIndex := 1;
            end;
    end;

    case USER_HAS_BASTIONCombo.Text of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            BASTION_HOSTLabel.Visible := True;
            BASTION_HOSTCombo.Visible := True;
            USER_PROFILEBastions.Visible := True;
            USER_PROFILEBastionsDoc.Visible := True;
            end;
        'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            USER_PROFILEBastions.Visible := False;
            USER_PROFILEBastionsDoc.Visible := False;
            BASTION_HOSTLabel.Visible := False;
            BASTION_HOSTCombo.Visible := False;
            BASTION_HOSTCombo.ItemIndex := -1;
            end;
    end;

    case INSTALL_LSW_ON_VDICombo.Text of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            VDI_HOSTNAMELabel.Visible := True;
            VDI_HOSTNAMEEdit.Visible := True;
            VDI_IPADDRESSLabel.Visible := True;
            VDI_IPADDRESSEdit.Visible := True;
            VDIWontInstall.Visible := False;
            VdiTitle.Visible := True;
            VdiMessage.Visible := True;
            end;
        'no', 'n', 'non', 'false', 'f', '0':
            begin
            VDI_HOSTNAMELabel.Visible := True;
            VDI_HOSTNAMEEdit.Visible := True;
            VDI_IPADDRESSLabel.Visible := True;
            VDI_IPADDRESSEdit.Visible := True;
            VDIWontInstall.Visible := True;
            VdiTitle.Visible := True;
            VdiMessage.Visible := True;
            end;
        '':
            begin
            VDI_HOSTNAMELabel.Visible := False;
            VDI_HOSTNAMEEdit.Visible := False;
            VDI_IPADDRESSLabel.Visible := False;
            VDI_IPADDRESSEdit.Visible := False;
            VDIWontInstall.Visible := False;
            VdiTitle.Visible := False;
            VdiMessage.Visible := False;
            end;
    end;

    case USER_HAS_VDICombo.Text of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            INSTALL_LSW_ON_VDICombo.Visible := True;
            VDICaution.Visible := True;
            INSTALL_LSW_ON_VDILabel.Visible := True;
            VDI_HOSTNAMELabel.Visible := True;
            VDI_HOSTNAMEEdit.Visible := True;
            VDI_IPADDRESSLabel.Visible := True;
            VDI_IPADDRESSEdit.Visible := True;
            INSTALL_LSW_ON_VDIChecked := (CompareText(INSTALL_LSW_ON_VDICombo.Text, '') <> 0);
            end;
        'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            INSTALL_LSW_ON_VDICombo.Visible := False;
            VDICaution.Visible := False;
            VDIWontInstall.Visible := False;
            INSTALL_LSW_ON_VDILabel.Visible := False;
            VDI_HOSTNAMELabel.Visible := False;
            VDI_HOSTNAMEEdit.Visible := False;
            VDI_IPADDRESSLabel.Visible := False;
            VDI_IPADDRESSEdit.Visible := False;
            VdiTitle.Visible := False;
            VdiMessage.Visible := False;
            INSTALL_LSW_ON_VDIChecked := True;
            VDI_HOSTNAMEEdit.Text := '';
            VDI_IPADDRESSEdit.Text := '';
            end;
    end;

    UserProfileChecked := (CompareText(USER_PROFILECombo.Text, '') <> 0);

    USER_HAS_LDAPChecked := (CompareText(USER_HAS_LDAPCombo.Text, '') <> 0);
    LDAP_HOSTChecked := (USER_HAS_LDAPCombo.Text = ExpandConstant('{cm:NoMessage}')) or (CompareText(LDAP_HOSTCombo.Text, '') <> 0);

    USER_HAS_BASTIONChecked := (USER_HAS_LDAPCombo.Text = ExpandConstant('{cm:NoMessage}')) or (USER_HAS_BASTIONCombo.Text = ExpandConstant('{cm:NoMessage}')) or (USER_HAS_BASTIONCombo.Text = ExpandConstant('{cm:YesMessage}'));
    BASTION_HOSTChecked := (USER_HAS_LDAPCombo.Text = ExpandConstant('{cm:NoMessage}')) or (USER_HAS_BASTIONCombo.Text = ExpandConstant('{cm:NoMessage}')) or (CompareText(BASTION_HOSTCombo.Text, '') <> 0);

    VdiChecked := True;
    VDI_HOSTNAME := VDI_HOSTNAMEEdit.Text;
    VDI_IPADDRESS := VDI_IPADDRESSEdit.Text;
    if (USER_HAS_VDICombo.Text = ExpandConstant('{cm:YesMessage}')) or (INSTALL_LSW_ON_VDICombo.Text = ExpandConstant('{cm:YesMessage}')) then begin
        VdiChecked :=
            (CompareText(VDI_HOSTNAME, '') <> 0) and
            (CompareText(VDI_IPADDRESS, '') <> 0) and
            ValidateIP(VDI_IPADDRESS);
    end;
    Log(Format('UserProfileChecked %s', [IntToStr(Integer(UserProfileChecked))]))
    Log(Format('USER_HAS_LDAPChecked %s', [IntToStr(Integer(USER_HAS_LDAPChecked))]))
    Log(Format('VdiChecked %s', [IntToStr(Integer(VdiChecked))]))
    WizardForm.NextButton.Enabled :=
        UserProfileChecked and
        INSTALL_LSW_ON_VDIChecked and
        USER_HAS_BASTIONChecked and BASTION_HOSTChecked and
        USER_HAS_LDAPChecked and LDAP_HOSTChecked and
        VdiChecked;
end;

// User informations page validate
procedure ValidatePageUserInformation;
var
    DEBFULLNAME, DEBEMAIL: string;
begin
    DEBFULLNAME := PageUserInformation.Values[0];
    DEBEMAIL := PageUserInformation.Values[1];

    WizardForm.NextButton.Enabled :=
        (CompareText(DEBFULLNAME, '') <> 0) and
        (CompareText(DEBEMAIL, '') <> 0);
end;

// GitLab informations page validate
procedure ValidatePageGitLabInformation;
var
    GITLAB_PRIVATE_TOKEN_DIOD, GITLAB_PRIVATE_TOKEN_SPIRIT: string;
    GitlabChecked, GitlabDiodChecked, GitlabSpiritChecked: Boolean;
begin
    GITLAB_PRIVATE_TOKEN_DIOD := PageGitLabInformation.Values[1];
    GITLAB_PRIVATE_TOKEN_SPIRIT := PageGitLabInformation.Values[2];

    case GITLAB_HOSTCombo.Text of
       '{#GITLAB_HOSTDiod}':
            begin
            PageGitLabInformation.PromptLabels[1].Visible := True;
            PageGitLabInformation.Edits[1].Visible := True;
            GitlabPrivateTokenDiodTitle.Visible := True;
            GitlabPrivateTokenDiodMessage.Visible := True;
            PageGitLabInformation.PromptLabels[2].Visible := False;
            PageGitLabInformation.Edits[2].Visible := False;
            GitlabPrivateTokenSpiritTitle.Visible := False;
            GitlabPrivateTokenSpiritMessage.Visible := False;
            GitlabSpiritChecked := True;
            end;
       '{#GITLAB_HOSTSpirit}':
            begin
            PageGitLabInformation.PromptLabels[1].Visible := True;
            PageGitLabInformation.Edits[1].Visible := True;
            GitlabPrivateTokenDiodTitle.Visible := True;
            GitlabPrivateTokenDiodMessage.Visible := True;
            PageGitLabInformation.PromptLabels[2].Visible := True;
            PageGitLabInformation.Edits[2].Visible := True;
            GitlabPrivateTokenSpiritTitle.Visible := True;
            GitlabPrivateTokenSpiritMessage.Visible := True;
            GitlabSpiritChecked := (CompareText(GITLAB_PRIVATE_TOKEN_SPIRIT, '') <> 0);
            end;
    end;
    GitlabDiodChecked := (CompareText(GITLAB_PRIVATE_TOKEN_DIOD, '') <> 0);
    GitlabChecked := (CompareText(GITLAB_HOSTCombo.Text, '') <> 0);

    WizardForm.NextButton.Enabled :=
        GitlabChecked and
        GitlabDiodChecked and
        GitlabSpiritChecked;
end;

// Page Credentials
procedure ValidatePageCredentials;
var
    USER_PASSWORD, WIN_USER_PASSWORD, USER_PASSPHRASE, USER_NAME, WIN_USERNAME: String;
    USER_HAS_LDAPChecked: Boolean;
begin
    WIN_USERNAME := WIN_USERNAMEEdit.Text;
    WIN_USER_PASSWORD := WIN_USER_PASSWORDEdit.Text;
    USER_NAME := USER_NAMEEdit.Text;
    USER_PASSWORD := USER_PASSWORDEdit.Text;
    USER_PASSPHRASE := USER_PASSPHRASEEdit.Text;
    USER_HAS_LDAPChecked :=
        (CompareText(USER_HAS_LDAPCombo.Text, ExpandConstant('{cm:NoMessage}')) <> 0) and
        (CompareText(LDAP_HOSTCombo.Text, '') <> 0);

    if USER_HAS_LDAPChecked then begin
        AuthentLdapTitle.Visible := True;
        USER_NAMELabel.Visible := True;
        USER_NAMEEdit.Visible := True;
        USER_PASSWORDLabel.Visible := True;
        USER_PASSWORDEdit.Visible := True;
        AuthentCuidMessage.Visible := True;
        AuthentWslMessage.Visible := False;
        LdapCredzChecked := (CompareText(USER_NAME, '') <> 0) and (CompareText(USER_PASSWORD, USER_PASSPHRASE) <> 0);
    end else begin
        AuthentLdapTitle.Visible := False;
        USER_NAMELabel.Visible := False;
        USER_NAMEEdit.Visible := False;
        USER_PASSWORDLabel.Visible := False;
        USER_PASSWORDEdit.Visible := False;
        AuthentCuidMessage.Visible := False;
        AuthentWslMessage.Visible := True;
        LdapCredzChecked := True;
        USER_NAMEEdit.Text := '';
        USER_PASSWORDEdit.Text := '';
    end;

    WizardForm.NextButton.Enabled :=
        (CompareText(WIN_USERNAME, '') <> 0) and
        (CompareText(WIN_USER_PASSWORD, '') <> 0) and
        (CompareText(USER_PASSPHRASE, '') <> 0) and
        (CompareText(WIN_USER_PASSWORD, USER_PASSPHRASE) <> 0) and
        CheckSshKeyPassphrase(USER_PASSPHRASE) and
        LdapCredzChecked;
end;

// Page Components
procedure ValidatePageComponents;
var
    BastionHost: String;
begin
    case CFYCombo.Text of
       'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            PFC_WAMPAASCombo.Enabled := True;
            PFC_MERCURYCombo.Enabled := True;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PFC_WAMPAASCombo.Enabled := False;
            PFC_WAMPAASCombo.ItemIndex := 1;
            PFC_MERCURYCombo.Enabled := False;
            PFC_MERCURYCombo.ItemIndex := 1;
            end;
    end;

    case DOCKERCombo.Text of
       'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            PFC_PICAASSOCombo.Enabled := True;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PFC_PICAASSOCombo.Enabled := False;
            PFC_PICAASSOCombo.ItemIndex := 1;
            end;
    end;

    BastionHost := Trim(Lowercase(BASTION_HOSTCombo.Text));
    if (BastionHost = '{#BastionPfcAdm}') or (BastionHost = '{#BastionPfcRsc}') then begin
        case PFC_PICAASSOCombo.Text of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
                begin
                SWARM_TENANTEdit.Enabled := True;
                end;
        'no', 'n', 'non', 'false', 'f', '0', '':
                begin
                SWARM_TENANTEdit.Text := '';
                SWARM_TENANTEdit.Enabled := False;
                end;
        end;
    end else begin
        SWARM_TENANTEdit.Text := '';
        SWARM_TENANTEdit.Enabled := False;
        PFC_PICAASSOCombo.Enabled := False;
        PFC_PICAASSOCombo.ItemIndex := 1;
    end;

    case KUBERNETESCombo.Text of
       'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin

            PFC_METALLIKAASCombo.Enabled := False;

            case USER_HAS_LDAPCombo.Text of
                'yes', 'y', 'oui', 'o', 'true', 't', '1':
                    begin
                    PFC_RICKAASTLEYCombo.Enabled := True;
                    PFC_RICKAASTLEYCombo.ItemIndex := 0;
                    end;
                'no', 'n', 'non', 'false', 'f', '0', '':
                    begin
                    PFC_RICKAASTLEYCombo.Enabled := False;
                    PFC_RICKAASTLEYCombo.ItemIndex := 1;
                    end;
            end

            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PFC_METALLIKAASCombo.Enabled := False;
            PFC_METALLIKAASCombo.ItemIndex := 1;
            PFC_RICKAASTLEYCombo.Enabled := False;
            PFC_RICKAASTLEYCombo.ItemIndex := 1;
            end;
    end;

    if (CompareText(LDAP_HOSTCombo.Text, '') = 0) then begin
        PFC_WAMPAASCombo.Enabled := False;
        PFC_WAMPAASCombo.ItemIndex := 1;
        PFC_PICAASSOCombo.Enabled := False;
        PFC_PICAASSOCombo.ItemIndex := 1;
        SWARM_TENANTEdit.Text := '';
        SWARM_TENANTEdit.Enabled := False;
        PFC_RICKAASTLEYCombo.ItemIndex := 1;
        PFC_RICKAASTLEYCombo.Enabled := False;
    end;

    WizardForm.NextButton.Enabled := True;
end;

procedure EditChangePageUserProfile(Sender: TObject);
begin
    ValidatePagePageUserProfile;
end;

procedure EditChangePageUserInformation(Sender: TObject);
begin
    ValidatePageUserInformation;
end;

procedure EditChangePageGitLabInformation(Sender: TObject);
begin
    ValidatePageGitLabInformation;
end;

procedure EditChangePageCredentials(Sender: TObject);
begin
    ValidatePageCredentials;
end;

procedure EditChangePageComponents(Sender: TObject);
begin
    ValidatePageComponents;
end;

procedure ActivatePageUserProfile(Sender: TWizardPage);
begin
    ValidatePagePageUserProfile;
end;

procedure ActivatePageUserInformation(Sender: TWizardPage);
begin
    ValidatePageUserInformation;
end;

procedure ActivatePageGitLabInformation(Sender: TWizardPage);
begin
    ValidatePageGitLabInformation;
end;

procedure ActivatePageCredentials(Sender: TWizardPage);
begin
    ValidatePageCredentials;
end;

procedure ActivatePageComponents(Sender: TWizardPage);
begin
    ValidatePageComponents;
end;

// Show passwords - Page Credentials
procedure ShowPasswordPageCredentials(Sender: TObject);
begin
    WIN_USER_PASSWORDEdit.Password := not TNewCheckBox(Sender).Checked;
    USER_PASSWORDEdit.Password := not TNewCheckBox(Sender).Checked;
    USER_PASSPHRASEEdit.Password := not TNewCheckBox(Sender).Checked;
end;

// Show passwords - Page PageGitLabInformation
procedure ShowPasswordPageGitLabInformation(Sender: TObject);
begin
    PageGitLabInformation.Edits[1].Password := not TNewCheckBox(Sender).Checked;
    PageGitLabInformation.Edits[2].Password := not TNewCheckBox(Sender).Checked;
end;
