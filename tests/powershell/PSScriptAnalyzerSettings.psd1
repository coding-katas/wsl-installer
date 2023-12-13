# PSScriptAnalyzerSettings.psd1
# Settings for PSScriptAnalyzer invocation.
@{
    Rules        = @{
        PSUseCompatibleCommands = @{
            # Turns the rule on
            Enable         = $true

            # Lists the PowerShell platforms we want to check compatibility with
            TargetProfiles = @(
                # Powershell 5.1, Windows Server 2019
                # 'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework.json',
                # Powershell 6.2, Windows Server 2019
                # 'win-8_x64_10.0.17763.0_6.2.4_x64_4.0.30319.42000_core.json',
                # Powershell 7.0, Windows Server 2019
                # 'win-8_x64_10.0.17763.0_7.0.0_x64_3.1.2_core.json',
                # Powershell 5.1, Windows 10 1809 (RS5)
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework.json',
                # Powershell 6.2, Windows 10 1809 (RS5)
                # 'win-4_x64_10.0.17763.0_6.2.4_x64_4.0.30319.42000_core.json',
                # Powershell 7.0, Windows 10 1809 (RS5)
                # 'win-4_x64_10.0.17763.0_6.2.4_x64_3.1.2_core.json',
                # Powershell 7.0, Ubuntu 18.04 LTS
                # 'ubuntu_x64_18.04_6.2.4_x64_3.1.2_core.json'
                # 'ubuntu_x64_18.04_6.2.4_x64_4.0.30319.42000_core.json',
                # 'ubuntu_x64_18.04_7.0.0_x64_3.1.2_core.json',
                # Powershell 5.1, Windows 10 1809 (RS5)
                'win-4_x64_10.0.18362.0_6.2.4_x64_4.0.30319.42000_core.json',
                # Powershell 7.0, Windows 10 1809 (RS5)
                'win-4_x64_10.0.18362.0_7.0.0_x64_3.1.2_core.json'
            )

            # You can specify commands to not check like this, which also will ignore its parameters:
            IgnoreCommands = @(
                # 'Install-Module'
                'Set-ClipBoard', # Because we explicitly check for OS before using in ADSNotebooks module
                'It', # Because Pester!
                'Should', # Because Pester!
                'Context', # Because Pester!
                'BeforeAll', # Because Pester!
                'Describe' # Because Pester!
            )
        }
        PSUseCompatibleSyntax   = @{
            # This turns the rule on (setting it to false will turn it off)
            Enable         = $true

            # Simply list the targeted versions of PowerShell here
            # https://docs.microsoft.com/en-us/powershell/scripting/powershell-support-lifecycle?view=powershell-7.1#release-history
            TargetVersions = @(
                '5.1',
                '6.0',
                '6.1',
                '6.2',
                '7.0',
                '7.1'
            )
        }
    }
    # Do not analyze the following rules. Use ExcludeRules when you have
    # commented out the IncludeRules settings above and want to include all
    # the default rules except for those you exclude below.
    # Note: if a rule is in both IncludeRules and ExcludeRules, the rule
    # will be excluded.
    ExcludeRules = @(
        'PSAvoidTrailingWhitespace',
        'PSAvoidUsingWriteHost',
        'PSAvoidUsingConvertToSecureStringWithPlainText'
    )
}
