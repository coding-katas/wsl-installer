#!/usr/bin/env bash
# shellcheck disable=SC1091

#### Create empty /etc/hosts file
echo && echo -e "${CBLUE}Creating empty '/etc/hosts' file${CEND}"
sHostname=${WINDOWS_FQDN:-$(hostname -f)}
{
    echo "# localhost"
    echo "127.0.0.1       localhost"
    echo "127.0.1.1       ${sHostname} ${sHostname%%.*}"
} >/etc/hosts

if [[ -n ${VDI_HOSTNAME} && -n ${VDI_IPADDRESS} ]]; then
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
    if [[ -n ${VDI_HOSTNAME} && -n ${sVdiIpAddress} ]]; then
        {
            echo
            echo "# VDI"
            echo "${sVdiIpAddress}       ${VDI_HOSTNAME}"
        } >>/etc/hosts
    fi
fi
cat /etc/hosts
echo "${sHostname%%.*}" >/etc/hostname
hostname "${sHostname}"

source "${LSW_DIR:-/opt/orange/lsw}"/install/vars.sh

echo
echo -e "${CBLUE}########################${CEND} ${CYELLOW}Creating /etc/wsl.conf${CEND}"
gfnCreateWslConf

echo
echo -e "${CBLUE}########################${CEND} ${CYELLOW}Creating /etc/hosts${CEND}"
gfnGenerateHosts

if [[ -n ${USER_NAME} && -n ${USER_PASSWORD} && ! -d /home/${USER_NAME}/ ]]; then

    if [[ -n $(id -gn jdoe 2>/dev/null) ]]; then
        usermod --login "${USER_NAME}" --move-home --home /home/"${USER_NAME}" jdoe
        groupmod --new-name "${USER_GROUP}" jdoe
    else
        echo && echo -e "${CBLUE}Creating user [${USER_NAME}]${CEND}"
        useradd -m -U -s "/bin/bash" -u 1000 "${USER_NAME}" -c "${DEBFULLNAME}"
        grep "${USER_NAME}" /etc/passwd
    fi

    echo && echo -e "${CBLUE}Setting password for user [${USER_NAME}]${CEND}"
    echo -e "${USER_PASSWORD}\n${USER_PASSWORD}\n" | passwd "${USER_NAME}" 2>&1

    # echo && echo -e "${CBLUE}Updating sudo group with user [${USER_NAME}]${CEND}"
    # adduser "${USER_NAME}" sudo
fi

echo && echo -e "${CBLUE}Temporary allowing user without password for user [${USER_NAME}]${CEND}"
echo "${USER_NAME}     ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/wsl-installation
cat /etc/sudoers.d/wsl-installation

#### Replace 'jdoe' user used during RootFS builds
echo && echo -e "${CBLUE}Replace 'jdoe' user used during RootFS builds by [${USER_NAME}]${CEND}"
find /etc/ -type f -name "*-" -print0 | xargs -0 rm -fv
while read -r sFile; do
    sed -i '/jdoe/d;' "${sFile}"
done < <(grep -r -o -l 'jdoe' /etc/)
find /home/"${USER_NAME}"/ -type f -print0 | xargs -0 sed -i "s/jdoe/${USER_NAME}/g;"
rm -rfv \
    /var/spool/cron/crontabs/jdoe \
    /home/"${USER_NAME}"/datas/orange/git/jdoe \
    /etc/orange/user

#### Repair bad symlinks
echo && echo -e "${CBLUE}Repairing bad symlinks${CEND}"
while read -r sFile sLink; do
    sudo ln -snfv "${sFile//jdoe/${USER_NAME}}" "${sLink}"
done < <(find /usr/local/bin/ -xtype l ! -exec ls -l {} \; | awk '{print $11" "$9}')
