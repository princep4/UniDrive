#!/bin/bash

# Check for the WPSCAN



Target="$1"
var="$2"
BLUE='\033[94m'
COLOFF='\e[0m'
RED='\033[91m'
GREEN='\033[92m'
ORANGE='\033[93m'

echo "!!!!!!!!!!  CURL URLS  !!!!!!!!!!!"
mkdir wp-scan-result
while IFS= read -r url; 
do
    wpscan --url $url  > wp-scan-result/$( echo "$url" | awk -F/ '{print $3}')    # wpscan result transfer
done < $Target

# Check for cat abc.txt | grep -E "([+]|[\!])"
