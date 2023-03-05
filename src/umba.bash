#!/bin/bash

src_path="$(dirname -- "${BASH_SOURCE[0]}")"
: "${UMBA_PATH:=$src_path}"

# make sure path to all the scripts is set

if [[ -z "$UMBA_PATH" || ! -d "$UMBA_PATH" ]]; then
    echo "Error: UMBA_PATH is not set" 1>&2
    return 1;
fi

# umba function definition

function umba {
    # todo: report a quick estimate of how many backups are needed
    return 0
}

# For each src/ script 
# 1) source the script file name (except for this one)
# 2) assert it has an equivalent function name available

funs=""

scripts=$(ls ${UMBA_PATH}/umba*.bash)
# scripts=$(echo "$scripts" | head -c -1)  # remove trailing newline character

for script in $scripts
do
    fun_name=`basename "$script" | cut -d '.' -f1`
    if [[ -z "$funs" ]]; then
        funs="${fun_name}"
    else
        funs="${funs}"$'\n'"${fun_name}"  # $'\n'
    fi
done

# funs=$(echo "$funs" | head -c 1)  # remove trailing newline character

fun_cnt=$(echo "$funs" | wc -l)
fun_avail_cnt=0

umba_found=0

for fun in $funs
do
    if [[ "$fun" = umba ]]; then
        umba_found=1
    fi
done

if [[ $umba_found -eq 0 ]]; then
    echo "Error: UMBA_PATH variable is not set to umba.bash parent dir" 1>&2
    return 1;
fi

for fun in $funs
do
    if [[ ! "$fun" = "umba" ]]; then
        . "${UMBA_PATH}/${fun}.bash"
    fi
    type -t $fun 1>>/dev/null
    if [[ $? -eq 0 ]]; then
        ((fun_avail_cnt++))
    else
        echo "Error: function" "$fun" "not found" 1>&2
    fi
done

if [[ $fun_cnt -ne $fun_avail_cnt ]]; then
    echo "Error: failed to add sourced functions" 1>&2
    return 1;
fi

# call umba (backup and/or status upon login) function
umba
