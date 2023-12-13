#### Uninstall WSL 2 kernel (admin)
msiexec.exe /uninstall '{36EF257E-21D5-44F7-8451-07923A8C465E}'

#### Disable Microsoft Windows Subsystem Linux (admin)
Disable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart

#### Disable Virtual Machine feature for WSL 2 (admin)
Disable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -NoRestart

#### Install Windows OpenSSH Client
Add-WindowsCapability -Name "OpenSSH.Client~~~~0.0.1.0" -Online
