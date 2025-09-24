#!/bin/bash	

#Set CPU and Memory thresholds
THRESHOLD_CPU=80
THRESHOLD_MEM=90

#Email address to send alerts
EMAIL="hari@gmail.com"

#Get current CPU and Memory usage
CPU=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{print 100-$4}' | cut -d. -f1)
MEM=$(free | grep "Mem" | awk '{print ($3/$2)*100}' | cut -d. -f1)

#Print current CPU and Memory Usage
echo "CURRENT CPU=$CPU% & MEMORY=$MEM%"

#Send Email only if CPU threshold exceeded 
if [ "$CPU" -ge "$THRESHOLD_CPU" ]; then
	echo "High CPU Usage: $CPU% on $(hostname)" | mail -s "CPU Alert on $(hostname)" "$EMAIL"
fi


#Send email only if Memory threshold exceeded
if [ "$MEM" -ge "$THRESHOLD_MEM" ]; then
	echo "High Memory usage: $MEM% on $(hostname)" | mail -s "Memory Alert on $(hostname)" "$EMAIL"
fi

