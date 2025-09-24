#!/bin/bash

#Show top 5 largest files in /
echo "Top 5 largest files in root filesystem"
du -ah / 2>/dev/null | sort -rh | head -n 5
