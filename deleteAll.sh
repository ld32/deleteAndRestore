#!/bin/bash

#set -ex 

usage(){
    echo "$0 <originalSourceDir>" && exit 1
}

[ -z "$1" ] && usage 

date

originalSourceDir="${1%/}"

if [ ! -d "$originalSourceDir" ]; then
    echo "Error: Original source directory '$originalSourceDir' does not exist."
    usage
    exit 1
fi

find "$originalSourceDir" -type f -name 'delete.cmd' -print0 | while IFS= read -r -d '' cmdFile; do
    echo "Processing $cmdFile"
    if [ -f $cmdFile.done ]; then
        echo Done earlier: $cmdFile
    else 
        delete.sh $cmdFile quiet 
        touch $cmdFile.done
    fi
done 

echo All done
date