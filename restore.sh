#!/bin/bash

#set -ex 

usage(){
    echo "$0 <backupDir> <originalSourceDir> <pathToRestore.cmd>" && exit 1
}

[ -z "$1" ] && usage 
[ -z "$2" ] && usage 
[ -z "$3" ] && usage

export backupDir="$1"
if [ ! -d "$backupDir" ]; then
    echo "Error: Backup directory '$backupDir' does not exist."
    usage
    exit 1
fi
export originalSourceDir="$2"
if [ ! -d "$originalSourceDir" ]; then
    echo "Error: Original source directory '$originalSourceDir' does not exist."
    usage
    exit 1
fi

cmdFile="$3"

if [ ! -f "$cmdFile" ]; then
    echo "Error: Command file '$cmdFile' does not exist."
    exit 1
fi

cat "$cmdFile" | xargs -I {} -P 4 sh -c "{}"

echo All done