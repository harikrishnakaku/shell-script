#!/bin/bash
THRESHOLD=80
EMAIL="harikrishna.kaku999@gmail.com"

df -h | grep "^/dev" | while read line; do
  USAGE=$(echo "${line}" | awk '{print $5}'| sed 's/%//')
  PARTITION=$(echo "$line" | awk '{print $6}')

  if [ "$USAGE" -ge "$THRESHOLD" ]; then
	  echo "Warning: $PARTITION is ${USAGE}% full On $(hostname)" \
		  | mail -s "Disk Alert: $PARTITION" "$EMAIL"
		    else
			    echo "Normal: $PARTITION Is ${USAGE}% full on $(hostname)"
  fi
done
