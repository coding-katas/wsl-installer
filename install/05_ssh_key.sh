#!/usr/bin/env bash
# shellcheck disable=SC1091

source "${LSW_DIR:-/opt/orange/lsw}"/install/vars.sh >/dev/null

#### Try to copy SSH key from Windows user's profile
sWinUserProfile="$(wslpath -u "$(sudo "${binSudoArgs[@]}" wslvar --sys USERPROFILE 2>/dev/null)" 2>/dev/null)"
if [[ -n ${sWinUserProfile} && -d ${sWinUserProfile}/ ]]; then
    if [[ -f ${sWinUserProfile}/.ssh/id_rsa ]]; then
        echo
        echo -e "${CBLUE}########################${CEND} ${CYELLOW}Copying SSH key from Windows user's profile${CEND}"

        install -v -d -m 0700 -o "${USER_NAME}" -g "${USER_GROUP}" /home/"${USER_NAME}"/.ssh
        cp -fv "${sWinUserProfile}"/.ssh/id_rsa* /home/"${USER_NAME}"/.ssh/
        chown -Rv "${USER_NAME}":"${USER_GROUP}" /home/"${USER_NAME}"/.ssh/*
        chmod -Rv 0600 /home/"${USER_NAME}"/.ssh/*

        # Try to load SSH key copyed from Windows user's profile
        gfnSshAgent 2>/dev/null || rm -fv /home/"${USER_NAME}"/.ssh/id_rsa*
    fi
fi

#### Temporary SSH key
if [[ ! -f /home/${USER_NAME}/.ssh/id_rsa ]]; then
    echo
    echo -e "${CBLUE}########################${CEND} ${CYELLOW}Creating local user's SSH key${CEND}"

    # SSH key identification
    sVersion="$(git -C "${LSW_DIR}" describe --tags "$(git -C "${LSW_DIR}" rev-list --tags --max-count=1)" 2>/dev/null)"
    [[ -z ${sVersion} ]] && sVersion="0.0.0"
    sKeyComment="${DEBEMAIL} - ${sVersion}"

    install -v -d -m 0700 -o "${USER_NAME}" -g "${USER_GROUP}" /home/"${USER_NAME}"/.ssh
    ssh-keygen -t rsa -b 4096 -C "${sKeyComment}" -f /home/"${USER_NAME}"/.ssh/id_rsa -N "${USER_PASSPHRASE}"
    chown -Rv "${USER_NAME}":"${USER_GROUP}" /home/"${USER_NAME}"/.ssh/*
    chmod -Rv 0600 /home/"${USER_NAME}"/.ssh/*
fi
if [[ ! -f /home/${USER_NAME}/.ssh/config ]]; then
    {
        echo "Host gitlab.tech.orange gitlab.si.francetelecom.fr"
        echo "  StrictHostKeyChecking no"
    } | tee -a /home/"${USER_NAME}"/.ssh/config
fi
