// ---- Services
ComponentsServicesTitle := TLabel.Create(PageComponents);
with ComponentsServicesTitle do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:ComponentsServicesTitle}');
    Top := ComponentsServicesTitle.Top + ScaleY(15);
    Left := 0;
    Font.Style := [fsBold];
    Font.Size := 10;
    Font.Color := clBlue
    AutoSize := False;
    WordWrap := False;
end;

// Cloud Foundry
CFYLabel := TLabel.Create(PageComponents);
with CFYLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'Cloud Foundry';
    Top := ComponentsServicesTitle.Top + ComponentsServicesTitle.Height + ScaleY(16);
    Left := ComponentsServicesTitle.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

CFYCombo := TNewComboBox.Create(PageComponents);
with CFYCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ScaleY(100);
    Top := CFYLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 0;
    Enabled := False;
    Visible := True;
end;

// Docker
DOCKERLabel := TLabel.Create(PageComponents);
with DOCKERLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'Docker';
    Top := CFYCombo.Top + CFYCombo.Height + ScaleY(16);
    Left := ComponentsServicesTitle.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

DOCKERCombo := TNewComboBox.Create(PageComponents);
with DOCKERCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ScaleY(100);
    Top := DOCKERLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 0;
    Enabled := False;
    Visible := True;
end;

// Kubernetes
KUBERNETESLabel := TLabel.Create(PageComponents);
with KUBERNETESLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'Kubernetes';
    Top := DOCKERCombo.Top + DOCKERCombo.Height + ScaleY(16);
    Left := ComponentsServicesTitle.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

KUBERNETESCombo := TNewComboBox.Create(PageComponents);
with KUBERNETESCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ScaleY(100);
    Top := KUBERNETESLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 0;
    Enabled := True;
    Visible := True;
end;

// ---- PFC Platforms
ComponentsPfcPlatformsTitle := TLabel.Create(PageComponents);
with ComponentsPfcPlatformsTitle do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:ComponentsPfcPlatformsTitle}');
    Top := ComponentsPfcPlatformsTitle.Top + ScaleY(15);
    Left := ScaleY(200);
    Font.Style := [fsBold];
    Font.Size := 10;
    Font.Color := clBlue
    AutoSize := False;
    WordWrap := False;
end;

// WamPaaS
PFC_WAMPAASLabel := TLabel.Create(PageComponents);
with PFC_WAMPAASLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'WamPaaS';
    Top := ComponentsPfcPlatformsTitle.Top + ComponentsPfcPlatformsTitle.Height + ScaleY(16);
    Left := ComponentsPfcPlatformsTitle.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Visible := True;
end;

PFC_WAMPAASCombo := TNewComboBox.Create(PageComponents);
with PFC_WAMPAASCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ComponentsPfcPlatformsTitle.Left + ScaleY(100);
    Top := PFC_WAMPAASLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 0;
    Enabled := True;
    Visible := True;
end;

// Mercury
PFC_MERCURYLabel := TLabel.Create(PageComponents);
with PFC_MERCURYLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'Mercury';
    Top := ComponentsPfcPlatformsTitle.Top + ComponentsPfcPlatformsTitle.Height + ScaleY(16);
    Left := PFC_WAMPAASCombo.Left + PFC_WAMPAASCombo.Width + ScaleX(20);
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Visible := True;
end;

PFC_MERCURYCombo := TNewComboBox.Create(PageComponents);
with PFC_MERCURYCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := PFC_MERCURYLabel.Left + ScaleY(80);
    Top := PFC_MERCURYLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 1;
    Enabled := True;
    Visible := True;
end;

// PiCaaSso
PFC_PICAASSOLabel := TLabel.Create(PageComponents);
with PFC_PICAASSOLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'PiCaaSso';
    Top := PFC_WAMPAASCombo.Top + PFC_WAMPAASCombo.Height + ScaleY(16);
    Left := ComponentsPfcPlatformsTitle.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

PFC_PICAASSOCombo := TNewComboBox.Create(PageComponents);
with PFC_PICAASSOCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ComponentsPfcPlatformsTitle.Left + ScaleY(100);
    Top := PFC_PICAASSOLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 0;
    Enabled := True;
    Visible := True;
end;

// SWARM_TENANT
SWARM_TENANTLabel := TLabel.Create(PageComponents);
with SWARM_TENANTLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    AutoSize := False;
    WordWrap := False;
    Caption := ExpandConstant('{cm:UserTenantSwarm}');
    Left := PFC_MERCURYLabel.Left;
    Top := PFC_PICAASSOLabel.Top;
    Width := PFC_MERCURYLabel.Width;
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
end;

SWARM_TENANTEdit := TNewEdit.Create(PageComponents);
with SWARM_TENANTEdit do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := PFC_MERCURYCombo.Left;
    Top := SWARM_TENANTLabel.Top - ScaleY(4);
    Width := PFC_MERCURYCombo.Width * 2;
    Height := ScaleY(15);
    Color := $F0F0F0;
    Font.Style := [];
    Font.Color := $000000;
    Font.Size := GlobalFontSize;
end;

// RicKaaStley
PFC_RICKAASTLEYLabel := TLabel.Create(PageComponents);
with PFC_RICKAASTLEYLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'RicKaaStley';
    Top := PFC_PICAASSOCombo.Top + PFC_PICAASSOCombo.Height + ScaleY(16);
    Left := ComponentsPfcPlatformsTitle.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

PFC_RICKAASTLEYCombo := TNewComboBox.Create(PageComponents);
with PFC_RICKAASTLEYCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ComponentsPfcPlatformsTitle.Left + ScaleY(100);
    Top := PFC_RICKAASTLEYLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 0;
    Enabled := True;
    Visible := True;
end;

// MetalliKaaS
PFC_METALLIKAASLabel := TLabel.Create(PageComponents);
with PFC_METALLIKAASLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'MetalliKaaS';
    Top := PFC_RICKAASTLEYLabel.Top;
    Left := SWARM_TENANTLabel.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

PFC_METALLIKAASCombo := TNewComboBox.Create(PageComponents);
with PFC_METALLIKAASCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := SWARM_TENANTEdit.Left;
    Top := PFC_RICKAASTLEYCombo.Top;
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 1;
    Enabled := False;
    Visible := True;
end;

// ---- Environment configuration
EnvConfigLabel := TLabel.Create(PageComponents);
with EnvConfigLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:ComponentsEnvConfigTitle}');
    Top := PFC_RICKAASTLEYCombo.Top + PFC_RICKAASTLEYCombo.Height + ScaleY(15);
    Left := 0;
    Font.Style := [fsBold];
    Font.Size := 10;
    Font.Color := clBlue
    AutoSize := False;
    WordWrap := False;
end;

// WSL<>Windows proxy
WslProxyLabel := TLabel.Create(PageComponents);
with WslProxyLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'Windows proxy';
    Top := EnvConfigLabel.Top + EnvConfigLabel.Height + ScaleY(20);
    Left := EnvConfigLabel.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

WSL_WINDOWS_PROXYCombo := TNewComboBox.Create(PageComponents);
with WSL_WINDOWS_PROXYCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ScaleY(100);
    Top := WslProxyLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 0;
    Enabled := False;
    Visible := True;
end;

WslProxyMessage := TLabel.Create(PageComponents);
with WslProxyMessage do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := ExpandConstant('{cm:WslProxyMessage}');
    Top := WSL_WINDOWS_PROXYCombo.Top;
    Left := ScaleY(200);
    Width := ScaleY(250);
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := True;
    WordWrap := True;
    Visible := True;
end;

// Shell
ShellDefaultLabel := TLabel.Create(PageComponents);
with ShellDefaultLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'Shell';
    Top := WslProxyLabel.Top + WslProxyLabel.Height + ScaleY(20);
    Left := WslProxyLabel.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

SHELL_DEFAULTCombo := TNewComboBox.Create(PageComponents);
with SHELL_DEFAULTCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ScaleY(100);
    Top := ShellDefaultLabel.Top - ScaleY(4);
    Width := ScaleY(70);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add('{#ShellBash}');
    Items.Add('{#ShellZsh}');
    ItemIndex := 0;
    Enabled := True;
    Visible := True;
end;

// GoLang
GolangLabel := TLabel.Create(PageComponents);
with GolangLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'GoLang';
    Top := ShellDefaultLabel.Top + ShellDefaultLabel.Height + ScaleY(20);
    Left := ShellDefaultLabel.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

GOLANGCombo := TNewComboBox.Create(PageComponents);
with GOLANGCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ScaleY(100);
    Top := GolangLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 1;
    Enabled := True;
    Visible := True;
end;

// NodeJS
NODEJSLabel := TLabel.Create(PageComponents);
with NODEJSLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'NodeJS';
    Top := GolangLabel.Top + GolangLabel.Height + ScaleY(20);
    Left := GolangLabel.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

NODEJSCombo := TNewComboBox.Create(PageComponents);
with NODEJSCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ScaleY(100);
    Top := NODEJSLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 1;
    Enabled := True;
    Visible := True;
end;

// PHP
PHPLabel := TLabel.Create(PageComponents);
with PHPLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'PHP';
    Top := NODEJSLabel.Top;
    Left := WslProxyMessage.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

PHPCombo := TNewComboBox.Create(PageComponents);
with PHPCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := PHPLabel.Left + ScaleY(100);
    Top := PHPLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 1;
    Enabled := True;
    Visible := True;
end;

// Python
PythonLabel := TLabel.Create(PageComponents);
with PythonLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'Python';
    Top := NODEJSLabel.Top + NODEJSLabel.Height + ScaleY(20);
    Left := NODEJSLabel.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

PYTHONCombo := TNewComboBox.Create(PageComponents);
with PYTHONCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := ScaleY(100);
    Top := PythonLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 0;
    Enabled := True;
    Visible := True;
end;

// Python - PyEnv
PythonPyenvLabel := TLabel.Create(PageComponents);
with PythonPyenvLabel do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Caption := 'PyEnv';
    Top := PythonLabel.Top;
    Left := WslProxyMessage.Left;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    AutoSize := False;
    WordWrap := False;
    Width := ScaleY(100);
    Visible := True;
end;

PYTHON_PYENVCombo := TNewComboBox.Create(PageComponents);
with PYTHON_PYENVCombo do
begin
    Parent := PageComponents.Surface;
    Anchors := [akLeft, akTop];
    Left := PythonPyenvLabel.Left + ScaleY(100);
    Top := PythonPyenvLabel.Top - ScaleY(4);
    Width := ScaleY(50);
    Style := csDropDownList;
    Font.Style := [];
    Font.Size := GlobalFontSize;
    Items.Add(ExpandConstant('{cm:YesMessage}'));
    Items.Add(ExpandConstant('{cm:NoMessage}'));
    ItemIndex := 0;
    Enabled := True;
    Visible := True;
end;

// Restore values
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'DOCKER', PreviousDOCKER) then begin
    case Trim(Lowercase(PreviousDOCKER)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            DOCKERCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            DOCKERCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'CLOUD_FOUNDRY', PreviousCFY) then begin
    case Trim(Lowercase(PreviousCFY)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            CFYCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            CFYCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'KUBERNETES', PreviousKUBERNETES) then begin
    case Trim(Lowercase(PreviousKUBERNETES)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            KUBERNETESCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            KUBERNETESCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PFC_WAMPAAS', PreviousPFC_WAMPAAS) then begin
    case Trim(Lowercase(PreviousPFC_WAMPAAS)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            PFC_WAMPAASCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PFC_WAMPAASCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PFC_MERCURY', PreviousPFC_MERCURY) then begin
    case Trim(Lowercase(PreviousPFC_MERCURY)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            PFC_MERCURYCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PFC_MERCURYCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PFC_PICAASSO', PreviousPFC_PICAASSO) then begin
    case Trim(Lowercase(PreviousPFC_PICAASSO)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            PFC_PICAASSOCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PFC_PICAASSOCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'SWARM_TENANT', PreviousSWARM_TENANT) then begin
    SWARM_TENANTEdit.Text := PreviousSWARM_TENANT;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PFC_RICKAASTLEY', PreviousPFC_RICKAASTLEY) then begin
    case Trim(Lowercase(PreviousPFC_RICKAASTLEY)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            PFC_RICKAASTLEYCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PFC_RICKAASTLEYCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PFC_METALLIKAAS', PreviousPFC_METALLIKAAS) then begin
    case Trim(Lowercase(PreviousPFC_METALLIKAAS)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            PFC_METALLIKAASCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PFC_METALLIKAASCombo.ItemIndex := 1;
            end;
    end;
end;

if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'SHELL_DEFAULT', PreviousSHELL_DEFAULT) then begin
    case Trim(Lowercase(PreviousSHELL_DEFAULT)) of
        '{#ShellBash}':
            begin
            SHELL_DEFAULTCombo.ItemIndex := 0;
            end;
        '{#ShellZsh}':
            begin
            SHELL_DEFAULTCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'GOLANG', PreviousGOLANG) then begin
    case Trim(Lowercase(PreviousGOLANG)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            GOLANGCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            GOLANGCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'NODEJS', PreviousNODEJS) then begin
    case Trim(Lowercase(PreviousNODEJS)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            NODEJSCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            NODEJSCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PHP', PreviousPHP) then begin
    case Trim(Lowercase(PreviousPHP)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            PHPCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PHPCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PYTHON', PreviousPYTHON) then begin
    case Trim(Lowercase(PreviousPYTHON)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            PYTHONCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PYTHONCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'PYTHON_PYENV', PreviousPYTHON_PYENV) then begin
    case Trim(Lowercase(PreviousPYTHON_PYENV)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            PYTHON_PYENVCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            PYTHON_PYENVCombo.ItemIndex := 1;
            end;
    end;
end;
if RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'WSL_WINDOWS_PROXY', PreviousWSL_WINDOWS_PROXY) then begin
    case Trim(Lowercase(PreviousWSL_WINDOWS_PROXY)) of
        'yes', 'y', 'oui', 'o', 'true', 't', '1':
            begin
            WSL_WINDOWS_PROXYCombo.ItemIndex := 0;
            end;
       'no', 'n', 'non', 'false', 'f', '0', '':
            begin
            WSL_WINDOWS_PROXYCombo.ItemIndex := 1;
            end;
    end;
end;

// Set the OnChange event for the edit boxes
DOCKERCombo.OnChange := @EditChangePageComponents;
CFYCombo.OnChange := @EditChangePageComponents;
KUBERNETESCombo.OnChange := @EditChangePageComponents;
PFC_WAMPAASCombo.OnChange := @EditChangePageComponents;
PFC_MERCURYCombo.OnChange := @EditChangePageComponents;
PFC_PICAASSOCombo.OnChange := @EditChangePageComponents;
PFC_RICKAASTLEYCombo.OnChange := @EditChangePageComponents;
PFC_METALLIKAASCombo.OnChange := @EditChangePageComponents;
SWARM_TENANTEdit.OnChange := @EditChangePageComponents;

// To disable the Next button initially
PageComponents.OnActivate := @ActivatePageComponents;
