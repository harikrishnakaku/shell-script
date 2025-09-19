#!/bin/bash  #shebang line: tells the system to use bash shell to run this script

CSV_FILE="user.csv"			#Input of CSV file containing usernames, groups, full_names
DEFAULT_PASSWD="welcome@123"		#Default password for All Users
INACTIVE_DAYS="30"			#Number of days after password expiry before account becomes Inactive
LOG_FILE="/var/log/user_setup.log"	#Log file path to record script actions

#Ensure log file exists (creates if missing)
touch "$LOG_FILE"

#Check if script is run as root or without sudo
if [ "$EUID" -ne 0 ]
then
	echo "Please run this script with root or sudo"
	exit 1				#exit if not run as root or sudo
fi

#funtion definition for logging
log() {
	DATE=$(date '+%Y-%m-%d %H:%M:%S')       #Current Date & Time in Human Readable Formate
	echo "[$DATE] $1" | tee -a "$LOG_FILE"	#Write a message to console and append to Log file
}

#read the CSV file line by line
while IFS=',' read -r user groups full_name
do
	#Skip header line (username, groups, full_name) or Empty lines
	if [[ "$user" == "username" || -z "$user" ]]; then
		continue
	fi

	#Split the group field by ":" into an array 
	IFS=':' read -ra group_array <<< "$groups"
	for group in "${group_array[@]}"; do
		#Check if exist (getent searches group database)
		if ! getent group "$group"; then
			groupadd "$group"		#create group if it doesn't exist
			log "group $group created"	#function call
		fi
	done


	#Convert ":" seperated groups into "," formate for useradd
	GROUP_LIST=$(echo "$groups" | tr ':' ',')

	#Check if user already exists
	if id "$user" &> /dev/null
	then
		echo "$user already exist"		#if yes print message
	else
		#Create user with home directory (-m), group (-G) and shell (-s)
		useradd -m -c "$full_name" -G "$GROUP_LIST" -s /bin/bash "$user"
		if [ "$?" -eq 0 ]	#If useradd succeeded 
		then
			echo "$user:$DEFAULT_PASSWD" | chpasswd		#Set default password
			log "user $user created and add to $GROUP_LIST"	#function call
		else
			echo "failed to create $user"	#If useradd failed 
		fi
	fi


	#Set the maximum password age (30 days)
	chage -M 30 "$user"

	#Set account to lock after $INACTIVE_DAYS days of inactivity 
	chage -I "$INACTIVE_DAYS" "$user"



#End of while loop, reading from CSV file
done < "$CSV_FILE"

#function call (log completion message)
log "all User are processed"
