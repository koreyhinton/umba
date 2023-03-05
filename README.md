# umba
user-managed backup script

## install by sourcing umba.bash
```sh
. src/umba.bash

# setting up remote, remote umba dir should already exist
umba_var_set remote $USER@$HOSTNAME:/home/$USER/umba  # set remote
umba_var_set  # print variable values

# local backup (1 file)
umba_do $HOME/.bashrc

# local backup (all previously specified files)
umba_do

# remote backup (all latest local backup files)
umba_do_remote 
```

## tests

```sh
chmod +x test/ftr* # make new tests executable

test/ftr # print success and failures
test/ftr | grep FAIL # only print failures, silent on success
```
