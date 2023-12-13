if not RegQueryDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ColorTable05', ColorTable05) then begin
    ColorTable05 := PwsColorTable05DefaultValue;
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ColorTable05', PwsColorTable05DefaultValue)
end;
if not RegQueryDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontFamily', FontFamily) then begin
    FontFamily := PwsFontFamilyDefaultValue;
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontFamily', PwsFontFamilyDefaultValue)
end;
if not RegQueryDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontSize', FontSize) then begin
    FontSize := PwsFontSizeDefaultValue;
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontSize', PwsFontSizeDefaultValue)
end;
if not RegQueryDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontWeight', FontWeight) then begin
    FontWeight := PwsFontWeightDefaultValue;
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontWeight', PwsFontWeightDefaultValue)
end;
if not RegQueryDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'QuickEdit', QuickEdit) then begin
    QuickEdit := PwsQuickEditDefaultValue;
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'QuickEdit', QuickEdit)
end;
if not RegQueryDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ScreenBufferSize', ScreenBufferSize) then begin
    ScreenBufferSize := PwsScreenBufferSizeDefaultValue;
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ScreenBufferSize', PwsScreenBufferSizeDefaultValue)
end;
if not RegQueryDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ScreenColors', ScreenColors) then begin
    ScreenColors := PwsScreenColorsDefaultValue;
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ScreenColors', PwsScreenColorsDefaultValue)
end;
if not RegQueryDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'WindowSize', WindowSize) then begin
    WindowSize := PwsWindowSizeDefaultValue;
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'WindowSize', PwsWindowSizeDefaultValue)
end;
if not RegQueryDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'TerminalScrolling', TerminalScrolling) then begin
    TerminalScrolling := PwsTerminalScrollingDefaultValue;
    RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'TerminalScrolling', PwsTerminalScrollingDefaultValue)
end;
if not RegQueryStringValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FaceName', FaceName) then begin
    FaceName := PwsFaceNameDefaultValue;
    RegWriteStringValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FaceName', PwsFaceNameDefaultValue)
end;

if not RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ColorTable05', ColorTable05) then begin
    ColorTable05 := PwsColorTable05DefaultValue;
    RegWriteDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ColorTable05', ColorTable05);
end;
if not RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontFamily', FontFamily) then begin
    FontFamily := PwsFontFamilyDefaultValue;
    RegWriteDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontFamily', FontFamily);
end;
if not RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontSize', FontSize) then begin
    FontSize := PwsFontSizeDefaultValue;
    RegWriteDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontSize', FontSize);
end;
if not RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontWeight', FontWeight) then begin
    FontWeight := PwsFontWeightDefaultValue;
    RegWriteDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FontWeight', FontWeight);
end;
if not RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'QuickEdit', QuickEdit) then begin
    QuickEdit := PwsQuickEditDefaultValue;
    RegWriteDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'QuickEdit', QuickEdit);
end;
if not RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ScreenBufferSize', ScreenBufferSize) then begin
    ScreenBufferSize := PwsScreenBufferSizeDefaultValue;
    RegWriteDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ScreenBufferSize', ScreenBufferSize);
end;
if not RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ScreenColors', ScreenColors) then begin
    ScreenColors := PwsScreenColorsDefaultValue;
    RegWriteDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ScreenColors', ScreenColors);
end;
if not RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'WindowSize', WindowSize) then begin
    WindowSize := PwsWindowSizeDefaultValue;
    RegWriteDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'WindowSize', WindowSize);
end;
if not RegQueryDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'TerminalScrolling', TerminalScrolling) then begin
    TerminalScrolling := PwsTerminalScrollingDefaultValue;
    RegWriteDWordValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'TerminalScrolling', TerminalScrolling);
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FaceName', FaceName) then begin
    FaceName := PwsFaceNameDefaultValue;
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FaceName', FaceName)
end;


RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'QuickEdit', PwsQuickEditSetup);
RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'WindowSize', PwsWindowSizeSetup);
RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'ColorTable05', PwsColorTable05Setup);
RegWriteDWordValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'TerminalScrolling', PwsTerminalScrolling);
RegWriteStringValue(HKCU, 'Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_PowerShell.exe', 'FaceName', PwsFaceName);
