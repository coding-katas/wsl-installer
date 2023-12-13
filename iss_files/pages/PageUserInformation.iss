// DEBFULLNAME
PageUserInformation.Add(ExpandConstant('{cm:DEBFULLNAME}'), False);
PageUserInformation.PromptLabels[0].Left := 0;
PageUserInformation.PromptLabels[0].AutoSize := False;
PageUserInformation.PromptLabels[0].Width := ScaleX(MainPageWidth div 2);
PageUserInformation.PromptLabels[0].Font.Size := GlobalFontSize;
PageUserInformation.PromptLabels[0].Visible := True;
PageUserInformation.PromptLabels[0].Anchors := [akLeft, akTop];
PageUserInformation.Edits[0].Top := PageUserInformation.PromptLabels[0].Top + PageUserInformation.PromptLabels[0].Height + ScaleY(8);
PageUserInformation.Edits[0].Left := PageUserInformation.PromptLabels[0].Left;
PageUserInformation.Edits[0].AutoSize := False;
PageUserInformation.Edits[0].Width := PageUserInformation.PromptLabels[0].Width;
PageUserInformation.Edits[0].Visible := True;
PageUserInformation.Edits[0].Anchors := [akLeft, akTop];

// DEBEMAIL
PageUserInformation.Add(ExpandConstant('{cm:DEBEMAIL}'), False);
PageUserInformation.PromptLabels[1].Left := 0;
PageUserInformation.PromptLabels[1].AutoSize := False;
PageUserInformation.PromptLabels[1].Width := ScaleX(MainPageWidth div 2);
PageUserInformation.PromptLabels[1].Font.Size := GlobalFontSize;
PageUserInformation.PromptLabels[1].Visible := True;
PageUserInformation.PromptLabels[1].Anchors := [akLeft, akTop];
PageUserInformation.Edits[1].Top := PageUserInformation.PromptLabels[1].Top + PageUserInformation.PromptLabels[1].Height + ScaleY(8);
PageUserInformation.Edits[1].Left := PageUserInformation.PromptLabels[1].Left;
PageUserInformation.Edits[1].AutoSize := False;
PageUserInformation.Edits[1].Width := PageUserInformation.PromptLabels[1].Width;
PageUserInformation.Edits[1].Visible := True;
PageUserInformation.Edits[1].Anchors := [akLeft, akTop];

PageUserInformationMessage := TLabel.Create(PageUserInformation);
with PageUserInformationMessage do
begin
    Parent := PageUserInformation.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:PageUserInformationMessage}');
    Top := PageUserInformation.PromptLabels[0].Top + ScaleY(8);
    Left := PageUserInformation.Edits[0].Left + PageUserInformation.Edits[0].Width + ScaleX(15);
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Width := ScaleX(MainPageWidth div 2);
    AutoSize := True;
    WordWrap := True;
    Visible := True;
end;


// Restore values
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'DEBFULLNAME', PreviousDEBFULLNAME) then begin
    PageUserInformation.Values[0] := PreviousDEBFULLNAME;
end;
if (VarIsNull(PreviousDEBFULLNAME)) or (Length(PreviousDEBFULLNAME) = 0) then begin
    if RegQueryStringValue(HKLM, 'SOFTWARE\e-Buro', 'LastUserName', PreviousDEBFULLNAME) then begin
        PageUserInformation.Values[0] := PreviousDEBFULLNAME;
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

// Set the OnChange event for the edit boxes
PageUserInformation.Edits[0].OnChange := @EditChangePageUserInformation;
PageUserInformation.Edits[1].OnChange := @EditChangePageUserInformation;

// To disable the Next button initially
PageUserInformation.OnActivate := @ActivatePageUserInformation;
