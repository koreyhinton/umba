#!/bin/bash

function umba_ls {
    list_file=$(cat "${HOME}/.umba/vars/list")
    cat "$list_file"
    return 0;
}
