#!/bin/bash

set -ex 

usage(){
    echo "$0 <restoreDir> <originalSourceDir>" && exit 1
}

[ -z "$1" ] || [ ! -d "$1" ] && usage 
[ -z "$2" ] || [ ! -d "$2" ] && usage 

export restoreDir="$1"
export originalSourceDir="$2"

cat restore.cmd | xargs -I {} -P 4 sh -c "{}"