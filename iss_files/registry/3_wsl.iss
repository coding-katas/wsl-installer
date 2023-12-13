if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'DNS', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'DNS', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'Gateway', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'Gateway', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'WIN_USERNAME', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'WIN_USERNAME', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'WIN_USER_PASSWORD', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'WIN_USER_PASSWORD', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'DEBFULLNAME', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'DEBFULLNAME', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'DEBEMAIL', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'DEBEMAIL', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'VDI_HOSTNAME', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'VDI_HOSTNAME', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_NAME', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_NAME', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_GITLAB_NAMESPACES', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'USER_GITLAB_NAMESPACES', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'USER_PASSWORD', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'USER_PASSWORD', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'USER_PASSPHRASE', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'USER_PASSPHRASE', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'GITLAB_PRIVATE_TOKEN_DIOD', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'GITLAB_PRIVATE_TOKEN_DIOD', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'GITLAB_PRIVATE_TOKEN_SPIRIT', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Temp', 'GITLAB_PRIVATE_TOKEN_SPIRIT', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'WSLVPNKIT_FILENAME', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'WSLVPNKIT_FILENAME', '{#WslRootDir}\wsl-vpnkit\{#WSLVPNKIT_FILENAME}');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'WslRootDir', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'WslRootDir', '{#WslRootDir}');
end;
