if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Windows Functionalities', 'Microsoft Windows Subsystem Linux', MicrosoftWsl) then begin
    MicrosoftWsl := 'Disabled';
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Windows Functionalities', 'Microsoft Windows Subsystem Linux', MicrosoftWsl);
end;
RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Windows Functionalities', 'Microsoft Windows Subsystem Linux', MicrosoftWsl);

if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Windows Functionalities', 'Microsoft Virtual Machine Platform', MicrosoftVmp) then begin
    MicrosoftVmp := 'Disabled';
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Windows Functionalities', 'Microsoft Virtual Machine Platform', MicrosoftVmp);
end;
RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Windows Functionalities', 'Microsoft Virtual Machine Platform', MicrosoftVmp);

Log('Microsoft Windows Subsystem Linux: ' + MicrosoftWsl);
Log('Microsoft Virtual Machine Platform: ' + MicrosoftVmp);
