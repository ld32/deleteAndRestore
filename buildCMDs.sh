#!/bin/bash

#set -xe

[ "$#" -ne 1 ] && echo "Usage: $0 <originalSourceDir>" && exit 1

originalSourceDir="$(realpath "$1")"

[ ! -d "$originalSourceDir" ] && echo "Error: Directory '$originalSourceDir' does not exist." && exit 1

> delete.cmd
> restore.cmd

generate_commands() {
    file="$1"
    relative_path="${file#$originalSourceDir}"
    echo "rm \"$file\"" >> delete.cmd
    echo "cp \"\$restoreDir$relative_path\" \"\$originalSourceDir$relative_path\"" >> restore.cmd
}

export -f generate_commands
export originalSourceDir

find "$originalSourceDir" -type f -name '*.dat' -print0 | xargs -0 -I{} -P 4 bash -c 'generate_commands "$@"' _ {}

echo First 5 rows of delete.cmd
head  -n 5 delete.cmd
echo
echo first 5 rows of restore.cmd 
head -n 5 restore.cmd

echo 
echo If review is satisfactory, please run this command to delete files:
echo delete.sh

echo
echo To restore, please run this command to restore files:
echo restore.sh restoreDir originalSourceDir
