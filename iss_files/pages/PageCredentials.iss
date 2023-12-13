// ---------- Left side (CUID)

AuthentCuidTitle := TLabel.Create(PageCredentials);
with AuthentCuidTitle do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:AuthentCuidTitle}');
    Top := AuthentCuidTitle.Top + ScaleY(15);
    Left := 0;
    Width := ScaleX(MainPageWidth div 2);
    Height := ScaleY(15);
    Font.Style := [fsBold];
    Font.Size := 10;
    Font.Color := clBlue
    AutoSize := False;
    WordWrap := False;
end;

// WIN_USERNAME
WIN_USERNAMELabel := TLabel.Create(PageCredentials);
with WIN_USERNAMELabel do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Caption := ExpandConstant('{cm:WIN_USERNAME}');
    Left := AuthentCuidTitle.Left;
    Top := AuthentCuidTitle.Top + AuthentCuidTitle.Height + ScaleY(10);
    Width := ScaleX(80);
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [fsBold];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
end;

WIN_USERNAMEEdit := TNewEdit.Create(PageCredentials);
with WIN_USERNAMEEdit do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Left := WIN_USERNAMELabel.Left;
    Top := WIN_USERNAMELabel.Top + WIN_USERNAMELabel.Height + ScaleY(8);
    Width := WIN_USERNAMELabel.Width;
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
end;

// WIN_USER_PASSWORD
WIN_USER_PASSWORDLabel := TLabel.Create(PageCredentials);
with WIN_USER_PASSWORDLabel do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Caption := ExpandConstant('{cm:WIN_USER_PASSWORD}');
    Left := WIN_USERNAMELabel.Left + WIN_USERNAMELabel.Width + ScaleX(10);
    Top := WIN_USERNAMELabel.Top;
    Width := ScaleX(140);
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [fsBold];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
end;

WIN_USER_PASSWORDEdit := TPasswordEdit.Create(PageCredentials);
with WIN_USER_PASSWORDEdit do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Left := WIN_USER_PASSWORDLabel.Left;
    Top := WIN_USERNAMEEdit.Top;
    Width := WIN_USER_PASSWORDLabel.Width;
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
end;

AuthentWslMessage := TLabel.Create(PageCredentials);
with AuthentWslMessage do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:AuthentWslMessage}');
    Top := WIN_USERNAMEEdit.Top + WIN_USERNAMEEdit.Height + ScaleY(15);
    Left := AuthentCuidTitle.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Width := WIN_USERNAMELabel.Width + WIN_USER_PASSWORDLabel.Width + ScaleX(10);
    AutoSize := True;
    WordWrap := True;
    Visible := False;
end;

AuthentCuidMessage := TLabel.Create(PageCredentials);
with AuthentCuidMessage do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:AuthentCuidMessage}');
    Top := WIN_USERNAMEEdit.Top + WIN_USERNAMEEdit.Height + ScaleY(15);
    Left := AuthentCuidTitle.Left;
    Width := WIN_USERNAMELabel.Width + WIN_USER_PASSWORDLabel.Width + ScaleX(10);
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := True;
    WordWrap := True;
end;

// ---------- Right side (LDAP)

AuthentLdapTitle := TLabel.Create(PageCredentials);
with AuthentLdapTitle do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:AuthentLdapTitle}');
    Top := AuthentLdapTitle.Top + ScaleY(15);
    Left := ScaleX(MainPageWidth div 2);
    Font.Style := [fsBold];
    Font.Size := 10;
    Font.Color := clBlue
    AutoSize := False;
    WordWrap := False;
    Visible := False;
    Width := ScaleX(MainPageWidth div 2);
    Height := ScaleY(15);
end;

// USER_NAME
USER_NAMELabel := TLabel.Create(PageCredentials);
with USER_NAMELabel do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Caption := ExpandConstant('{cm:USER_NAME}');
    Left := AuthentLdapTitle.Left;
    Top := AuthentLdapTitle.Top + AuthentLdapTitle.Height + ScaleY(10);
    Width := ScaleX(100);
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [fsBold];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
    Visible := False;
end;

USER_NAMEEdit := TNewEdit.Create(PageCredentials);
with USER_NAMEEdit do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Left := USER_NAMELabel.Left;
    Top := USER_NAMELabel.Top + USER_NAMELabel.Height + ScaleY(8);
    Width := USER_NAMELabel.Width;
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
    Visible := False;
end;

// USER_PASSWORD
USER_PASSWORDLabel := TLabel.Create(PageCredentials);
with USER_PASSWORDLabel do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Caption := ExpandConstant('{cm:USER_PASSWORD}');
    Left := USER_NAMEEdit.Left + USER_NAMEEdit.Width + ScaleX(10);
    Top := AuthentLdapTitle.Top + AuthentLdapTitle.Height + ScaleY(10);
    Width := ScaleX(140);
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [fsBold];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
    Visible := False;
end;

USER_PASSWORDEdit := TPasswordEdit.Create(PageCredentials);
with USER_PASSWORDEdit do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Left := USER_PASSWORDLabel.Left;
    Top := USER_PASSWORDLabel.Top + USER_PASSWORDLabel.Height + ScaleY(8);
    Width := USER_PASSWORDLabel.Width;
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
    Visible := False;
end;

AuthentLdapMessage := TLabel.Create(PageCredentials);
with AuthentLdapMessage do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:AuthentLdapMessage}');
    Top := USER_NAMEEdit.Top + USER_NAMEEdit.Height + ScaleY(15);
    Left := AuthentLdapTitle.Left;
    Width := AuthentLdapTitle.Width;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := True;
    WordWrap := True;
    Visible := False;
end;

// USER_PASSPHRASE
USER_PASSPHRASELabel := TLabel.Create(PageCredentials);
with USER_PASSPHRASELabel do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Caption := ExpandConstant('{cm:USER_PASSPHRASE}');
    Left := 0;
    Top := AuthentCuidMessage.Top + AuthentCuidMessage.Height + ScaleY(60);
    Width := ScaleX(MainPageWidth div 3) * 1;
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [fsBold];
    Font.Color := clBlue;
    Font.Size := 10;
end;

USER_PASSPHRASEEdit := TPasswordEdit.Create(PageCredentials);
with USER_PASSPHRASEEdit do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Left := USER_PASSPHRASELabel.Left;
    Top := USER_PASSPHRASELabel.Top + USER_PASSPHRASELabel.Height + ScaleY(8);
    Width := USER_PASSPHRASELabel.Width;
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
end;

// SSH passphrase warning
SshPassphraseTitle := TLabel.Create(PageCredentials);
with SshPassphraseTitle do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:PageCredentialsSshPassphraseTitle}');
    Top := AuthentCuidMessage.Top + AuthentCuidMessage.Height + ScaleY(60);
    Left := USER_PASSPHRASELabel.Left + USER_PASSPHRASELabel.Width + ScaleX(40);
    Width := ScaleX(MainPageWidth div 3) * 2;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := True;
    WordWrap := True;
end;

SshPassphraseMessageCommon := TLabel.Create(PageCredentials);
with SshPassphraseMessageCommon do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Caption :=
        ExpandConstant('{cm:PageCredentialsSshPassphraseMessageCommon1}') + #13#10 + \
        ExpandConstant('{cm:PageCredentialsSshPassphraseMessageCommon2}') + #13#10 + \
        ExpandConstant('{cm:PageCredentialsSshPassphraseMessageCommon3}') + #13#10 + \
        ExpandConstant('{cm:PageCredentialsSshPassphraseMessageCommon4}') + #13#10 + \
        ExpandConstant('{cm:PageCredentialsSshPassphraseMessageCommon5}') + #13#10 + \
        ExpandConstant('{cm:PageCredentialsSshPassphraseMessageCommon6}');
    Top := SshPassphraseTitle.Top + SshPassphraseTitle.Height + ScaleY(8);
    Left := SshPassphraseTitle.Left;
    Width := SshPassphraseTitle.Width;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Font.Color := clRed;
    AutoSize := True;
    WordWrap := True;
end;

SshPassphraseMessageLdap := TLabel.Create(PageCredentials);
with SshPassphraseMessageLdap do
begin
    Parent := PageCredentials.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:PageCredentialsSshPassphraseMessageLdap1}');
    Top := SshPassphraseMessageCommon.Top + SshPassphraseMessageCommon.Height;
    Left := SshPassphraseTitle.Left;
    Width := SshPassphraseTitle.Width;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Font.Color := clRed;
    AutoSize := True;
    WordWrap := True;
end;

// Show password checkbox
ShowPasswordCheckCredentials := TNewCheckBox.Create(PageCredentials);
ShowPasswordCheckCredentials.Parent := PageCredentials.Surface;
ShowPasswordCheckCredentials.Top := SshPassphraseMessageCommon.Top + SshPassphraseMessageCommon.Height + ScaleY(20);
ShowPasswordCheckCredentials.Caption := ExpandConstant('{cm:GlobalShowPasswords}');
ShowPasswordCheckCredentials.Height := ScaleY(ShowPasswordCheckCredentials.Height);
ShowPasswordCheckCredentials.Width := SshPassphraseTitle.Width + ScaleX(20);
ShowPasswordCheckCredentials.OnClick := @ShowPasswordPageCredentials;
ShowPasswordCheckCredentials.Anchors := [akLeft, akTop];

// Set initial values
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'WIN_USERNAME', PreviousWIN_USERNAME) then begin
    WIN_USERNAMEEdit.Text := Trim(PreviousWIN_USERNAME);
end;
if (VarIsNull(PreviousWIN_USERNAME)) or (Length(PreviousWIN_USERNAME) = 0) then begin
    if RegQueryStringValue(HKLM, 'SOFTWARE\e-Buro', 'LastUser', PreviousWIN_USERNAME) then begin
        PageUserInformation.Values[1] := Trim(PreviousWIN_USERNAME);
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'DEBEMAIL', PreviousDEBEMAIL) then begin
    PageUserInformation.Values[1] := Trim(PreviousDEBEMAIL);
end;
if (VarIsNull(PreviousDEBEMAIL)) or (Length(PreviousDEBEMAIL) = 0) then begin
    if RegQueryStringValue(HKLM, 'SOFTWARE\e-Buro', 'LastUserEmail', PreviousDEBEMAIL) then begin
        PageUserInformation.Values[1] := Trim(PreviousDEBEMAIL);
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'WIN_USER_PASSWORD', PreviousWIN_USER_PASSWORD) then begin
    WIN_USER_PASSWORDEdit.Text := PreviousWIN_USER_PASSWORD;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_NAME', PreviousUSER_NAME) then begin
    USER_NAMEEdit.Text := Trim(PreviousUSER_NAME);
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'USER_PASSWORD', PreviousUSER_PASSWORD) then begin
    USER_PASSWORDEdit.Text := PreviousUSER_PASSWORD;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'USER_PASSPHRASE', PreviousUSER_PASSPHRASE) then begin
    USER_PASSPHRASEEdit.Text := PreviousUSER_PASSPHRASE;
end;

// Set the OnChange event for the edit boxes
WIN_USERNAMEEdit.OnChange := @EditChangePageCredentials;
WIN_USER_PASSWORDEdit.OnChange := @EditChangePageCredentials;
USER_NAMEEdit.OnChange := @EditChangePageCredentials;
USER_PASSWORDEdit.OnChange := @EditChangePageCredentials;
USER_PASSPHRASEEdit.OnChange := @EditChangePageCredentials;

// To disable the Next button initially
PageCredentials.OnActivate := @ActivatePageCredentials;
