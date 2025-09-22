#!/bin/bash 	#Shebang line: tells the system to use bash to execute this script

#Archive and clean logs older than 7 days
LOG_DIR="/var/log/myapp"		#Directory where Application log files are store
BACKUP_DIR="/backup/logs"		#Directory where the archved logs will be store
ARCHIVE_FILE="$BACKUP_DIR/old_logs.tar"	#Path to the archive file

#Create a backup directory if not exists
mkdir -p "$BACKUP_DIR"

#Check if archive files already exist
if [ ! -f "$ARCHIVE_FILE" ]; then
	#If archive doesn't exist, find all .log files older than 7 days and create a new tar archive
	find "$LOG_DIR" -type f -name "*.log" -mtime +7 -print0 | xargs -0 tar -cvf "$ARCHIVE_FILE"
else
	#If archive exists, find all .log files older than 7 days and append them to existing tar archive
	find "$LOG_DIR" -type f -name "*.log" -mtime +7 -print0 | xargs -0 tar -rvf "$ARCHIVE_FILE"
fi

#check exit status of previous command(tar)
if [ "$?" -eq 0 ]; then
	#If tar was successful, delete .log files older than 7 days
	find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec rm -f {} \;
	echo "Old files archived and removed"
else
	#If tar failed, print the error message and exit with status 1
	echo "Archiving failed and old files not deleted."
	exit 1
fi
