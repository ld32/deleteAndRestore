#!/bin/bash

set -ex 

usage(){
    echo "$0 <backupDir> <originalSourceDir>" && exit 1
}

[ -z "$1" ] && usage 
[ -z "$2" ] && usage 

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
    #cat "$cmdFile" | xargs -d '\n' -I {} -P 4 sh -c "echo {}; {};"
    sbatch -p short --mem 2G -t 10:0:0 --wrap="restore.sh $backupDir $originalSourceDir $cmdFile quiet"
done 

echo All done
date