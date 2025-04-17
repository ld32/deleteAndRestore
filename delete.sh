#!/bin/bash

#set -ex 

cmdFile="$1"

if [ ! -f "$cmdFile" ]; then
    echo "Error: Command file '$cmdFile' does not exist."
    exit 1
fi

echo -e "Please give the number of rows you want to check: "
read -p "" x </dev/tty

[[ "$x" =~ ^[0-9]+$ ]] || { echo -e "Error: should be a number"; exit 1; }
         
head -n "$x" "$cmdFile" | sed 's/\\"/"/g'   

echo -e "Continue to delete .dat files? (y/n): "

read -p "" confirm </dev/tty

[[ "$confirm" == y ]] || { echo -e "Aborted"; exit 0; } 

cat "$cmdFile" | xargs -I {} -P 4 sh -c "{}"

echo All done