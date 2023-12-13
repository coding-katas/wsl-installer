// GITLAB_HOST
GITLAB_HOSTLabel := TLabel.Create(PageGitLabInformation);
with GITLAB_HOSTLabel do
begin
    Parent := PageGitLabInformation.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:WichGITLAB_HOST}');
    Top := GITLAB_HOSTLabel.Top + ScaleY(15);
    Left := 0;
    Width := ScaleX((MainPageWidth div 3) * 1);
    Height := ScaleY(15);
    Font.Style := [fsBold];
    Font.Size := GlobalFontSize;
    Visible := True;
    AutoSize := False;
    WordWrap := True;
end;

GITLAB_HOSTCombo := TNewComboBox.Create(PageGitLabInformation);
with GITLAB_HOSTCombo do
begin
    Parent := PageGitLabInformation.Surface;
    Anchors := [akLeft, akTop];
    Left := GITLAB_HOSTLabel.Left;
    Top := GITLAB_HOSTLabel.Top + GITLAB_HOSTLabel.Height + ScaleY(8);
    Width := GITLAB_HOSTLabel.Width - ScaleY(40);
    Height := ScaleX(20);
    Style := csDropDownList;
    Items.Add('{#GITLAB_HOSTDiod}');
    Items.Add('{#GITLAB_HOSTSpirit}');
end;

GITLAB_HOSTMessage := TLabel.Create(PageGitLabInformation);
with GITLAB_HOSTMessage do
begin
    Parent := PageGitLabInformation.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:PageGitLabInfosMessage}');
    Top := GITLAB_HOSTLabel.Top + ScaleX(5);
    Left := GITLAB_HOSTLabel.Width + ScaleY(40);
    Width := ScaleX(MainPageWidth div 2);
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Visible := True;
    AutoSize := True;
    WordWrap := True;
end;

// GITLAB_NAMESPACES
PageGitLabInformation.Add(ExpandConstant('{cm:UserGitlabNameSpaces}'), False);
PageGitLabInformation.PromptLabels[0].Top := GITLAB_HOSTCombo.Top + GITLAB_HOSTCombo.Height + ScaleY(20);
PageGitLabInformation.PromptLabels[0].Left := GITLAB_HOSTLabel.Left;
PageGitLabInformation.PromptLabels[0].Width := ScaleX(MainPageWidth div 2) - ScaleY(40);
PageGitLabInformation.PromptLabels[0].Font.Style := [fsBold];
PageGitLabInformation.PromptLabels[0].Anchors := [akLeft, akTop];
PageGitLabInformation.Edits[0].Top := PageGitLabInformation.PromptLabels[0].Top + PageGitLabInformation.PromptLabels[0].Height + ScaleY(8);
PageGitLabInformation.Edits[0].Left := GITLAB_HOSTLabel.Left;
PageGitLabInformation.Edits[0].Width := PageGitLabInformation.PromptLabels[0].Width;
PageGitLabInformation.Edits[0].Anchors := [akLeft, akTop];

GITLAB_NAMESPACESMessage := TLabel.Create(PageGitLabInformation);
with GITLAB_NAMESPACESMessage do
begin
    Parent := PageGitLabInformation.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:PageGitLabInfosNamespaces}');
    Top := PageGitLabInformation.PromptLabels[0].Top;
    Left := PageGitLabInformation.Edits[0].Left + PageGitLabInformation.Edits[0].Width + ScaleY(20);
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Width := ScaleX(MainPageWidth div 2);
    AutoSize := True;
    WordWrap := True;
    Visible := True;
end;

// GITLAB_PRIVATE_TOKEN_DIOD
PageGitLabInformation.Add(ExpandConstant('{cm:GITLAB_PRIVATE_TOKEN_DIOD}'), True);
PageGitLabInformation.PromptLabels[1].Top := GITLAB_NAMESPACESMessage.Top + GITLAB_NAMESPACESMessage.Height + ScaleY(20);
PageGitLabInformation.PromptLabels[1].Left := 0;
PageGitLabInformation.PromptLabels[1].AutoSize := False;
PageGitLabInformation.PromptLabels[1].Width := ScaleX((MainPageWidth div 3) * 1);
PageGitLabInformation.PromptLabels[1].Font.Style := [fsBold];
PageGitLabInformation.PromptLabels[1].Font.Color := clBlue;
PageGitLabInformation.PromptLabels[1].Font.Size := 10;
PageGitLabInformation.PromptLabels[1].Visible := False;
PageGitLabInformation.PromptLabels[1].Anchors := [akLeft, akTop];
PageGitLabInformation.Edits[1].Top := PageGitLabInformation.PromptLabels[1].Top + PageGitLabInformation.PromptLabels[1].Height + ScaleY(8);
PageGitLabInformation.Edits[1].Left := PageGitLabInformation.PromptLabels[1].Left;
PageGitLabInformation.Edits[1].AutoSize := False;
PageGitLabInformation.Edits[1].Width := PageGitLabInformation.PromptLabels[1].Width;
PageGitLabInformation.Edits[1].Visible := False;
PageGitLabInformation.Edits[1].Anchors := [akLeft, akTop];

GitlabPrivateTokenDiodTitle := TLabel.Create(PageGitLabInformation);
with GitlabPrivateTokenDiodTitle do
begin
    Parent := PageGitLabInformation.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:PageGitLabInformationGitlabPrivateTokenTitle}');
    Top := PageGitLabInformation.PromptLabels[1].Top;
    Left := PageGitLabInformation.PromptLabels[1].Left + PageGitLabInformation.PromptLabels[1].Width + ScaleY(20);
    Width := ScaleX((MainPageWidth div 3) * 2);
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := True;
    WordWrap := True;
    Visible := False;
end;
GitlabPrivateTokenDiodMessage := TLabel.Create(PageGitLabInformation);
with GitlabPrivateTokenDiodMessage do
begin
    Parent := PageGitLabInformation.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('    {cm:PageGitLabInformationGitLabUrlToken,{#GITLAB_HOSTDiod}}');
    Top := GitlabPrivateTokenDiodTitle.Top + GitlabPrivateTokenDiodTitle.Height + ScaleY(8);
    Left := GitlabPrivateTokenDiodTitle.Left;
    Width := GitlabPrivateTokenDiodTitle.Width;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Font.Color := clBlue;
    Cursor := crHand;
    OnClick := @LinkClickGitLabUrlDiodToken;
    AutoSize := True;
    WordWrap := True;
    Visible := False;
end;

// GITLAB_PRIVATE_TOKEN_SPIRIT
PageGitLabInformation.Add(ExpandConstant('{cm:GITLAB_PRIVATE_TOKEN_SPIRIT}'), True);
PageGitLabInformation.PromptLabels[2].Top := GitlabPrivateTokenDiodMessage.Top + GitlabPrivateTokenDiodMessage.Height + ScaleY(40);
PageGitLabInformation.PromptLabels[2].Left := 0;
PageGitLabInformation.PromptLabels[2].AutoSize := False;
PageGitLabInformation.PromptLabels[2].Width := ScaleX((MainPageWidth div 3) * 1);
PageGitLabInformation.PromptLabels[2].Font.Style := [fsBold];
PageGitLabInformation.PromptLabels[2].Font.Color := clBlue;
PageGitLabInformation.PromptLabels[2].Font.Size := 10;
PageGitLabInformation.PromptLabels[2].Visible := False;
PageGitLabInformation.PromptLabels[2].Anchors := [akLeft, akTop];
PageGitLabInformation.Edits[2].Top := PageGitLabInformation.PromptLabels[2].Top + PageGitLabInformation.PromptLabels[2].Height + ScaleY(8);
PageGitLabInformation.Edits[2].Left := PageGitLabInformation.PromptLabels[2].Left;
PageGitLabInformation.Edits[2].AutoSize := False;
PageGitLabInformation.Edits[2].Width := PageGitLabInformation.PromptLabels[2].Width;
PageGitLabInformation.Edits[2].Visible := False;
PageGitLabInformation.Edits[2].Anchors := [akLeft, akTop];

GitlabPrivateTokenSpiritTitle := TLabel.Create(PageGitLabInformation);
with GitlabPrivateTokenSpiritTitle do
begin
    Parent := PageGitLabInformation.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:PageGitLabInformationGitlabPrivateTokenTitle}');
    Top := PageGitLabInformation.PromptLabels[2].Top;
    Left := PageGitLabInformation.PromptLabels[2].Left + PageGitLabInformation.PromptLabels[2].Width + ScaleY(20);
    Width := ScaleX((MainPageWidth div 3) * 2);
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := True;
    WordWrap := True;
    Visible := False;
end;
GitlabPrivateTokenSpiritMessage := TLabel.Create(PageGitLabInformation);
with GitlabPrivateTokenSpiritMessage do
begin
    Parent := PageGitLabInformation.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('    {cm:PageGitLabInformationGitLabUrlToken,{#GITLAB_HOSTSpirit}}');
    Top := GitlabPrivateTokenSpiritTitle.Top + GitlabPrivateTokenSpiritTitle.Height + ScaleY(8);
    Left := GitlabPrivateTokenSpiritTitle.Left;
    Width := GitlabPrivateTokenSpiritTitle.Width;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Font.Color := clBlue;
    Cursor := crHand;
    OnClick := @LinkClickGitLabUrlSpiritToken;
    AutoSize := True;
    WordWrap := True;
    Visible := False;
end;


// Show password checkbox
ShowPasswordCheckGitlabInfos := TNewCheckBox.Create(PageGitLabInformation);
ShowPasswordCheckGitlabInfos.Parent := PageGitLabInformation.Surface;
ShowPasswordCheckGitlabInfos.Top := PageGitLabInformation.Edits[2].Top + PageGitLabInformation.Edits[2].Height + ScaleY(40);
ShowPasswordCheckGitlabInfos.Caption := ExpandConstant('{cm:GlobalShowPasswords}');
ShowPasswordCheckGitlabInfos.Height := ScaleY(ShowPasswordCheckGitlabInfos.Height);
ShowPasswordCheckGitlabInfos.Width := GITLAB_HOSTLabel.Width;
ShowPasswordCheckGitlabInfos.OnClick := @ShowPasswordPageGitLabInformation;
ShowPasswordCheckGitlabInfos.Anchors := [akLeft, akTop];


// Restore values
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'GITLAB_HOST', PreviousGITLAB_HOST) then begin
    case Trim(Lowercase(PreviousGITLAB_HOST)) of
        '{#GITLAB_HOSTDiod}':
            begin
            GITLAB_HOSTCombo.ItemIndex := 0;
            end;
        '{#GITLAB_HOSTSpirit}':
            begin
            GITLAB_HOSTCombo.ItemIndex := 1;
            end;
    end;
end;

if VarIsNull(PreviousGITLAB_NAMESPACES) then begin
    RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_GITLAB_NAMESPACES', PreviousGITLAB_NAMESPACES)
end;
PageGitLabInformation.Values[0] := Trim(PreviousGITLAB_NAMESPACES);

if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'GITLAB_PRIVATE_TOKEN_DIOD', PreviousGITLAB_PRIVATE_TOKEN_DIOD) then begin
    PageGitLabInformation.Values[1] := Trim(PreviousGITLAB_PRIVATE_TOKEN_DIOD);
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'GITLAB_PRIVATE_TOKEN_SPIRIT', PreviousGITLAB_PRIVATE_TOKEN_SPIRIT) then begin
    PageGitLabInformation.Values[2] := Trim(PreviousGITLAB_PRIVATE_TOKEN_SPIRIT);
end;

// Set the OnChange event for the edit boxes
PageGitLabInformation.Edits[0].OnChange := @EditChangePageGitLabInformation;
PageGitLabInformation.Edits[1].OnChange := @EditChangePageGitLabInformation;
PageGitLabInformation.Edits[2].OnChange := @EditChangePageGitLabInformation;
GITLAB_HOSTCombo.OnChange := @EditChangePageGitLabInformation;

// To disable the Next button initially
PageGitLabInformation.OnActivate := @ActivatePageGitLabInformation;
