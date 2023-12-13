if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'MicrosoftWsl_IsInstalled', MicrosoftWsl_IsInstalled) then begin
    MicrosoftWsl_IsInstalled := 'no';
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'MicrosoftWsl_IsInstalled', MicrosoftWsl_IsInstalled);
end;
RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'MicrosoftWsl_IsInstalled', MicrosoftWsl_IsInstalled);
Log('MicrosoftWsl_IsInstalled: ' + MicrosoftWsl_IsInstalled);

if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'GitPortable_IsInstalled', GitPortable_IsInstalled) then begin
    GitPortable_IsInstalled := 'no';
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'GitPortable_IsInstalled', GitPortable_IsInstalled);
end;
RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'GitPortable_IsInstalled', GitPortable_IsInstalled);
Log('GitPortable_IsInstalled: ' + GitPortable_IsInstalled);

if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'VScode_IsInstalled', VScode_IsInstalled) then begin
    VScode_IsInstalled := 'no';
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'VScode_IsInstalled', VScode_IsInstalled);
end;
RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'VScode_IsInstalled', VScode_IsInstalled);
Log('VScode_IsInstalled: ' + VScode_IsInstalled);

if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'WindowsTerminal_IsInstalled', WindowsTerminal_IsInstalled) then begin
    WindowsTerminal_IsInstalled := 'no';
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'WindowsTerminal_IsInstalled', WindowsTerminal_IsInstalled);
end;
RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'WindowsTerminal_IsInstalled', WindowsTerminal_IsInstalled);
Log('WindowsTerminal_IsInstalled: ' + WindowsTerminal_IsInstalled);


if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'JetBrainsToolbox_IsInstalled', JetBrainsToolbox_IsInstalled) then begin
    JetBrainsToolbox_IsInstalled := 'no';
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'JetBrainsToolbox_IsInstalled', JetBrainsToolbox_IsInstalled);
end;
RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'JetBrainsToolbox_IsInstalled', JetBrainsToolbox_IsInstalled);
Log('JetBrainsToolbox_IsInstalled: ' + JetBrainsToolbox_IsInstalled);

//#ifdef JETBRAINS_TOOLBOX_URL
//if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'JetBrainsToolbox_Url', JetBrainsToolbox_Url) then begin
//    JetBrainsToolbox_Url := '{#JETBRAINS_TOOLBOX_URL}';
//    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'JetBrainsToolbox_Url', JetBrainsToolbox_Url);
//end;
//RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Components', 'JetBrainsToolbox_Url', JetBrainsToolbox_Url);
//Log('JetBrainsToolbox_Url: ' + JetBrainsToolbox_Url);
//#endif
