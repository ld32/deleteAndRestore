# Delete and Restore .dat files

## Create testing data: 
createTestData.sh testData 3 2 2 

For help: 
createTestData.sh 

## Backup the data: 
cp testData backupDir 

## Build delete and restore commands: 
buildCMDs.sh testData 

For help: 
buildCMDs.sh 

## Actaully delete .dat files from folder testData
delete.sh 

## Check the difference between testData and backupDir
diff -r testData backupDir 

## Restore .dat files from backup folder
restore.sh backupDir/ testData/

## Check the difference between testData and backupDir
diff -r testData backupDir 

## Notice:
testData and backupDir are folder names. You can use any name for them.
