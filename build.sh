#!/usr/bin/env bash

# Find out how the script was invoked
# we don't want to end the user's terminal session!
if [[ "$0" != "${BASH_SOURCE[0]}" ]]; then
    # this script is executed via `source`!
    # An `exit` will close the user's console!
    sReturnOrExit="return"
else
    # this script is not `source`, it's safe to exit via `exit`
    sReturnOrExit="exit"
fi

#### Variables ################################################################

nExit=0
sScriptName="${0}"
WORKDIR="${PWD}"
binCurl=(curl --retry 5 --retry-delay 10 -k -L -S --progress-bar)
bDoTestInnosetup=0
bDoBuildInstaller=0

CI_API_V4_URL="${CI_API_V4_URL:-https://gitlab.tech.orange/api/v4}"
CI_API_V4_URL="${CI_API_V4_URL%/}"
PROJECT_ID_LSW="${PROJECT_ID_LSW:-253632}"
PROJECT_ID_LSW_INSTALLER="${PROJECT_ID_LSW_INSTALLER:-253636}"

ARTIFACTORY_REGISTRY_HOST="${ARTIFACTORY_REGISTRY_HOST:-dom-oasis-registry.artifactory.si.francetelecom.fr}"
INNOSETUP_DOCKER_IMAGE="${ARTIFACTORY_REGISTRY_HOST}/getting-started/work-environment/lsw-projects/building-space/innosetup-docker-image"
INNOSETUP_DOCKER_IMAGE_TAG="${INNOSETUP_DOCKER_IMAGE_TAG:-latest}"
BRANCH_LSW_REPO="${BRANCH_LSW_REPO:-master}"
BRANCH_ENTITY_REPO="${BRANCH_ENTITY_REPO:-master}"
ROOTFS_ORIGIN="${ROOTFS_ORIGIN:-docker}"
DISTRO_VERSION="${DISTRO_VERSION:-20.04}"
ENTITY_NAME="${ENTITY_NAME:-PFC}"
APP_NAME="${APP_NAME:-WSL-Ubuntu-${DISTRO_VERSION}-${ENTITY_NAME}}"

if [[ -z ${LSW_VERSION} ]]; then
    LSW_VERSION="$(curl -Ss --request GET --header "PRIVATE-TOKEN: ${GITLAB_CI_TOKEN}" \
        "${CI_API_V4_URL}/projects/${PROJECT_ID_LSW}/repository/tags" | jq -r '.[0] | .name')"
    if [[ ! ${BRANCH_LSW_REPO} =~ master && ! ${BRANCH_LSW_REPO} =~ main ]]; then
        LSW_VERSION="${LSW_VERSION}-a1"
    fi
fi
LSW_VERSION="${LSW_VERSION:-${BRANCH_LSW_REPO}}"

INSTALLER_VERSION="$(
    curl -Ss --request GET \
        --header "PRIVATE-TOKEN: ${GITLAB_CI_TOKEN}" "${CI_API_V4_URL}/projects/${PROJECT_ID_LSW_INSTALLER}/repository/tags" | jq -r '.[0] | .name'
)"
INSTALLER_NAME="WSL-Ubuntu-${DISTRO_VERSION}-${ENTITY_NAME}_Setup-${INSTALLER_VERSION}_LSW-${LSW_VERSION}"

DEBUG_MODE="${DEBUG_MODE:-no}"

# CNTLM
CNTLM_VERSION="${CNTLM_VERSION:-0.92.3}"
CNTLM_URL="https://${ARTIFACTORY_REGISTRY_HOST}/dom-oasis-generic/LSW/Build/CNTLM/cntlm-${CNTLM_VERSION}.httpauth.tar.gz"

# GoLDAP
# https://gitlab.si.francetelecom.fr/getting-started/work-environment/lsw-projects/building-space/goldap
GOLDAP_VERSION="${GOLDAP_VERSION:-v1.4.0}"
GOLDAP_URL="${GOLDAP_URL:-https://${ARTIFACTORY_REGISTRY_HOST}/dom-oasis-generic/LSW/Build/GoLDAP/goldap-windows-amd64_${GOLDAP_VERSION}.exe}"

# Artifactory - RootFS
ROOTFS_FILE_NAME="wsl-ubuntu-${DISTRO_VERSION}-${ENTITY_NAME,,}-${ROOTFS_ORIGIN}_${LSW_VERSION}.tar.gz"
ROOTFS_FILE_NAME_NOVERSION="wsl-ubuntu-${DISTRO_VERSION}-${ENTITY_NAME,,}-${ROOTFS_ORIGIN}.tar.gz"
sDefault="https://${ARTIFACTORY_REGISTRY_HOST}/dom-oasis-generic/LSW/RootFS/${ENTITY_NAME}/${BRANCH_LSW_REPO}/${ROOTFS_FILE_NAME}"
ROOTFS_URL="${ROOTFS_URL:-${sDefault}}"

# Artifactory - WSL-VPNkit
# https://gitlab.tech.orange/getting-started/work-environment/lsw-projects/building-space/wsl-vpnkit
WSLVPNKIT_VERSION="${WSLVPNKIT_VERSION:-v0.3.8-r0.1.0}"
WSLVPNKIT_FILENAME="wsl-vpnkit_${WSLVPNKIT_VERSION}.tar.gz"
WSLVPNKIT_URL="${WSLVPNKIT_URL:-https://artifactory.si.francetelecom.fr/artifactory/dom-oasis-generic/LSW/WSL/WSL-VPNkit/${WSLVPNKIT_FILENAME}}"

# Artifactory - Inno Setup installer
INSTALLER_AF_URL="${INSTALLER_AF_URL:-https://${ARTIFACTORY_REGISTRY_HOST}/dom-oasis-generic/LSW/Installer/${ENTITY_NAME}/${BRANCH_LSW_REPO%/}/}"

# Colors
CEND="\e[0m"
CYELLOW="\e[33m"
CGREEN="\e[32m"
CRED="\e[31m"
CBLUE="\e[34m"
CCYAN='\033[00;36m'
CWHITE='\033[00;37m'

# Mandatories variables to check before continue
mapfile -t aVariablesToCheck < <(cut -d= -f1 < <(grep -oP '(\b^[A-Z0-9_]*[A-Z]+[A-Z0-9_]*\b)=' "${sScriptName}" | uniq))
[[ -n ${ENTITY_REPO_GITLAB_HOST} ]] &&
    aVariablesToCheck+=(ENTITY_REPO_GITLAB_HOST)
[[ -n ${ENTITY_REPO_PATH} ]] &&
    aVariablesToCheck+=(ENTITY_REPO_PATH)

#### Functions ################################################################

# Usage
function gfnCmdShowUsage() {
    local sUsage

    sUsage+="\n"
    sUsage+="${CYELLOW}Available options:${CEND}\n"
    sUsage+="    ${CGREEN}-t | --test-innosetup${CEND}         Inno Setup build test\n"
    sUsage+="    ${CGREEN}-b | --build-installer${CEND}        Generate Inno Setup installer\n"
    sUsage+="    ${CGREEN}-h | --help${CEND}    Show this help\n"
    sUsage+="\n"

    echo -e "${sUsage}"
}

#### Logging
function stitle() {
    echo -e " ${CBLUE}$*${CEND}"
}
function ssubtitle() {
    echo -e "   >${CCYAN}$*${CEND}"
}
function smessage_ok() {
    echo -e "      ${CGREEN}[+]${CEND}  $*"
}
function smessage_nok() {
    echo -e "      ${CYELLOW}[-]${CEND}  $*"
}
function smessage_ko() {
    echo -e "      ${CRED}[-]${CEND}  $*"
}
function smessage_infos() {
    echo -e "      ${CWHITE}[*]${CEND}  $*"
}

#### Variables check ##########################################################

stitle "Checking variables"

for name in "${aVariablesToCheck[@]}"; do
    eval _value="\$${name}"

    if [[ -z "${_value}" ]]; then
        smessage_ko "$(printf "%-25s %s\n" "${name}" "${CGREEN}'${_value}'${CEND}")"
        nExit=1
    else
        case "${name}" in
            *TOKEN* | *PASS*) smessage_ok "$(printf "%-25s %s\n" "${name}" "${CGREEN}'********'${CEND}")" ;;
            *) smessage_ok "$(printf "%-25s %s\n" "${name}" "${CGREEN}'${_value}'${CEND}")" ;;
        esac
    fi
done
[[ ${nExit} -eq 1 ]] && ${sReturnOrExit} ${nExit}

#### Parameters check #########################################################

# Usage
if grep -q '\-\-help\|\-h' <<<"$@" || [[ -z "$*" ]]; then
    gfnCmdShowUsage
    ${sReturnOrExit} 0
fi

#### Parameters ###############################################################

if [[ $# -ge 1 ]]; then
    # : -> mandatory argument
    if ! OPTS=$(
        getopt --shell bash -o h,t,b -l test-innosetup,build-installer,help -n "${sScriptName} init" -- "$@"
    ); then
        echo -e "${CRED}Failed...${CEND}\n\n" >&2
        ${sReturnOrExit} 1
    fi
    eval set -- "${OPTS}"
    while true; do
        case "${1}" in
            --help | -h)
                gfnCmdShowUsage
                shift
                ;;
            -t | --test-innosetup)
                bDoTestInnosetup=1
                shift
                ;;
            -b | --build-installer)
                bDoBuildInstaller=1
                shift
                ;;
            --)
                shift
                break
                ;;
            \?)
                echo -e "${CRED}Unknown option !${CEND}"
                gfnCmdShowUsage
                ${sReturnOrExit} 1
                ;;
            :)
                echo -e "${CRED}Missing parameter for $opt option !${CEND}"
                ${sReturnOrExit} 1
                ;;
            *)
                ${sReturnOrExit} 1
                ;;
        esac
    done
else
    gfnCmdShowUsage
    ${sReturnOrExit} 0
fi

#### Execution ################################################################

[[ ${bDoTestInnosetup} -eq 1 ]] && bDoBuildInstaller=0

stitle "Downloading files"

aComponentsList=(
    "CNTLM|cntlm-${CNTLM_VERSION}.httpauth.tar.gz|${CNTLM_URL}"
    "GoLDAP|GoLDAP-windows-amd64.exe|${GOLDAP_URL}"
    "WSL-VPNkit|${WSLVPNKIT_FILENAME}|${WSLVPNKIT_URL}"
)

[[ ${bDoBuildInstaller} -eq 1 ]] &&
    aComponentsList+=("RootFS archive for '${ENTITY_NAME}'|${ROOTFS_FILE_NAME_NOVERSION}|${ROOTFS_URL}")

for sComponent in "${aComponentsList[@]}"; do
    sTitle="${sComponent%%|*}"
    sFile="$(echo "${sComponent}" | cut -d'|' -f 2)"
    sSubDir="${sFile%%/*}"
    sFile="${sFile##*/}"
    sUrl="$(echo "${sComponent}" | cut -d'|' -f 3)"
    sFilePath="${WORKDIR}/files"
    if [[ -n ${sSubDir} && -n ${sFile} && ${sSubDir} != "${sFile}" ]]; then
        sFilePath="${WORKDIR}/files/${sSubDir}"
    fi

    [[ ! -d ${sFilePath}/ ]] && mkdir -p "${sFilePath}"/

    ssubtitle "${sTitle}"
    smessage_infos "${sFilePath}/${sFile}"
    smessage_infos "${sUrl}"
    if [[ -f "${sFilePath}/${sFile}" ]]; then
        smessage_ok "done"
        continue
    fi
    if "${binCurl[@]}" --head --fail "${sUrl}" >/dev/null 2>&1; then
        if ! "${binCurl[@]}" -o "${sFilePath}/${sFile}" "${sUrl}"; then
            nExit=1
            smessage_ko "failed"
        else
            smessage_ok "done"
        fi
    # else
    #     case "${sTitle}" in
    #         *RootFS*)
    #             sUrl="${sUrl//${LSW_VERSION}/${BRANCH_LSW_REPO}}"
    #             smessage_nok "Remote file does not exists, trying with branch name '${BRANCH_LSW_REPO}' instead of tag '${LSW_VERSION}'"
    #             smessage_infos "${sUrl}"
    #             if ! "${binCurl[@]}" -o "${WORKDIR}/files/${sFile}" "${sUrl}"; then
    #                 nExit=1
    #                 smessage_ko "failed"
    #             else
    #                 smessage_ok "done"
    #             fi
    #             ;;
    #         *)
    #             nExit=1
    #             smessage_ko "Remote file does not exists"
    #             ;;
    #     esac
    fi
done

if [[ ${nExit} -eq 0 && -n ${ENTITY_REPO_PATH} && -n ${ENTITY_REPO_GITLAB_HOST} && ${ENTITY_NAME,,} != "pfc" ]]; then
    aCommand=(
        git clone --branch "${BRANCH_ENTITY_REPO}"
        "https://${GITLAB_CI_USER}:${GITLAB_CI_TOKEN}@${ENTITY_REPO_GITLAB_HOST}/${ENTITY_REPO_PATH//.git/}.git"
        "${WORKDIR}/entities/${ENTITY_NAME,,}"
    )
    stitle "Cloning '${ENTITY_REPO_PATH}'"
    smessage_infos "${aCommand[*]}"

    if "${aCommand[@]}"; then
        smessage_ok "done"
    else
        smessage_ko "failed"
    fi
    rm -rf "${WORKDIR}/entities/${ENTITY_NAME,,}/.git"
fi

stitle "Building Inno Setup installer for '${ENTITY_NAME}'"
if [[ ${nExit} -eq 0 ]]; then
    aCommand=(
        docker run --rm -i -v "${WORKDIR}":/work "${INNOSETUP_DOCKER_IMAGE}:${INNOSETUP_DOCKER_IMAGE_TAG:-latest}"
        "/OOutput"
        "/p"
        "/DDebugMode=${DEBUG_MODE}"
        "/DLSW_VERSION=${LSW_VERSION}"
        "/DInstallerVersion=${INSTALLER_VERSION}"
        "/DDISTRO_VERSION=${DISTRO_VERSION}"
        "/DROOTFS_ORIGIN=${ROOTFS_ORIGIN}"
        "/DWSL_DISTRO_NAME=${APP_NAME}"
        "/DBRANCH_LSW_REPO=${BRANCH_LSW_REPO}"
        "/DENTITY_NAME=${ENTITY_NAME}"
        "/DWSLVPNKIT_FILENAME=${WSLVPNKIT_FILENAME}"
    )
    if [[ ${ENTITY_NAME,,} != "pfc" ]]; then
        [[ -n ${ENTITY_REPO_PATH} ]] &&
            aCommand+=("/DENTITY_REPO_PATH=${ENTITY_REPO_PATH}")
        [[ -n ${BRANCH_ENTITY_REPO} ]] &&
            aCommand+=("/DBRANCH_ENTITY_REPO=${BRANCH_ENTITY_REPO}")
        [[ -n ${ENTITY_REPO_GITLAB_HOST} ]] &&
            aCommand+=("/DENTITY_REPO_GITLAB_HOST=${ENTITY_REPO_GITLAB_HOST}")
    fi

    aCommand+=(
        "/F${INSTALLER_NAME}"
        "${MAIN_INNOSETUP_ISS_FILE:-main.iss}"
    )

    smessage_infos "${aCommand[*]}"

    if "${aCommand[@]}"; then
        smessage_ok "done"
    else
        smessage_ko "failed"
        nExit=1
    fi
else
    smessage_nok "skiped"
    nExit=1
fi

stitle "Uploading Inno Setup installer to Artifactory"
if [[ ${bDoBuildInstaller} -eq 1 && ${nExit} -eq 0 ]]; then
    if [[ -f ${WORKDIR}/Output/${INSTALLER_NAME}.exe ]]; then
        sTempFile="$(mktemp)"
        {
            bUploaded=0
            nCount=0
            nMax=3
            while [[ ${bUploaded} -ne 1 ]]; do
                nCount=$((nCount + 1))
                if [[ ${nCount} -gt ${nMax} ]]; then
                    nExit=1
                    break
                fi

                echo
                ssubtitle "Pushing '${INSTALLER_NAME}.exe' Inno Setup installer to registry (${nCount}/${nMax})" 1>&2

                binCmd=(
                    "${binCurl[@]}"
                    -H "X-JFrog-Art-Api:${ARTIFACTORY_REGISTRY_API_KEY}"
                    -T "${WORKDIR}/Output/${INSTALLER_NAME}.exe"
                    "${INSTALLER_AF_URL}"
                )
                smessage_infos "${binCmd[*]}"

                if ! "${binCmd[@]}"; then
                    echo
                    smessage_ko "Pushing '${INSTALLER_NAME}.exe' Inno Setup installer to registry failed" 1>&2
                else
                    if ! "${binCurl[@]}" --head --fail "${INSTALLER_AF_URL}" >/dev/null 2>&1; then
                        echo
                        smessage_ko "Pushing '${INSTALLER_NAME}.exe' Inno Setup installer to registry failed" 1>&2
                    else
                        echo
                        smessage_ok "Pushing '${INSTALLER_NAME}.exe' Inno Setup installer to registry succeeded" 1>&2
                        bUploaded=1
                    fi
                fi
            done
        } >"${sTempFile}"
        if grep -q 'File length is 0 while total bytes read on stream is' "${sTempFile}"; then
            nExit=1
            cat "${sTempFile}"
        fi
    else
        smessage_ko "Missing file '${WORKDIR}/Output/${INSTALLER_NAME}.exe'"
        nExit=1
    fi
else
    smessage_nok "skiped"
fi

#### End of File ##############################################################

${sReturnOrExit} ${nExit}
