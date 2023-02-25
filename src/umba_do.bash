#!/bin/bash

function umba_do {
    # H_STEP Hash Steps (2 steps)
    # B_STEP Backup Steps (5 steps)
    ts=$(date '+D%y%m%d_T%H%M%S')
    backup_list="$1"
    backup_folder=$(cat "${HOME}/.umba/vars/local")
    mkdir -p "${backup_folder}/latest"
    mkdir -p "${backup_folder}/all"

    list_file=$(cat "${HOME}/.umba/vars/list")

    if [[ -z "$backup_list" ]]; then
        backup_list=$(cat "$list_file")
        echo "$backup_list"
    else
        # when argument is given, backup_list is equal to that single
        # file argument
        exists=$(cat "$list_file" | grep "$backup_list" | wc -l)
        fullpath=$(realpath "$backup_list")              # H_STEP_1
        if [[ $exists -eq 0 ]]; then
            echo "$fullpath" >>$list_file
        fi
        filename_hash=($(echo -n "$fullpath" | sha256sum)) # H_STEP_2
        echo "$fullpath" > "${HOME}/.umba/vars/fname/${filename_hash}"
    fi
    for f in $backup_list
    do
        filename_hash=($(echo -n "$f" | sha256sum)) # H_STEP_2
        if [[ ! -e "${backup_folder}/latest/${filename_hash}" ]]; then

            # backing up one that is new to the backup list:

            cp "$f" "${backup_folder}/latest/${filename_hash}" # B_STEP_1
            rem=$(cat "${HOME}/.umba/vars/remote") # B_STEP_2
            #     rem ex: user@server:path/
            if [[ -n "$rem" ]]; then # B_STEP_3
              scp "${backup_folder}/latest/${filename_hash}" "${rem}" # B_STEP_4
            fi
            cp "$f" "${backup_folder}/all/${filename_hash}_${ts}" # B_STEP_5
            continue
        fi
        hashA=($(sha256sum "${backup_folder}/latest/${filename_hash}"))
        hashB=($(sha256sum "$f"))
        if [[ "$hashA" = "$hashB" ]]; then
            continue
        fi

        # backing up one that has changed:

        cp "$f" "${backup_folder}/latest/${filename_hash}" # B_STEP_1
        rem=$(cat "${HOME}/.umba/vars/remote") # B_STEP_2
        #     rem ex: user@server:path/
        if [[ -n "$rem" ]]; then # B_STEP_3
            scp "${backup_folder}/latest/${filename_hash}" "${rem}" # B_STEP_4
        fi
        cp "$f" "${backup_folder}/all/${filename_hash}_${ts}" # B_STEP_5

    done
}
