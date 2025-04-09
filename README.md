# Delete and Restore .dat files

## Create testing data: 
```bash
createTestData.sh testData/ 3 2 2 
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
buildCMDs.sh testData/ 
```

For help: 
```bash
buildCMDs.sh 
```

## Actaully delete .dat files from folder testData
```bash
delete.sh 
```

## Check the difference between testData and backupDir
```bash
diff -r testData/ backupDir/ 
```

## Restore .dat files from backup folder
```bash
restore.sh backupDir/ testData/
```

## Check the difference between testData and backupDir
```bash
diff -r testData/ backupDir/ 
```

## Notice:
testData and backupDir are folder names. You can use any name for them.
