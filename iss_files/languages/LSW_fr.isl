[CustomMessages]
NoneMessage=Aucun
YesMessage=oui
NoMessage=non

CannotReach=Impossible d'atteindre %1.
CheckInternetConnection=Veuillez vérifier votre connexion Internet et/ou que vous êtes bien connecté au réseau Orange via Cisco AnyConnect VPN.
CheckGitlabAccessToken=Le jeton GitLab n'a pas pu être vérifié.
BadWslVersion=La version de WSL installée n'est pas suffisamment récente.%nMerci, d'installer WSL en sélectionnant '%1' dans le processus d'installation.

PageUserInformationTitle=Identification de l'utilisateur
PageUserInformationDescription=Veuillez remplir/vérifier les informations vous concernant.
PageUserInformationMessage=Ces informations seront exploitées dans différentes configurations.%n%nIl est donc important de correctement renseigner ces champs.%n%nPar exemple, votre nom et votre e-mail apparaîtront tels quels dans tous vos commits.
PageGitLabInformationTitle=Informations GitLab
PageGitLabInformationDescription=Veuillez renseigner les informations concernant GitLab.
PageGitLabInfosNamespacesTitle=Projets GitLab
PageGitLabInfosNamespaces=Tous les projets présents dans les groupes racines listés ici seront automatiquement clônés.%nAussi, tous les projets clônés seront parcourus pour créer automatiquement un environnement virtuel Python si nécessaire.%nVous devez disposez des droits de lecture/écriture pour clôner les projets listés ici.
PageGitLabInfosMessage=Sélectionnez le serveur GitLab principal où sont versionnés les projets que vous utilisez au quotidien.

PageUserProfileDescription=Identification du profil de l'utilisateur

PageUserProfileVersionLabel=Version Ubuntu:
PageWslRootfsOrigin=Origine de l'archive RootFS:

PageComponentsTitle=Composants
PageComponentsDescription=Veuillez sélectionner les composants à activer ou à installer.

PageCredentialsTitle=Authentification
PageCredentialsDescription=Veuillez renseigner les informations d'authentification ci-dessous.

GlobalShowPasswords=Afficher tous les mots de passe

PageUserProfileVdiTitle=* Créez/recréez une VDI, et obtenez son FQDN et son IP sur le portail VDI 2.0:
PageCredentialsSshPassphraseTitle=La phrase secrète SSH doit répondre aux critères suivants:
PageCredentialsSshPassphraseMessageCommon1=   - de 8 à 128 charactères
PageCredentialsSshPassphraseMessageCommon2=   - contenir au moins une lettre majuscule
PageCredentialsSshPassphraseMessageCommon3=   - contenir au moins 1 chiffre
PageCredentialsSshPassphraseMessageCommon4=   - contenir au moins un caractère spécial: !#$%&()*/:<>?@^_{|}~
PageCredentialsSshPassphraseMessageCommon5=   - NE PAS contenir de caractères accentués: àáâãäåçèéêëìíîïðòóôõöùúûüýÿ
PageCredentialsSshPassphraseMessageCommon6=   - NE PAS être identique au mot de passe AD (CUID)
PageCredentialsSshPassphraseMessageLdap1=   - NE PAS être identique au mot de passe LDAP

PageGitLabInformationGitlabPrivateTokenTitle=Vous devez créer un jeton personnel GitLab en sélectionnant la portée 'API' via l'URL suivante (penser à supprimer l'expiration):
PageGitLabInformationGitLabUrlToken=https://%1/-/profile/personal_access_tokens

LswCautionLine1=Vous avez la possibilité d'installer LSW sur votre station e-Buro grâce à WSL, mais aussi sur votre VDI si vous en avez une.
LswCautionLine2=Ce choix n'est pas une obligation, bien que fortement recommandé.
LswCautionLine3=Si vous voulez installer LSW sur votre VDI, avant de continuer, il est préférable de la réinstaller%net de la redémarrer juste après.
VdiWontInstall=En répondant Non, LSW ne sera pas installé sur votre VDI.%nMais des alias seront ajoutés à votre profil pour vous permettre de vous connecter dessus.

USER_PROFILECautionLine1=En fonction de votre entité et donc de votre profil métier, certains composants seront activés/installés ou non.
USER_PROFILECautionLine2=LSW est, pour l'instant, davantage orienté DevOps.%n%n   OPS --> DevOps%n   DEV --> Développeur

USER_PROFILEBastionsLine1=Le choix du bastion est important pour le bon fonctionnement de WSL au sein d'un environnement e-Buro.
USER_PROFILEBastionsLine2=   - bastions ADM: IPSDGP/SC%n   - bastions RSC (opbar): Autres entités internes
USER_PROFILEBastionsDoc=Présentation des serveurs Bastions PFC/Spirit

WhereInstallLsw=Souhaitez-vous installer LSW sur votre VDI ?
InstallLswOnWslAndVdi=Installer LSW sur ma nouvelle distro WSL et ma VDI (recommandé)
InstallLswOnWslOnly=Installer LSW sur ma nouvelle distro WSL uniquement

WichUSER_PROFILE=Quel est votre profil ?
DoYouHaveBastion=Utilisez-vous un Bastion ?
WichBASTION_HOST=Lequel ?
WichGITLAB_HOST=Quel GitLab utilisez-vous au quotidien ?
DoYouHaveLdap=Avez-vous un compte LDAP ?
WichLDAP_HOST=Quel serveur ?
DoYouHaveVdi=Avez-vous une VDI ?
UserProfileOps=OPS
UserProfileDev=DEV

DEBFULLNAME=Nom complet:
DEBEMAIL=Email:
BadDEBEMAIL=Adresse e-mail invalide.

VdiHostname=FQDN de votre VDI:
VdiIpAddress=Adresse IP:
WIN_USERNAME=CUID:
USER_NAME=Utilisateur LDAP:
UserTenantSwarm=Tenant:
UserGitlabNameSpaces=Groupes GitLab (séparés par des virgules):
GitlabNamespaceNotFound=Le groupe GitLab '%1' n'a pas été trouvé.%nVeuillez vérifier que vous avez bien saisi le nom du groupe.%n%nSi vous n'avez pas de groupe, laissez ce champ vide.

AuthentCuidTitle=Authentification AD
AuthentCuidMessage=Les identifiants AD seront utilisés par CNTLM (authentification NTLM) au sein de la distribution WSL.
AuthentLdapTitle=Authentification LDAP
AuthentLdapMessage=Les identifiants LDAP seront utilisés par CNTLM (authentification Basic Squid) au sein de la distribution WSL.%nMais aussi pour activer votre utilisateur au sein de WSL.
AuthentWslMessage=Les identifiants AD seront utilisés par CNTLM (authentification NTLM) au sein de la distribution WSL.%nMais aussi pour activer votre utilisateur au sein de WSL (nom d'utilisateur en minuscule).

PassPhraseSshTitle=Phrase secrète SSH
USER_PASSWORD=Mot de passe:
WIN_USER_PASSWORD=Mot de passe:
USER_PASSPHRASE=Phrase secrète SSH:
GITLAB_PRIVATE_TOKEN_DIOD=Jeton privé GitLab Diod:
GITLAB_PRIVATE_TOKEN_SPIRIT=Jeton privé GitLab Spirit:

GlobalIsAdmin=Cet installateur ne doit pas être exécuté en tant qu'administrateur.%nMerci de bien vouloir relancer l'installation normalement.
GlobalRebootComputer=Veuillez redémarrer votre ordinateur.%n%nVous pourrez ensuite commencer l'installation de LSW.
GlobalCanNotExecuteExit=Impossible d'exécuter le script "%1", arrêt de l'installation...

DeployToolsTitle=Installation d'outils supplémentaires
DeployToolsMsgBox=Si vous savez ce que vous faites, vous avez la possibilité de sauter l'étape d'installation des outils additionnels.%n%nLes outils suivants seront installés:%n%n- Git Portable%n%n- Microsoft VScode%n%n- Microsoft Terminal
DeployToolsContinue=Je souhaite continuer et installer les outils additionnels.
DeployToolsIgnore=Je souhaite ignorer cette étape.

DeployWslTitle=Activation de WSL
DeployWslMsgBox=Si vous savez ce que vous faites, vous avez la possibilité de sauter l'étape d'activation de WSL.
DeployWslContinue=Je souhaite continuer et activer WSL.
DeployWslIgnore=WSL est déjà activé, je souhaite ignorer cette étape.

WindowsAdminRequestTitle=AdMinute - Accès administrateur
WindowsAdminMsgBox=L'activation de certaines fonctionnalités Windows nécessitent des droits administrateur.%n%nVous devez en faire la demandre via 'AdMinute', puis ensuite redémarrer votre ordinateur.
WindowsAdminRequestContinue=Je souhaite demander les droits administrateur avec AdMinute.
WindowsAdminRequestIgnore=Je dispose déjà des droits d'administrateur, et j'ai déjà redémarré mon ordinateur pour les activer.

WindowsAdminRequest0=Une page vers AdMinute s'est ouverte pour vous permettre de devenir administrateur temporairement.%n%nSuivez les instructions ci-dessous:
WindowsAdminRequest1=1/ Cochez 'Pour installer une application ou un logiciel non-disponible en libre service sur le Centre Logiciel.'%n%n2/ Tapez 'LSW' dans le champs 'Nom de l'application'%n%n3/ Cliquez sur 'Etape suivante'%n%n4/ Cliquer sur 'Ouvrez les droits administrateur'
WindowsAdminRequest2=Si vous disposez déjà des droits administrateur, vous pouvez simplement ignorer cette étape et continuer le processus d'installation.

WindowsAdminRequestMsgBox=Avez-vous terminé la demande sur 'AdMinute' pour devenir Administrateur, et vous êtes prêt à redémarrer votre ordinateur ?
WindowsAdminRequested=Oui, j'ai terminé avec 'AdMinute' et je suis prêt à redémarrer mon ordinateur pour activer les droits.
WindowsAdminRefused=Je n'ai pas voulu demander les droits pour devenir Administrateur...

GoldapBadPassword=Mauvais nom d'utilisateur ou mot de passe LDAP.%nOu bien, votre compte LDAP n'est pas activé.
GoldapBadValidate=Impossible de valider le mot de passe LDAP de l'utilisateur.

WindowsBadPassword=Mauvais mot de passe AD.
WindowsBadValidate=Impossible de valider le mot de passe AD de l'utilisateur.

AuthenticationCuidLabel=Authentification Active Directory (CUID)

ComponentsServicesTitle=Services
ComponentsPfcPlatformsTitle=PlatForms Cloud
ComponentsEnvConfigTitle=Configuration de l'environnement

WslProxyMessage=Configuration dynamique du proxy sous Windows en fonction du réseau.

WslNotInstalled=WSL n'a pas pu être installé ou mis à jour.%nIl n'est pas possible de continuer l'installation de LSW.%nVeuillez tenter une approche manuelle pour mettre à jour WSL.
