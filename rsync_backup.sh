#!/bin/bash 	#Shebang Line: Tells the system to use the bash shell to run this script

SOURCE="/data/"		#The source Directory that you want to backup
DEST="root@192.168.49.238:/backup/data"	#The destination path where backup will be stored (remote server with IP Address)
LOG_FILE="/var/log/backup.log"	#File where the backup logs (success, error, details) will be written 

#Check if source exists
if [ ! -d "$SOURCE" ]; then
	echo "Source Directory $SOURCE doesn't exist. Backup aborted on $(date)" >> "$LOG_FILE"
	exit 1
fi


#run rsync command to synchronize files
rsync -avz --delete "$SOURCE" "$DEST" >> "$LOG_FILE" 2>&1
status=$?	#Capture the exit status of previous command

if [ "$status" -eq 0 ]; then
	echo "Backup Successful on $(date)" >> "$LOG_FILE"	#If rsync exit status is 0, it means backup successfully commpleted
else
	echo "Backup failed on $(date)" >> "$LOG_FILE"		#If rsync exit status is not 0, it means backup failed.
fi
