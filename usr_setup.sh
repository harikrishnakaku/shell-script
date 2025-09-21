#!/bin/bash

CSV_FILE="usr.csv"
DEFAULT_PASSWORD="Welcome@123"

while IFS=',' read user group; do
	[ -z "$user" ] && continue		#Skip empty lines
	[[ "$user" =~ ^# ]] && continue		#Skip comment lines

	#Always ensure group exist
	if ! getent group "group" > /dev/null; then
		groupadd "$group"
		echo "Group $group created"
	fi



	if id "$user" &> /dev/null; then
		echo "$user user already exist"
		usermod -g "$group" "$user" 	#Ensure user is added to the group, if missing 
		echo "$user User added to $group Group"
	else
		#Create user and set password
		useradd -m -g "$group" "$user"
		echo "$user:$DEFAULT_PASSWORD" | chpasswd
		echo "$user User created and add to $group Group"
	fi
done < "$CSV_FILE"
