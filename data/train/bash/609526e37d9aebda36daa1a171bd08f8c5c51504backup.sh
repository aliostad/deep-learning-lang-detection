#!/bin/bash
# Take the user's input for what to back up and where to save
# Default on saving in . if left undefined
# Sprinkle some sanity checks in there to be sure that 
# They're trying to back up a real thing
## To be fair, tar should tell them if the file they're trying to backup
## Doesn't exist

unset path;
if ! [ -d "${1}" ] && ! [ -f "${1}"  ]
then
        echo -e "Usage: backup /path/to/backup /path/to/save\nIf no save path is defined, default on ."
        exit 1
else
        path=$1;
        save=$2;
        check1=$(grep -o $path /);
        if ! [ -d "${2}" ]
        then
                save=".";
        fi
fi

# Backup the thing
# Produce an md5sum hash for integrity checks

if $check1
then
        save="${save}/${USER}_backup_$(date +%s).tar.gz";
        back=$(tar czpf $save $path);
        echo -e "Backup Completed\nmd5sum: $(md5sum "${save}")";
fi
