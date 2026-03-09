#!/bin/bash

set -eu
#set -x 

usage() {
    echo "Usage: $(basename "$0") <experimentDir> <numOfSubDirs> <numFilesPerDir>"
    echo "  <experimentDir>  - The directory where test data will be created."
    echo "  <numOfSubDirs>   - Number of subdirectories to create in each directory."
    echo "  <numFilesPerDir> - Number of files to create in each directory."
    exit 1
}

[ "$#" -ne 3 ] && usage

baseDir="testData/$1"
numDirs="$2"
numFilesPerDir="$3"
numSubDirs=1

mkdir -p "$baseDir"

baseDir="$(realpath "$baseDir")"

fileExtensions=("txt" "dat" "log")

# first leve directories
for (( dirIndex=1; dirIndex<=numDirs; dirIndex++ )); do
    # dirPath="$baseDir/dir_$dirIndex"
    # mkdir -p "$dirPath"
    # echo "Creating directory: $dirPath"

    # for (( fileIndex=1; fileIndex<=numFilesPerDir; fileIndex++ )); do
    #     for ext in "${fileExtensions[@]}"; do
    #         filePath="$dirPath/file_${fileIndex}.${ext}"
    #         echo "This is test content for file $fileIndex with extension .${ext} in directory $dirIndex" > "$filePath"
    #         echo "Created file: $filePath"
    #     done
    # done

    dirPath="$baseDir/subdir $dirIndex"
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
    
    for i in {1..5}; do 
        filePath="$rawImagesPath/file_$i.dat"
        echo "This is test content for .dat file $i in 'Raw Images'" > "$filePath"
        echo "Created file: $filePath"
    done

    for (( fileIndex=1; fileIndex<=numFilesPerDir; fileIndex++ )); do
        for ext in "${fileExtensions[@]}"; do
            filePath="$rawImagesPath/file_${fileIndex}.${ext}"
            echo "This is test content for file $fileIndex with extension .${ext} in directory $dirIndex" > "$filePath"
            echo "Created file: $filePath"
        done
    done

    for (( subDirIndex=1; subDirIndex<=numSubDirs; subDirIndex++ )); do
        subDirPath="$dirPath/subsubdir_$subDirIndex"
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
        # for (( subDirIndex=1; subDirIndex<=numSubDirs; subDirIndex++ )); do
        #     subDirPath="$dirPath/subdir_$subDirIndex"
        #     mkdir -p "$subDirPath"
        #     echo "Creating subdirectory: $subDirPath"

        #     for (( fileIndex=1; fileIndex<=numFilesPerDir; fileIndex++ )); do
        #         for ext in "${fileExtensions[@]}"; do
        #             filePath="$subDirPath/file_${fileIndex}.${ext}"
        #             echo "This is test content for file $fileIndex with extension .${ext} in subdirectory of directory $dirIndex" > "$filePath"
        #             echo "Created file: $filePath"
        #         done
        #     done
        # done
    done
done

echo "Test data generation complete. It is in $baseDir"