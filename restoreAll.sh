#!/bin/bash

#set -ex 

usage(){
    echo "$0 <backupDir> <originalSourceDir> [sbatch]" && exit 1
}

[ -z "$1" ] && usage 
[ -z "$2" ] && usage
sbatch=$3

date

export backupDir="${1%/}"
if [ ! -d "$backupDir" ]; then
    echo "Error: Backup directory '$backupDir' does not exist."
    usage
    exit 1
fi

export originalSourceDir="${2%/}"
if [ ! -d "$originalSourceDir" ]; then
    echo "Error: Original source directory '$originalSourceDir' does not exist."
    usage
    exit 1
fi

find "$originalSourceDir" -type f -name 'restore_*.cmd' -print0 | while IFS= read -r -d '' cmdFile; do
    echo "Processing $cmdFile"
    if [ -f $cmdFile.done ]; then
        echo Done earlier: $cmdFile
    else 
        if [ -z "$sbatch" ]; then      
            cat "$cmdFile" | xargs -d '\n' -I {} -P 4 sh -c "echo {}; {};"
            touch $cmdFile.done
        else
            sbatch -p short --mem 2G -t 10:0:0 --wrap="restore.sh $backupDir $originalSourceDir $cmdFile quiet"
        fi
    fi
done 

echo All done
date