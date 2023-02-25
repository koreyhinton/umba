#!/bin/bash

mkdir -p ${HOME}/.umba
mkdir -p ${HOME}/.umba/vars
mkdir -p ${HOME}/.umba/vars/fname

if [[ ! -e "${HOME}/.umba/vars/list" ]]; then
    touch "${HOME}/.umba/umba.list"
    echo  "${HOME}/.umba/umba.list" >"${HOME}/.umba/vars/list"
fi

if [[ ! -e "${HOME}/.umba/vars/local" ]]; then
    touch "${HOME}/.umba/vars/local"
    mkdir -p "${HOME}/.umba/umba"
    echo  "${HOME}/.umba/umba" >"${HOME}/.umba/vars/local"
fi

if [[ ! -e "${HOME}/.umba/vars/remote" ]]; then
    touch "${HOME}/.umba/vars/remote"
fi

function umba_var_set {
    if [[ -z "$1" ]]; then
        echo "Usage: "
        echo $'\t' "umba_var_set variable value"
        echo
        echo "variable | values"
        echo "---------+-------"
        echo "local    | " "$(cat ${HOME}/.umba/vars/local)"
        echo "remote   | " "$(cat ${HOME}/.umba/vars/remote)"
        echo "list     | " "$(cat ${HOME}/.umba/vars/list)"
        return 1;
    fi
    echo "$2" > "${HOME}/.umba/vars/$1"
    return 0;
}

