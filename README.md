# Delete and Restore .dat files


## Start an interactive job, create a working directory and go to it: 
```bash
srun -p short -t 2:0:0 --mem 2G --pty /bin/bash 
cd $HOME
mkdir -p deleteRestoreTesting 
cd deleteRestoreTesting
```

## Download the scripts and set up path (only need to do this once): 
``` bash
cd $HOME
git clone https://github.com/ld32/deleteAndRestore.git
echo "export PATH=$HOME/deleteAndRestore:\$PATH" ~/.bashrc  
export PATH="$HOME/deleteAndRestore:$PATH"
```

## Create testing data: 
```bash

createTestData.sh exp1 2 2 2

createTestData.sh exp2 2 2 2

```

For help: 
```bash
createTestData.sh 
```

## Backup the data: 
```bash
cp -r testData/ backupDir/ 
```

## Take a look at the data: 
```bash
tree testData/ 
```

## Build delete and restore commands: 
```bash
createCMDs.sh testData/ 
```

For help: 
```bash
createCMDs.sh 
```

## Actaully delete .dat files from exp1 folder testData
```bash
delete.sh testData/exp1/delete.cmd 2>&1 | tee -a delete.log
```

## Actaully delete all .dat files from testData
```bash
deleteAll.sh testData/ 2>&1 | tee -a delete.log
```

## Check the difference between testData and backupDir
```bash
diff -r testData/ backupDir/ 
```

## Restore .dat files from backup folder
```bash
restore.sh backupDir/ testData/ testData/exp1/restore.cmd  2>&1 | tee -a restore.log
```

## Restore all .dat files from backup folder using a single command
```bash
restoreAll.sh backupDir/ testData/ 2>&1 | tee -a restore.log
```

## Restore all .dat files from backup folder using a single command using sbatch
```bash
restoreAll.sh backupDir/ testData/ sbatch 2>&1 | tee -a restore.log
```

## Check the difference between testData and backupDir
```bash
diff -r testData/ backupDir/ 
```

## Working with real data

I tested the scripts with 3T real data. 
The 3T data has 3035 .dat files to delete. 
Creating the .cmd file costed a few seconds; deleting the data spent less than 1 minutes; and restore the data costed 1 hour and 44 minutes. 
Because is slower to restore data, I modified the code to also create multiple restoreX.cmd files, each of them resotre 1000 .dat files. When restoring data, we use them to restore .dat files in batches.  

Notice: testData and backupDir are folder names. You can use any name for them when working on real data.
