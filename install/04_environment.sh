#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

WSL_CONGIGURE_IGNORE_ACTIONS=1
export WSL_CONGIGURE_IGNORE_ACTIONS

source "${LSW_DIR:-/opt/orange/lsw}"/install/vars.sh >/dev/null

#### /etc/orange/wsl
source "${LSW_DIR}"/install/etc-orange-wsl.sh

#### /etc/orange/user
source "${LSW_DIR}"/install/etc-orange-user.sh

#### /etc/orange/entity
[[ -n ${ENTITY_PROJECT_DIR} && -f ${ENTITY_PROJECT_DIR}/install/etc-orange-entity.sh ]] &&
    source "${ENTITY_PROJECT_DIR}"/install/etc-orange-entity.sh

#### Directories & files
source "${LSW_DIR}"/install/dir-and-files.sh

#### 00-init.sh
source "${LSW_DIR}"/install/rootfs/etc/profile.d/00-init.sh

#### rootfs.sh
source "${LSW_DIR}"/install/rootfs.sh

#### CNTLM
echo
echo -e "${CBLUE}########################${CEND} ${CYELLOW}Compiling CNTLM${CEND}"
source "${LSW_DIR}"/install/cntlm.sh

unset WSL_CONGIGURE_IGNORE_ACTIONS
