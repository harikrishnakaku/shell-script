#!/bin/bash

DB_NAME="hari"
TABLES=("tbl1" "tbl2" "tbl3")
BACKUP_DIR="/backup/db"
DATE="$(date +%F)"
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_table_${DATE}.sql.gz"
LOG_FILE="${BACKUP_DIR}/mysql_db_backup.log"


#Check Database if exists
DB_EXISTS="$(mysql -e "SHOW DATABASES LIKE '$DB_NAME';")"

if [ -z "$DB_EXISTS" ]
then
	echo "$(date): Backup Failed - Database $DB_NAME does not exist" | tee -a "$LOG_FILE"
	exit 1
fi


#Validate table exist
VALID_TABLES=()		#Array to store only existing tables
for tbl in "${TABLES[@]}"; do
	TABLE_EXISTS=$(mysql -D "$DB_NAME" -e "SHOW TABLES LIKE '${tbl}';")
	if [ -n "${TABLE_EXISTS}" ]
	then
		VALID_TABLES+=("$tbl")	#Add valid table to array
	else
		echo "$(date): Table ${tbl} does not exists on ${DB_NAME} Database. skipping..." | tee -a "${LOG_FILE}"
	fi
done


#Check if we have valid tables to backup
if [ "${#VALID_TABLES[@]}" -eq 0 ]
then
	echo "$(date): No valid tables to backup in ${DB_NAME} Database. Backup aborted." | tee -a "${LOG_FILE}"
	exit 1
fi

#Perform backup
set -o pipefail
mysqldump "${DB_NAME}" "${VALID_TABLES[@]}" | gzip > "$BACKUP_FILE"
status=$?


#Log backup result
if [ "$status" -eq 0 ]
then
	echo "$(date): Backup successful: ${BACKUP_FILE}" | tee -a "$LOG_FILE"
else
	echo "$(date): Backup Failed for ${DB_NAME}" | tee -a "$LOG_FILE"
fi


