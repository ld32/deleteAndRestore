# Delete and Restore .dat files

## Download and set up path: 
``` bash
cd $HOME
git clone https://github.com/ld32/deleteAndRestore.git
export PATH=$HOME/deleteAndRestore:$PATH  
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

## Actaully delete .dat files from folder testData
```bash
delete.sh testData/ld32/exp1/delete.cmd 
```

## Check the difference between testData and backupDir
```bash
diff -r testData/ backupDir/ 
```

## Restore .dat files from backup folder
```bash
restore.sh backupDir/ testData/ testData/ld32/exp1/restore.cmd
```

## Check the difference between testData and backupDir
```bash
diff -r testData/ backupDir/ 
```

## Notice:
testData and backupDir are folder names. You can use any name for them when working on real data.
