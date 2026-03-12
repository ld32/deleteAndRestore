# Delete and Restore .dat files


## Start an interactive job, create a working directory and go to it: 
```bash
$ srun -p short -t 2:0:0 --mem 2G --pty /bin/bash 
$ cd $HOME
$ mkdir -p deleteRestoreTesting 
$ cd deleteRestoreTesting
```

## Download the scripts and set up path (only need to do this once): 
``` bash
$ cd $HOME
$ git clone https://github.com/ld32/deleteAndRestore.git
$ echo "export PATH=$HOME/deleteAndRestore:\$PATH" >> ~/.bashrc  
$ export PATH="$HOME/deleteAndRestore:$PATH"
```

## Create testing data: 
```bash
$ createTestData.sh exp1 1 1
$ createTestData.sh exp2 1 1

```

## Take a look at the folder structure
```bash

# We only delete .dat files under Raw Images, and keep all other files
$ tree testData/ 
testData/
├── exp1
│   └── subdir1
│       ├── file_1.dat
│       ├── file_1.log
│       ├── file_1.txt
│       ├── Raw Images
│       │   ├── file_1.dat
│       │   ├── file_1.log
│       │   ├── file_1.txt
│       │   ├── file_2.dat
│       │   ├── file_3.dat
│       │   ├── file_4.dat
│       │   └── file_5.dat
│       └── subsubdir_1
│           ├── file_1.dat
│           ├── file_1.log
│           └── file_1.txt
└── exp2
    └── subdir1
        ├── file_1.dat
        ├── file_1.log
        ├── file_1.txt
        ├── Raw Images
        │   ├── file_1.dat
        │   ├── file_1.log
        │   ├── file_1.txt
        │   ├── file_2.dat
        │   ├── file_3.dat
        │   ├── file_4.dat
        │   └── file_5.dat
        └── subsubdir_1
            ├── file_1.dat
            ├── file_1.log
            └── file_1.txt

8 directories, 26 files
```

## For help: 
```bash
$ createTestData.sh 
```

## Backup the data: 
```bash
$ cp -r testData/ backupDir/ 
```

## Build delete and restore commands: 
```bash
$ createCMDs.sh testData/ 
```

For help:
```bash
$ createCMDs.sh 
```

## Actaully delete .dat files from exp1 folder testData
```bash
$ delete.sh testData/exp1/delete.cmd 2>&1 | tee -a delete.log
```

## Actaully delete all .dat files from testData
```bash
$ deleteAll.sh testData/ 2>&1 | tee -a delete.log
```

## Check the difference between testData and backupDir
```bash
$ diff -r testData/ backupDir/
Only in testData/exp1: delete.cmd
Only in testData/exp1: delete.cmd.done
Only in testData/exp1: readme.txt
Only in testData/exp1: restore_00.cmd
Only in testData/exp1: restore.cmd
Only in testData/exp1: restore.cmd.done
Only in backupDir/exp1/subdir1/Raw Images: file_1.dat
Only in backupDir/exp1/subdir1/Raw Images: file_2.dat
Only in backupDir/exp1/subdir1/Raw Images: file_3.dat
Only in backupDir/exp1/subdir1/Raw Images: file_4.dat
Only in backupDir/exp1/subdir1/Raw Images: file_5.dat
Only in testData/exp2: delete.cmd
Only in testData/exp2: delete.cmd.done
Only in testData/exp2: readme.txt
Only in testData/exp2: restore_00.cmd
Only in testData/exp2: restore.cmd
Only in backupDir/exp2/subdir1/Raw Images: file_1.dat
Only in backupDir/exp2/subdir1/Raw Images: file_2.dat
Only in backupDir/exp2/subdir1/Raw Images: file_3.dat
Only in backupDir/exp2/subdir1/Raw Images: file_4.dat
Only in backupDir/exp2/subdir1/Raw Images: file_5.dat 
```

## Restore .dat files from backup folder
```bash
$ restore.sh backupDir/ testData/ testData/exp1/restore.cmd  2>&1 | tee -a restore.log
```

## Restore all .dat files from backup folder using a single command
```bash
$ restoreAll.sh backupDir/ testData/ 2>&1 | tee -a restore.log
```

## Check the difference between testData and backupDir
```bash
$ diff -r testData/ backupDir/ 
Only in testData/exp1: delete.cmd
Only in testData/exp1: readme.txt
Only in testData/exp1: restore_00.cmd
Only in testData/exp1: restore_00.cmd.done
Only in testData/exp1: restore.cmd
Only in testData/exp2: delete.cmd
Only in testData/exp2: readme.txt
Only in testData/exp2: restore_00.cmd
Only in testData/exp2: restore_00.cmd.done
Only in testData/exp2: restore.cmd

```

## Working with real data

I tested the scripts with 3T real data. 
The 3T data has 3035 .dat files to delete. 
Creating the .cmd file costed a few seconds; deleting the data spent less than 1 minutes; and restoring the data costed 1 hour and 44 minutes. 
Because it is slow to restore data, I modified the code to also split the commands into subset into files, each of them contains 1000 .dat files. When restoring data, we can use these subset files to restore .dat files in batches using sbatch command, each job restore 1000 files:
```bash
$ restoreAll.sh backupDir/ testData/ sbatch 2>&1 | tee -a restore.log
```

Notice: testData and backupDir are folder names. You can use any name for them when working on real data.
