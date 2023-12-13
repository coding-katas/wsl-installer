RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'DEBUG', '{#DebugMode}');
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'LSW_VERSION', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'LSW_VERSION', '{#LSW_VERSION}');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'INSTALL_LSW_ON_VDI', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL', 'INSTALL_LSW_ON_VDI', '');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'WSL_VERSION', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'WSL_VERSION', '{#WSL_VERSION}');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'ROOTFS_ORIGIN', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'ROOTFS_ORIGIN', '{#ROOTFS_ORIGIN}');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'DISTRO_VERSION', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'DISTRO_VERSION', '{#DISTRO_VERSION}');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'ENTITY_NAME', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'ENTITY_NAME', '{#ENTITY_NAME}');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'BRANCH_ENTITY_REPO', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'BRANCH_ENTITY_REPO', '{#BRANCH_ENTITY_REPO}');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'ENTITY_REPO_PATH', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'ENTITY_REPO_PATH', '{#ENTITY_REPO_PATH}');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'ENTITY_REPO_GITLAB_HOST', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'ENTITY_REPO_GITLAB_HOST', '{#ENTITY_REPO_GITLAB_HOST}');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'WIN_DISTRO_DIR', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'WIN_DISTRO_DIR', '{#WslRootDir}\distros\{#WSL_DISTRO_NAME}');
end;
if not RegQueryStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'BRANCH_LSW_REPO', RegistryValue) then begin
    RegWriteStringValue(HKCU, 'SOFTWARE\{#AppPublisher}\WSL\Distros\{#WSL_DISTRO_NAME}', 'BRANCH_LSW_REPO', '{#BRANCH_LSW_REPO}');
end;
