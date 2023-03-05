

function umba_do_remote {
    rem1=$(cat "${HOME}/.umba/vars/remote" | cut -d ';' -f 1)
    dir=$(cat "${HOME}/.umba/vars/local")
    dir="${dir}/latest"
    paths=`ls $dir`
    ts=$(date '+D%y%m%d_T%H%M%S')
    for f in $paths
    do
        # echo "${f}_${ts}"
        scp "${dir}/${f}" "$rem1/${f}_${ts}" 
    done
    return 0
}
