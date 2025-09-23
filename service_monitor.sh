#!/bin/bash

read -p "Enter the Service Name: " SERVICE
LOG_FILE="/var/log/service_monitor.log"

#Check if service is exists
if ! systemctl list-unit-files | grep -qw "${SERVICE}.service"
then
	echo "$SERVICE does not exists on the system" | tee -a "$LOG_FILE"
	exit 1
fi

#check if the service active
if ! systemctl -q is-active "${SERVICE}".service; then
	echo "$SERVICE service is down. Restarting...."
	systemctl restart "${SERVICE}.service"

	#Check if the restart command was successful
	if [ "$?" -eq 0 ]
	then
		echo "$(date): $SERVICE restarted Successfully" | tee -a "$LOG_FILE"
	else
		echo "$(date): $SERVICE service Failed to restart, Please check the logs manually." | tee -a "$LOG_FILE"
		exit 2
	fi
else
	echo "$(date): $SERVICE service is running fine" | tee -a "$LOG_FILE"
fi

