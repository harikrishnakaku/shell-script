#!/bin/bash

DB_NAME="mysql"
BACKUP_DIR="/backup/db"
DATE="$(date +%F)"
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz"

#Create backup directory if it doesn't exists
mkdir -p ${BACKUP_DIR}

#Check if database exists
DB_EXISTS="$(mysql -e "SHOW DATABASES LIKE '${DB_NAME}';")"

if [ -z "$DB_EXISTS" ]
then
	echo "$(date): Backup Failed: ${DB_NAME} Doesn't Exists!."
	exit 1
fi

#Backup the database
mysqldump "${DB_NAME}" | gzip > "${BACKUP_FILE}"

#Check if backup was successful
if [ "$?" -eq 0 ]; then
	echo "$(date): Backup Successful: ${BACKUP_FILE}"
else
	echo "$(date): Backup Failed for ${DB_NAME}"
fi
