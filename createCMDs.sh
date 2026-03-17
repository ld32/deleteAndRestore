#!/bin/bash

set -eu 

#set -x

date 

[ "$#" -ne 1 ] && echo "Usage: $(basename "$0") <originalSourceDir>" && exit 1

originalSourceDir="$(realpath "$1")"

[ ! -d "$originalSourceDir" ] && echo "Error: Directory '$originalSourceDir' does not exist." && exit 1

generate_commands() {
    #set -x 
    file="${1// /\\ }"; experimentPath="${2// /\\ }"
    relative_path="${file#$originalSourceDir/}"
    echo "rm $file" >> $experimentPath/delete.cmd
    echo "rsync -a \$backupDir/$relative_path \$originalSourceDir/$relative_path" >> $experimentPath/restore.cmd
}

export -f generate_commands

export originalSourceDir

# Find all folders named 'Raw Images' in "$originalSourceDir" and save them into file folders.txt
[ -f experimentPaths.txt ] && rm experimentPaths.txt
find "$originalSourceDir" -type d -name 'Raw Images' -print0 | while IFS= read -r -d '' folder; do
    echo "Processing folder: $folder"
    # find the folder name two levels up from 'Raw Images' and set it as experimentPath
    experimentPath="$(dirname "$(dirname "$folder")")"
    if `[ -f experimentPaths.txt ] && grep -qxF "$experimentPath" experimentPaths.txt`; then 
        #echo "Experiment directory is already processed: $experimentPath"
        continue
    else 
        echo "$experimentPath" >> "experimentPaths.txt"
        [ -f "$experimentPath/delete.cmd" ] && rm "$experimentPath/delete.cmd"
        [ -f "$experimentPath/restore.cmd" ] && rm "$experimentPath/restore.cmd"
        [ -f "$experimentPath/delete.cmd.done" ] && rm "$experimentPath/delete.cmd.done"
        [ -f "$experimentPath/restore.cmd.done" ] && rm "$experimentPath/restore.cmd.done"
        [ -f "$experimentPath"/restore_*.cmd ] && rm "$experimentPath"/restore_*.cmd
        [ -f "$experimentPath"/restore_*.cmd.done ] && rm "$experimentPath"/restore_*.cmd.done

        if [ "$originalSourceDir" != *testData* ]; then
         
             echo "Before creating commands, the structure of the experiment directory is: "
            tree "$experimentPath"
        fi

        for dir in "$experimentPath"/*/Raw\ Images; do
           find "$dir" -type f -name '*.dat' -print0 | xargs -0 -I{} bash -c 'generate_commands "$1" "$2"'  _ "{}" "$experimentPath"
        done 
        
        split -l 1000 -d --additional-suffix=.cmd "$experimentPath/restore.cmd" "$experimentPath/restore_"    

        echo "Experiment path: $experimentPath" > "$experimentPath/readme.txt"
        echo >> "$experimentPath/readme.txt"

       if [ "$originalSourceDir" != *testData* ]; then
         
            echo "After creating commands, the structure of the experiment directory is: "
            tree "$experimentPath"
        fi 
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
        echo "bash $experimentPath/restore.sh backupDir $originalSourceDir" >> "$experimentPath/readme.txt"
    fi

    
done 

echo all done
date 