#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

#### Variables ################################################################

aFilesToLoad=(
    "${LSW_DIR}"/install/vars.sh
)
for sFile in "${aFilesToLoad[@]}"; do
    if [[ -f ${sFile} ]]; then
        source "${sFile}" >/dev/null
    fi
done
unset sFile aFilesToLoad

# Hebex Resolver
aHebexResolver=()
gaDns_Hebex=(
    '10.234.50.180'
    '10.234.71.124'
)
for sIp in "${gaDns_Hebex[@]}"; do
    aHebexResolver+=("@${sIp}")
done

sVdiIpAddress="$(dig +short +time=1 +tries=2 "${aHebexResolver[@]}" "${VDI_HOSTNAME}" 2>/dev/null)"
sVdiIpAddress="${sVdiIpAddress:-${VDI_IPADDRESS}}"
if [[ -n ${VDI_IPADDRESS} && ${VDI_IPADDRESS} != "${sVdiIpAddress}" ]]; then
    sVdiIpAddress="${VDI_IPADDRESS}"
fi

aSshOptions=(
    -4
    -o "PasswordAuthentication=yes"
    -o "PubkeyAuthentication=no"
    -o "StrictHostKeyChecking=no"
    -o "HashKnownHosts=no"
    -o "UserKnownHostsFile=${USER_HOME}/.ssh/known_hosts"
    -o "ConnectTimeout=10"
)

eval export SSHPASS='${USER_PASSWORD}'

binSsh=(
    sudo "${binSudoArgs[@]}"
    sshpass -e
    ssh -ttt -x -F "${USER_HOME}/.ssh/config" "${aSshOptions[@]}"
    "${USER_NAME}@${sVdiIpAddress}"
)

binScp=(
    sudo "${binSudoArgs[@]}"
    sshpass -e
    scp "${aSshOptions[@]}"
)

#### Execute ##################################################################

echo && echo -e "${CBLUE}Loading SSH keys${CEND}"
"${LSW_DIR}"/bin/lsw-load-ssh-keys >/dev/null
source "${USER_HOME}"/.ssh/.agent-profile

echo && echo -e "${CBLUE}Sending '${LSW_DIR}/install/install-on-vdi.sh' file to VDI${CEND}"

{
    echo "export BRANCH_LSW_REPO='${BRANCH_LSW_REPO}'"
    echo "export ENTITY_NAME='${ENTITY_NAME}'"
    echo "export ENTITY_NAME_LC='${ENTITY_NAME_LC}'"
    echo "export INSTALL_MODE='${INSTALL_MODE}'"
    echo "export INSTALL_LSW_ON_VDI='${INSTALL_LSW_ON_VDI}'"
} >/tmp/install-on-vdi.vars
if [[ -n ${ENTITY_NAME} && -n ${ENTITY_REPO_PATH} && -n ${BRANCH_ENTITY_REPO} ]]; then
    {
        echo "export BRANCH_ENTITY_REPO='${BRANCH_ENTITY_REPO}'"
        echo "export ENTITY_PROJECT_DIR='${ENTITY_PROJECT_DIR}'"
    } >>/tmp/install-on-vdi.vars
fi
chmod 0777 /tmp/install-on-vdi.vars

binCommand=(
    "${binScp[@]}"
    /tmp/install-on-vdi.vars
    "${USER_NAME}@${VDI_HOSTNAME}":/tmp/install-on-vdi.vars
)
"${binCommand[@]}"

binCommand=(
    "${binScp[@]}"
    "${LSW_DIR}"/install/install-on-vdi.sh
    "${USER_NAME}@${VDI_HOSTNAME}":/tmp/install-on-vdi.sh
)
"${binCommand[@]}"

binCommand=("${binSsh[@]}" sudo mkdir -pv /etc/orange)
"${binCommand[@]}" 2>/dev/null

binCommand=("${binSsh[@]}" sudo chown -Rhv root:"\$(id -gn ${USER_NAME})" /etc/orange)
"${binCommand[@]}" 2>/dev/null

binCommand=("${binSsh[@]}" sudo chmod -Rv 0650 /etc/orange)
"${binCommand[@]}" 2>/dev/null

binCommand=("${binSsh[@]}" sudo rm -f /etc/default/lsw)
"${binCommand[@]}" 2>/dev/null

echo && echo -e "${CBLUE}Executing '/tmp/install-on-vdi.sh' from VDI${CEND}"
binCommand=(
    "${binSsh[@]}"
    sudo -E /tmp/install-on-vdi.sh
)
"${binCommand[@]}"
