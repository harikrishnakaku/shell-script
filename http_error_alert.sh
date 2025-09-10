#!/bin/bash   #Tells the system to use bash shell to run this script

#Promt the user to enter the input
read -p "Enter the log file: " LOG_FILE
read -p "Enter the E-Mail ID: " MAIL

#Define the subject line of the email
SUBJECT="Alert: 500 Series error detected."

#check if the log file is exist
if [ -f "$LOG_FILE" ]; then

	#search the log file for http (500-599) status codes
	#look for 500 series in the log file
	ERROR=$(grep -E '\b5[0-9]{2}\b' "$LOG_FILE")
	
	#check if the variable ERROR is non-zero
	if [ -n "$ERROR" ]; then
		echo "500 series error detected in $LOG_FILE"
		
		#send the error details via email
		echo -e "error was detected in $LOG_FILE \n\n $ERROR" \
		| mail -s "$SUBJECT" "$MAIL"

		echo "Mail was sent $MAIL"
	else
		#if no error found in log file, print a message
		echo "500 series errors not detected in $LOG_FILE"
	fi
else
	#if the file does not exist, show an error
	echo "$LOG_FILE file was not found."
fi

