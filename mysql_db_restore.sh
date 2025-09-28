#!/bin/bash

DB_NAME="hari"
BACKUP_FILE="/backup/db/hari_table_2025-09-27.sql.gz"	#Path to backup file
LOG_FILE="/backup/db/restore.log"


#Check if backup file exists.
if [ ! -f "$BACKUP_FILE" ]; then
	echo "$(date): Restore Failed - Backup File ${BACKUP_FILE} not found." | tee -a "${LOG_FILE}"
	exit 1
fi

#Check if database exists, if not create it.
DB_EXISTS="$(mysql -e "SHOW DATABASES LIKE '${DB_NAME}';")"

if [ -z "$DB_EXISTS" ]; then
	echo "$(date): Database ${DB_NAME} does not exist. creating...." | tee -a "$LOG_FILE"
	mysql -e "CREATE DATABASE $DB_NAME;"
fi

#Restore Backup
echo "$(date): Starting restore of ${DB_NAME} database from ${BACKUP_FILE} file" | tee -a "$LOG_FILE"

set -o pipefail
gunzip -c "${BACKUP_FILE}" | mysql "${DB_NAME}"
status=$?


#Log result
if [ "$status" -eq 0 ]; then
	echo "$(date): Restore Successful for ${DB_NAME} database from ${BACKUP_FILE} file." | tee -a "$LOG_FILE"
else
	echo "$(date): Restore Failed for ${DB_NAME} database." | tee -a "${LOG_FILE}"
fi

