USER_PROFILECaution := TLabel.Create(PageUserProfile);
with USER_PROFILECaution do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Caption :=
        ExpandConstant('{cm:USER_PROFILECautionLine1}') + #13#10#13#10 + \
        ExpandConstant('{cm:USER_PROFILECautionLine2}');
    Top := USER_PROFILECaution.Top + ScaleY(15);
    Left := 0;
    Width := ScaleX(MainPageWidth div 2);
    Height := USER_PROFILECaution.Height;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    Wordwrap := True;
end;

USER_PROFILEBastions := TLabel.Create(PageUserProfile);
with USER_PROFILEBastions do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Caption :=
        ExpandConstant('{cm:USER_PROFILEBastionsLine1}') + #13#10#13#10 + \
        ExpandConstant('{cm:USER_PROFILEBastionsLine2}');
    Top := USER_PROFILECaution.Top + USER_PROFILECaution.Height + ScaleY(20);
    Left := 0;
    Width := USER_PROFILECaution.Width;
    Height := USER_PROFILECaution.Height;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    Wordwrap := True;
end;

USER_PROFILEBastionsDoc := TLabel.Create(PageUserProfile);
with USER_PROFILEBastionsDoc do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('   {cm:USER_PROFILEBastionsDoc}');
    Top := USER_PROFILEBastions.Top + USER_PROFILEBastions.Height + ScaleY(5);
    Left := 0;
    Width := USER_PROFILEBastions.Width;
    Height := USER_PROFILEBastionsDoc.Height;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Font.Color := clBlue;
    Cursor := crHand;
    AutoSize := True;
    Wordwrap := False;
    OnClick := @LinkClickBastionsDoc;
    Visible := False;
end;

VDICaution := TLabel.Create(PageUserProfile);
with VDICaution do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Caption :=
        ExpandConstant('{cm:LswCautionLine1}') + #13#10 + \
        ExpandConstant('{cm:LswCautionLine2}') + #13#10#13#10 + \
        ExpandConstant('{cm:LswCautionLine3}');
    Top := USER_PROFILEBastionsDoc.Top + USER_PROFILEBastionsDoc.Height + ScaleY(20);
    Left := 0;
    Width := USER_PROFILECaution.Width;
    Height := USER_PROFILECaution.Height;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    Wordwrap := True;
    Visible := False;
end;

USER_PROFILELabel := TLabel.Create(PageUserProfile);
with USER_PROFILELabel do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:WichUSER_PROFILE}');
    Top := USER_PROFILECaution.Top;
    Left := USER_PROFILECaution.width + ScaleX(20);
    Font.Style := [fsBold];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleX(130);
end;

USER_PROFILECombo := TNewComboBox.Create(PageUserProfile);
with USER_PROFILECombo do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Left := USER_PROFILELabel.Left;
    Top := USER_PROFILELabel.Top + USER_PROFILELabel.Height + ScaleY(8);
    Width := ScaleX(50);
    Style := csDropDownList;
    Items.Add(ExpandConstant('{cm:UserProfileOps}'));
    Items.Add(ExpandConstant('{cm:UserProfileDev}'));
end;

USER_HAS_VDILabel := TLabel.Create(PageUserProfile);
with USER_HAS_VDILabel do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := True;
    Width := ScaleX(130);
    Caption := ExpandConstant('{cm:DoYouHaveVdi}');
    Top := USER_PROFILECaution.Top;
    Left := USER_PROFILELabel.Left + USER_PROFILELabel.Width + ScaleX(20);
    Font.Style := [fsBold];
    Font.Size := GlobalFontSize;
end;

USER_HAS_VDICombo := TNewComboBox.Create(PageUserProfile);
with USER_HAS_VDICombo do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Left := USER_HAS_VDILabel.Left;
    Top := USER_HAS_VDILabel.Top + USER_HAS_VDILabel.Height + ScaleY(8);
    Width := ScaleX(50);
    Style := csDropDownList;
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
end;

USER_HAS_LDAPLabel := TLabel.Create(PageUserProfile);
with USER_HAS_LDAPLabel do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Width := ScaleX(170);
    Caption := ExpandConstant('{cm:DoYouHaveLdap}');
    Top := USER_PROFILECombo.Top + USER_PROFILECombo.Height + ScaleY(10);
    Left := USER_PROFILELabel.Left;
    Font.Style := [fsBold];
    Font.Size := GlobalFontSize;
end;

LDAP_HOSTLabel := TLabel.Create(PageUserProfile);
with LDAP_HOSTLabel do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Width := ScaleX(100);
    Caption := ExpandConstant('{cm:WichLDAP_HOST}');
    Top := USER_HAS_LDAPLabel.Top;
    Left := USER_HAS_LDAPLabel.Left + USER_HAS_LDAPLabel.Width + ScaleX(10);
    Font.Style := [fsBold];
    Font.Size := GlobalFontSize;
    Visible := False;
end;

USER_HAS_LDAPCombo := TNewComboBox.Create(PageUserProfile);
with USER_HAS_LDAPCombo do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Width := ScaleX(50);
    Left := USER_PROFILECombo.Left;
    Top := USER_HAS_LDAPLabel.Top + USER_HAS_LDAPLabel.Height + ScaleY(8);
    Style := csDropDownList;
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
end;

LDAP_HOSTCombo := TNewComboBox.Create(PageUserProfile);
with LDAP_HOSTCombo do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Width := ScaleX(200);
    Left := USER_HAS_LDAPCombo.Left + USER_HAS_LDAPCombo.Width + ScaleX(10);
    Top := LDAP_HOSTLabel.Top + LDAP_HOSTLabel.Height + ScaleY(8);
    Style := csDropDownList;
    Font.Size := GlobalFontSize;
    Items.Add('{#LdapHostFtiNet}');
    Visible := False;
end;

USER_HAS_BASTIONLabel := TLabel.Create(PageUserProfile);
with USER_HAS_BASTIONLabel do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Width := ScaleX(170);
    Caption := ExpandConstant('{cm:DoYouHaveBastion}');
    Top := USER_HAS_LDAPCombo.Top + USER_HAS_LDAPCombo.Height + ScaleY(10);
    Left := USER_HAS_LDAPCombo.Left;
    Font.Style := [fsBold];
    Font.Size := GlobalFontSize;
end;

BASTION_HOSTLabel := TLabel.Create(PageUserProfile);
with BASTION_HOSTLabel do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Width := ScaleX(80);
    Caption := ExpandConstant('{cm:WichBASTION_HOST}');
    Top := USER_HAS_BASTIONLabel.Top;
    Left := USER_HAS_BASTIONLabel.Left + USER_HAS_BASTIONLabel.Width + ScaleX(10);
    Font.Style := [fsBold];
    Font.Size := GlobalFontSize;
end;

USER_HAS_BASTIONCombo := TNewComboBox.Create(PageUserProfile);
with USER_HAS_BASTIONCombo do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Width := ScaleX(50);
    Left := USER_HAS_BASTIONLabel.Left;
    Top := USER_HAS_BASTIONLabel.Top + USER_HAS_BASTIONLabel.Height + ScaleY(8);
    Style := csDropDownList;
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
end;

BASTION_HOSTCombo := TNewComboBox.Create(PageUserProfile);
with BASTION_HOSTCombo do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Width := ScaleX(200);
    Left := USER_HAS_BASTIONCombo.Left + USER_HAS_BASTIONCombo.Width + ScaleX(10);
    Top := BASTION_HOSTLabel.Top + BASTION_HOSTLabel.Height + ScaleY(8);
    Style := csDropDownList;
    Font.Size := GlobalFontSize;
    Items.Add('{#BastionPfcAdm}');
    Items.Add('{#BastionPfcRsc}');
end;

INSTALL_LSW_ON_VDILabel := TLabel.Create(PageUserProfile);
with INSTALL_LSW_ON_VDILabel do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Width := ScaleX(MainPageWidth div 2);
    Caption := ExpandConstant('{cm:WhereInstallLsw}');
    Top := BASTION_HOSTCombo.Top + BASTION_HOSTCombo.Height + ScaleY(10);
    Left := USER_PROFILECaution.Width + ScaleX(20);
    Font.Style := [fsBold];
    Font.Size := GlobalFontSize;
    Visible := False;
end;

INSTALL_LSW_ON_VDICombo := TNewComboBox.Create(PageUserProfile);
with INSTALL_LSW_ON_VDICombo do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Width := ScaleX(50);
    Left := USER_PROFILECombo.Left;
    Top := INSTALL_LSW_ON_VDILabel.Top + INSTALL_LSW_ON_VDILabel.Height + ScaleY(8);
    Style := csDropDownList;
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    Visible := False;
end;

// VDI_HOSTNAME
VDI_HOSTNAMELabel := TLabel.Create(PageUserProfile);
with VDI_HOSTNAMELabel do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Caption := ExpandConstant('{cm:VdiHostname}');
    Left := INSTALL_LSW_ON_VDILabel.Left;
    Top := INSTALL_LSW_ON_VDICombo.Top + INSTALL_LSW_ON_VDICombo.Height + ScaleY(10);
    Width := ScaleX(180);
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [fsBold];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
    Visible := False;
end;

VDI_HOSTNAMEEdit := TNewEdit.Create(PageUserProfile);
with VDI_HOSTNAMEEdit do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Left := VDI_HOSTNAMELabel.Left;
    Top := VDI_HOSTNAMELabel.Top + VDI_HOSTNAMELabel.Height + ScaleY(8);
    Width := VDI_HOSTNAMELabel.Width;
    Height := ScaleY(20);
    Color := $F0F0F0;
    Font.Style := [];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
    Visible := False;
end;

// VDI_IPADDRESS
VDI_IPADDRESSLabel := TLabel.Create(PageUserProfile);
with VDI_IPADDRESSLabel do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Caption := ExpandConstant('{cm:VdiIpAddress}');
    Left := VDI_HOSTNAMELabel.Left + VDI_HOSTNAMELabel.Width + ScaleX(10);
    Top := INSTALL_LSW_ON_VDICombo.Top + INSTALL_LSW_ON_VDICombo.Height + ScaleY(10);
    Width := ScaleX(90);
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [fsBold];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
    Visible := False;
end;

VDI_IPADDRESSEdit := TNewEdit.Create(PageUserProfile);
with VDI_IPADDRESSEdit do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Left := VDI_IPADDRESSLabel.Left;
    Top := VDI_IPADDRESSLabel.Top + VDI_IPADDRESSLabel.Height + ScaleY(8);
    Width := VDI_IPADDRESSLabel.Width;
    Height := ScaleY(20);
    Color := $F0F0F0;
    Font.Style := [];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
    Visible := False;
end;

VDIWontInstall := TLabel.Create(PageUserProfile);
with VDIWontInstall do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:VdiWontInstall}');
    Top := VDI_IPADDRESSEdit.Top + VDI_IPADDRESSEdit.Height + ScaleY(10);
    Left := INSTALL_LSW_ON_VDILabel.Left;
    Width := ScaleX(MainPageWidth div 2);
    Font.Style := [];
    Font.Size := GlobalFontSize;
    WordWrap := True;
    Visible := False;
end;

// VDI message
VdiTitle := TLabel.Create(PageUserProfile);
with VdiTitle do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:PageUserProfileVdiTitle}');
    Top := VDIWontInstall.Top + VDIWontInstall.Height + ScaleY(15);
    Left := 0;
    Font.Style := [fsItalic];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    Wordwrap := False;
    Visible := False;
end;

VdiMessage := TLabel.Create(PageUserProfile);
with VdiMessage do
begin
    Parent := PageUserProfile.Surface;
    Anchors := [akLeft, akTop];
    Caption := '         {#VdiPortalURL}';
    Top := VdiTitle.Top;
    Left := VdiTitle.Left + VdiTitle.Width;
    Font.Style := [fsItalic];
    Font.Size := GlobalFontSize;
    Font.Color := clBlue;
    Cursor := crHand;
    AutoSize := True;
    Wordwrap := False;
    OnClick := @LinkClickVdiPortal;
    Visible := False;
end;

// Restore values
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_PROFILE', PreviousUSER_PROFILE) then begin
    case Trim(PreviousUSER_PROFILE) of
        'OPS', 'OPS_LDAP', 'OPS_LDAP_ADM', 'OPS_LDAP_RSC':
            begin
            USER_PROFILECombo.ItemIndex := 0;
            end;
        'DEV', 'DEV_LDAP', 'DEV_LDAP_ADM', 'DEV_LDAP_RSC':
            begin
            USER_PROFILECombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_HAS_VDI', PreviousUSER_HAS_VDI) then begin
    case Trim(Lowercase(PreviousUSER_HAS_VDI)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            USER_HAS_VDICombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            USER_HAS_VDICombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_HAS_LDAP', PreviousUSER_HAS_LDAP) then begin
    case Trim(Lowercase(PreviousUSER_HAS_LDAP)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            USER_HAS_LDAPCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            USER_HAS_LDAPCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'LDAP_HOST', PreviousLDAP_HOST) then begin
    case Trim(PreviousLDAP_HOST) of
        '{#LdapHostFtiNet}':
            begin
            LDAP_HOSTCombo.ItemIndex := 0;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_HAS_BASTION', PreviousUSER_HAS_BASTION) then begin
    case Trim(Lowercase(PreviousUSER_HAS_BASTION)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            USER_HAS_BASTIONCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            USER_HAS_BASTIONCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'BASTION_HOST', PreviousBASTION_HOST) then begin
    case Trim(Lowercase(PreviousBASTION_HOST)) of
        '{#BastionPfcAdm}':
            begin
            BASTION_HOSTCombo.ItemIndex := 0;
            end;
        '{#BastionPfcRsc}':
            begin
            BASTION_HOSTCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'INSTALL_LSW_ON_VDI', PreviousINSTALL_LSW_ON_VDI) then begin
    if PreviousINSTALL_LSW_ON_VDI <> '' then begin
        case Trim(Lowercase(PreviousINSTALL_LSW_ON_VDI)) of
            'yes', 'y', 'oui', 'o', 'true', 't', '1':
                begin
                INSTALL_LSW_ON_VDICombo.ItemIndex := 0;
                end;
            'no', 'n', 'non', 'false', 'f', '0', '':
                begin
                INSTALL_LSW_ON_VDICombo.ItemIndex := 1;
                end;
        end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'VDI_HOSTNAME', PreviousVDI_HOSTNAME) then begin
    VDI_HOSTNAMEEdit.Text := Trim(PreviousVDI_HOSTNAME);
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'VDI_IPADDRESS', PreviousVDI_IPADDRESS) then begin
    VDI_IPADDRESSEdit.Text := Trim(PreviousVDI_IPADDRESS);
end;

// Set the OnChange event for the edit boxes
USER_PROFILECombo.OnChange := @EditChangePageUserProfile;
USER_HAS_VDICombo.OnChange := @EditChangePageUserProfile;
USER_HAS_LDAPCombo.OnChange := @EditChangePageUserProfile;
USER_HAS_BASTIONCombo.OnChange := @EditChangePageUserProfile;
LDAP_HOSTCombo.OnChange := @EditChangePageUserProfile;
BASTION_HOSTCombo.OnChange := @EditChangePageUserProfile;
INSTALL_LSW_ON_VDICombo.OnChange := @EditChangePageUserProfile;
VDI_HOSTNAMEEdit.OnChange := @EditChangePageUserProfile;
VDI_IPADDRESSEdit.OnChange := @EditChangePageUserProfile;

// Disable the Next button initially
PageUserProfile.OnActivate := @ActivatePageUserProfile;
