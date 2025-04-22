#!/bin/bash

set -e 
set -u
#set -x 

usage() {
    echo "Usage: $0 <baseDir> <numDirs> <numFilesPerDir> <numSubDirs>"
    echo "  <baseDir>        - The base directory where test data will be created."
    echo "  <numDirs>        - Number of top-level directories to create."
    echo "  <numFilesPerDir> - Number of files to create in each directory."
    echo "  <numSubDirs>     - Number of subdirectories to create in each directory."
}

if [ "$#" -ne 4 ]; then
    usage
    exit 1
fi

baseDir=testData/$USER/"$1"
numDirs="$2"
numFilesPerDir="$3"
numSubDirs="$4"

mkdir -p "$baseDir"

baseDir=`realpath $baseDir`

fileExtensions=("txt" "log")

# first leve directories
for (( dirIndex=1; dirIndex<=numDirs; dirIndex++ )); do
    dirPath="$baseDir/dir_$dirIndex"
    mkdir -p "$dirPath"
    echo "Creating directory: $dirPath"

    for (( fileIndex=1; fileIndex<=numFilesPerDir; fileIndex++ )); do
        for ext in "${fileExtensions[@]}"; do
            filePath="$dirPath/file_${fileIndex}.${ext}"
            echo "This is test content for file $fileIndex with extension .${ext} in directory $dirIndex" > "$filePath"
            echo "Created file: $filePath"
        done
    done

    # second level directories
    # Create a 'Raw Images' directory in each subdirectory
    rawImagesPath="$dirPath/Raw Images"
    mkdir -p "$rawImagesPath"
    
    for i in {1..10}; do 
        filePath="$rawImagesPath/dat_file_$i.dat"
        echo "This is test content for .dat file $i in 'Raw Images'" > "$filePath"
        echo "Created file: $filePath"
    done

    for (( subDirIndex=1; subDirIndex<=numSubDirs; subDirIndex++ )); do
        subDirPath="$dirPath/subdir_$subDirIndex"
        mkdir -p "$subDirPath"
        echo "Creating subdirectory: $subDirPath"

        for (( fileIndex=1; fileIndex<=numFilesPerDir; fileIndex++ )); do
            for ext in "${fileExtensions[@]}"; do
                filePath="$subDirPath/file_${fileIndex}.${ext}"
                echo "This is test content for file $fileIndex with extension .${ext} in subdirectory of directory $dirIndex" > "$filePath"
                echo "Created file: $filePath"
            done
        done

        # third level directories
        for (( subDirIndex=1; subDirIndex<=numSubDirs; subDirIndex++ )); do
            subDirPath="$dirPath/subdir_$subDirIndex"
            mkdir -p "$subDirPath"
            echo "Creating subdirectory: $subDirPath"

            for (( fileIndex=1; fileIndex<=numFilesPerDir; fileIndex++ )); do
                for ext in "${fileExtensions[@]}"; do
                    filePath="$subDirPath/file_${fileIndex}.${ext}"
                    echo "This is test content for file $fileIndex with extension .${ext} in subdirectory of directory $dirIndex" > "$filePath"
                    echo "Created file: $filePath"
                done
            done
        done    

    done
done

echo "Test data generation complete. It is in $baseDir"