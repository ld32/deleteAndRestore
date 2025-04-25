#!/bin/bash

#set -ex 

usage(){
    echo "$0 <backupDir> <originalSourceDir> <pathToRestore.cmd>" && exit 1
}

[ -z "$1" ] && usage 
[ -z "$2" ] && usage 
[ -z "$3" ] && usage

quiet=$4 

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

cmdFile="$3"

if [ ! -f "$cmdFile" ]; then
    echo "Error: Command file '$cmdFile' does not exist."
    exit 1
fi

if [ -z "$quiet" ]; then 

    echo -e "Please give the number of rows you want to check: "
    read -p "" x </dev/tty

    [[ "$x" =~ ^[0-9]+$ ]] || { echo -e "Error: should be a number"; exit 1; }
            
    head -n "$x" "$cmdFile"

    echo -e "Continue to restore .dat files? (y/n): "

    read -p "" confirm </dev/tty

    [[ "$confirm" == y ]] || { echo -e "Aborted"; exit 0; } 
fi 

cat "$cmdFile" | xargs -d '\n' -I {} -P 4 sh -c "echo {}; {};" 

echo All done

date