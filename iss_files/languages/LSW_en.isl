[CustomMessages]
NoneMessage=None
YesMessage=yes
NoMessage=no

CannotReach=Cannot reach %1.
CheckInternetConnection=Please check your Internet connection and/or that you are connected to the Orange network via Cisco AnyConnect VPN.
CheckGitlabAccessToken=The GitLab token could not be verified.
BadWslVersion=The WSL version installed is not sufficiently recent.%nPlease, install WSL by selecting '%1' in the installation process.

PageUserInformationTitle=User identification
PageUserInformationDescription=Please fill in/check your personal data.
PageUserInformationMessage=This information will be used in different configurations.%n%nIt is therefore important to fill in these fields correctly.%n%nFor example, your name and e-mail address will appear as they are in all your commits.
PageGitLabInformationTitle=GitLab informations
PageGitLabInformationDescription=Please fill in/verify GitLab informations.
PageGitLabInfosNamespacesTitle=GitLab projects
PageGitLabInfosNamespaces=All projects in the root groups listed here will be automatically cloned.%nAlso, all cloned projects will be scanned to automatically create a Python virtual environment if needed.%You must have read/write rights to clone the projects listed here.
PageGitLabInfosMessage=Select the main GitLab server where the projects you use daily are versioned.

PageUserProfileDescription=User profile identification

PageUserProfileVersionLabel=Ubuntu version:
PageWslRootfsOrigin=RootFS archive origin:

PageComponentsTitle=Components
PageComponentsDescription=Please select the components to be activated or installed.

PageCredentialsTitle=Authentication
PageCredentialsDescription=Please fill in the authentication information below.

GlobalShowPasswords=Show all passwords

PageUserProfileVdiTitle=* Create/register your VDI and get its hostname on the VDI 2.0 portal:
PageCredentialsSshPassphraseTitle=The SSH passphrase must meet the following criteria:
PageCredentialsSshPassphraseMessageCommon1=   - from 8 to 128 characters
PageCredentialsSshPassphraseMessageCommon2=   - contain at least 1 capital letter
PageCredentialsSshPassphraseMessageCommon3=   - contain at least 1 digit
PageCredentialsSshPassphraseMessageCommon4=   - contain at least 1 special characters: !#$%&()*/:<>?@^_{|}~
PageCredentialsSshPassphraseMessageCommon5=   - NOT contain accented characters: àáâãäåçèéêëìíîïðòóôõöùúûüýÿ
PageCredentialsSshPassphraseMessageCommon6=   - NOT identical to the AD password (CUID)
PageCredentialsSshPassphraseMessageLdap1=   - NOT identical to the LDAP password

PageGitLabInformationGitlabPrivateTokenTitle=You must create a GitLab personal token by selecting the 'API' scope via the following URL (remember to remove the expiration):
PageGitLabInformationGitLabUrlToken=https://%1/-/profile/personal_access_tokens

LswCautionLine1=You have the possibility to install LSW on your e-Buro station thanks to WSL, but also on your VDI.
LswCautionLine2=This choice is not an obligation, although highly recommended.
LswCautionLine3=If you want to install LSW on your VDI, before continuing, it is better to reinstall it and%nrestart it right after.
VdiWontInstall=By answering No, LSW will not be installed on your VDI.%nBut aliases will be added to your profile to allow you to connect on it.

USER_PROFILECautionLine1=Depending on your entity and therefore your business profile, certain compoents will be activated/installed or not.
USER_PROFILECautionLine2=LSW is, for the moment, more DevOps oriented.%n%n   OPS --> DevOps%n   DEV --> Developer

USER_PROFILEBastionsLine1=The choice of bastion is important for WSL to function correctly in an e-Buro environment.
USER_PROFILEBastionsLine2=   - ADM bastions: IPSDGP/SC%n   - RSC bastions (opbar): Other internal entities
USER_PROFILEBastionsDoc=Bastions PFC/Spirit servers overview

WhereInstallLsw=Would you like to install LSW on your VDI ?
InstallLswOnWslAndVdi=Install LSW on my new WSL distro and my VDI (recommended)
InstallLswOnWslOnly=Install LSW on my new WSL distro only

WichUSER_PROFILE=What is your profile ?
DoYouHaveBastion=Are you using a Bastion ?
WichBASTION_HOST=Which one ?
WichGITLAB_HOST=Which GitLab do you use daily ?
DoYouHaveLdap=Do you have a LDAP account ?
WichLDAP_HOST=Which server ?
DoYouHaveVdi=Do you have a VDI ?
UserProfileOps=OPS
UserProfileDev=DEV

DEBFULLNAME=Full name:
DEBEMAIL=Email:
BadDEBEMAIL=Invalid email address.

VdiHostname=VDI FQDN:
VdiIpAddress=IP address:
WIN_USERNAME=CUID:
USER_NAME=LDAP username:
UserTenantSwarm=Tenant:
UserGitlabNameSpaces=GitLab namespaces (comma separated):
GitlabNamespaceNotFound=The namespace '%1' does not exist.%n%nPlease check the spelling and/or the case.%n%nIf you are sure that the namespace exists, please contact the GitLab administrator.

AuthentCuidTitle=AD authentication
AuthentCuidMessage=AD credentials will be used by CNTLM (NTLM authentication) within the WSL distribution.
AuthentLdapTitle=LDAP authentication
AuthentLdapMessage=The LDAP credentials will be used by CNTLM (Basic Squid authentication) within the WSL distribution.%nBut also to activate your user within WSL.
AuthentWslMessage=The AD credentials will be used by CNTLM (NTLM authentication) within the WSL distribution.%nBut also to activate your user within WSL (username in lower case).

PassPhraseSshTitle=Passphrase SSH
USER_PASSWORD=LDAP password:
WIN_USER_PASSWORD=AD password:
USER_PASSPHRASE=SSH passphrase:
GITLAB_PRIVATE_TOKEN_DIOD=GitLab Diod Private token:
GITLAB_PRIVATE_TOKEN_SPIRIT=GitLab Spirit Private token:

GlobalIsAdmin=This installer should not be run as an administrator.%nPlease run the installation normally.
GlobalRebootComputer=Please restart your computer.%n%nThen you can start the installation of LSW.
GlobalCanNotExecuteExit=Can not execute the script "%1", exiting...

DeployToolsTitle=Installing additional tools
DeployToolsMsgBox=If you know what you are doing, you can skip the installation of additional tools.%n%nThe following tools will be installed:%n%n- Git Portable%n%n- Microsoft VScode%n%n- Microsoft Terminal
DeployToolsContinue=I want to continue and install the additional tools.
DeployToolsIgnore=I wish to ignore this step.

DeployWslTitle=WSL activation
DeployWslMsgBox=If you know what you are doing, you can skip the WSL activation step.
DeployWslContinue=I want to continue and activate WSL.
DeployWslIgnore=WSL is already activated, I want to skip this step.

WindowsAdminRequestTitle=AdMinute - Administrator access
WindowsAdminMsgBox=Some Windows features require administrator rights to be activated.%n%nYou must request this via 'AdMinute', then restart your computer.
WindowsAdminRequestContinue=I want to request administrator rights with AdMinute.
WindowsAdminRequestIgnore=I already have administrator rights, and I have already restarted my computer to activate them.

WindowsAdminRequest0=A page to AdMinute window has been opened to allow you to become an administrator temporarily.%n%nFollow the instructions below:
WindowsAdminRequest1=1/ Check 'To install an application or a software not available in self-service on the Software Center'.%n%n2/ Type 'LSW' in the 'Application name' field%n%n3/ Click on 'Next step'%n%n4/ Click on 'Open administrator rights'
WindowsAdminRequest2=If you already have administrator rights, you can simply skip this step and continue the installation process.

WindowsAdminRequestMsgBox=Have you finished the application on 'AdMinute' to become an Administrator, and are you ready to restart your computer?
WindowsAdminRequested=Yes, I'm done with 'AdMinute' and I'm ready to reboot my computer to activate the rights.
WindowsAdminRefused=I didn't want to ask for the rights to become Administrator...

GoldapBadPassword=Wrong LDAP username or password.%nOr, your LDAP account is not activated.
GoldapBadValidate=Unable to validate the user's LDAP password.

WindowsBadPassword=Wrong AD password.
WindowsBadValidate=Unable to validate the user's AD password.

AuthenticationCuidLabel=Active Directory authentication (CUID)

ComponentsServicesTitle=Services
ComponentsPfcPlatformsTitle=PlatForms Cloud
ComponentsEnvConfigTitle=Environment configuration

WslProxyMessage=Dynamic proxy configuration under Windows depending on the network.

WslNotInstalled=WSL could not be installed or updated.%nIt is not possible to continue the installation of LSW.%nPlease try a manual approach to update WSL.
