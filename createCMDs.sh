#!/bin/bash

#set -xe

[ "$#" -ne 1 ] && echo "Usage: $0 <originalSourceDir>" && exit 1

originalSourceDir="$(realpath "$1")"

[ ! -d "$originalSourceDir" ] && echo "Error: Directory '$originalSourceDir' does not exist." && exit 1

generate_commands() {
    file="${1// /\\ }"; experimentPath="${2// /\\ }"
    relative_path="${file#$originalSourceDir}"
    echo "rm $file" >> $experimentPath/delete.cmd
    echo "cp \$backupDir$relative_path \$originalSourceDir$relative_path" >> $experimentPath/restore.cmd
}

export -f generate_commands
export originalSourceDir

# Find all folders named 'Raw Images' in "$originalSourceDir" and save them into file folders.txt
> experimentPaths.txt
find "$originalSourceDir" -type d -name 'Raw Images' -print0 | while IFS= read -r -d '' folder; do
    echo "Processing folder: $folder"
    # find the folder name two levels up from 'Raw Images' and set it as experimentPath
    experimentPath="$(dirname "$(dirname "$folder")")"
    if `grep -qxF "$experimentPath" experimentPaths.txt`; then 
        echo "Experiment directory is already processed: $experimentPath"
        continue
    else 
        echo "$experimentPath" >> "experimentPaths.txt"
        > $experimentPath/delete.cmd
        > $experimentPath/restore.cmd
        find "$experimentPath/*/Raw\ Images" -type f -name '*.dat' -print0 | xargs -0 -I{} bash -c 'generate_commands "$@"' _ "{}" "$experimentPath"

        echo "Experiment path: $experimentPath" > "$experimentPath/readme.txt"
        echo >> "$experimentPath/readme.txt"

        echo "This folder contains the commands to delete and restore files." >> "$experimentPath/readme.txt"
        echo >> "$experimentPath/readme.txt"
       
        echo "You can take a look at the first 10 rows of delete.cmd using this command:" >> "$experimentPath/readme.txt"
        echo "head -n 10 $experimentPath delete.cmd" >> "$experimentPath/readme.txt"
        echo >> "$experimentPath/readme.txt"

        echo "To delete files, run: " >> "$experimentPath/readme.txt"
        echo "bash $experimentPath/delete.sh" >> "$experimentPath/readme.txt"
        echo >> "$experimentPath/readme.txt"

        echo "You can take a look at the first 10 rows of restore.cmd using this command:" >> "$experimentPath/readme.txt"
        echo "head -n 10 $experimentPath/restore.cmd" >> "$experimentPath/readme.txt"
        echo >> "$experimentPath/readme.txt"
        
        echo "To restore files, run: " >> "$experimentPath/readme.txt"
        echo "bash/$experimentPath/restore.sh backupDir originalSourceDir" >> "$experimentPath/readme.txt"
    fi

    
done 

echo all done