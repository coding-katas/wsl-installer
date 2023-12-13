#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

source "${LSW_DIR:-/opt/orange/lsw}"/install/vars.sh >/dev/null

#### DNS Lookup
"${LSW_DIR}"/bin/lsw-load-ssh-keys
source "${gsAgentProfile}"

echo && echo -e "${CBLUE}${LSW_DIR}${CEND}"

chown -R "${USER_NAME}":"${USER_GROUP}" "${LSW_DIR}"
"${binSudo[@]}" git -C "${LSW_DIR}" branch

gfnLswGitErase

chown -R "${USER_NAME}":"${USER_GROUP}" "${LSW_DIR}"
"${binSudo[@]}" git -C "${LSW_DIR}" branch

echo && echo -e "${CBLUE}Copying /etc/profile.d/*${CEND}"
cp -v "${LSW_DIR}"/install/rootfs/etc/profile.d/* /etc/profile.d/
chown -R root:root /etc/profile.d/*
chmod -v 0755 /etc/profile.d/*.sh
