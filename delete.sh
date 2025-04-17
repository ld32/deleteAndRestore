#!/bin/bash

#set -ex 

cmdFile="$1"

if [ ! -f "$cmdFile" ]; then
    echo "Error: Command file '$cmdFile' does not exist."
    exit 1
fi

cat "$cmdFile" | xargs -I {} -P 4 sh -c "{}"

echo All done