#!/bin/bash

#Main task is to visit site as low as possible



Target="$1"
var="$2"
BLUE='\033[94m'
COLOFF='\e[0m'
RED='\033[91m'
GREEN='\033[92m'
ORANGE='\033[93m'

declare -i wp_count=0

echo "%%%%%%%%%%%%%%%%%% WELCOME #########################"

echo -e " $ORANGE

   __  __      _ ____       _          
  / / / /___  (_) __ \_____(_)   _____ 
 / / / / __ \/ / / / / ___/ / | / / _ \ 
/ /_/ / / / / / /_/ / /  / /| |/ /  __/
\____/_/ /_/_/_____/_/  /_/ |___/\___/ \n

       By: 
        Prince Prafull
        @princep4
                                       
$COLOFF"
# echo -e "$BLUE %%%%%% Enter the Name of the project or domain %%%%%%%%%%%%%% $COLOFF"
# read -r domain
# mkdir $domain

# Curling URLS

# If you only wnat to test on crawled sites:
# hide from: 25 to 40 lines

# echo "!!!!!!!!!!  CURL URLS  !!!!!!!!!!!"
# mkdir curled_urls
# while IFS= read -r url; 
# do
# # Check if the curled file is present or not.
#    # var txt_file=`curled_urls/$( echo "$url" | awk -F/ '{print $3}')`
#    # if [ -f "$txt_file" ]
#    # then
#    #     echo "File Already curled"
#   #  else
#         curl -i -k --max-time 15 $url > curled_urls/$( echo "$url" | awk -F/ '{print $3}')    # 1st time request generated
#     #fi
# done < $Target


#NOW the choices are given

echo -e "$BLUE %%%%%% Tests you can perform %%%%%%%%%%%%%% $COLOFF"
echo -e "$BLUE %%%%%% c curl all the sites again $COLOFF"
echo -e "$BLUE %%%%%% 1. Clickjacking $COLOFF"
echo -e "$BLUE %%%%%% 2. Wp-check $COLOFF"
echo -e "$BLUE %%%%%% 3. CVE check (Aggressive) $COLOFF"
echo -e "$BLUE %%%%%% 4. technology $COLOFF"
echo -e "$BLUE %%%%%% 5. Sensitivie Information $COLOFF"
echo -e "$BLUE %%%%%% 6. Aggressive Scan $COLOFF"
echo -e "$BLUE %%%%%% 7. Web Traffic Analysis  $COLOFF"




mkdir technologies
echo -e "$BLUE Enter your choice $COLOFF"
read -r choice
# make text file for each and every domain to enter the data.

if [ $choice = "c" ] # Curl it again and making a file for each domain.
then
    mkdir curled_urls
    while IFS= read -r url; 
        do
        curl -i -k --max-time 15 --silent $url > curled_urls/$( echo "$url" | awk -F/ '{print $3}')
        echo "Testing ON $url " > technologies/$( echo "$url" | awk -F/ '{print $3}')
        echo -e "$RED ============== $url is Visited ===================$COLOFF"
    done < $Target
fi


if [ $choice = "1" ] # Clickjacking Code to check the headers
then
    while IFS= read -r url; 
    do
    echo -e "$ORANGE Testing Clickjacking on URL ==> $url $COLOFF"
    if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -i "X-Frame-Options: SAMEORIGIN" ; then
        echo -e "$GREEN ==============  IN $url clickjacking not possible $COLOFF"
    else
        echo -e " $RED ===============   IN $url Clickjacking Possible $COLOFF"
    fi 
    done < $Target

elif [ $choice = "2" ] # WordpressCheck
then
    echo -e "$ORANGE Testing Wordpress Check on URL ==> $url $COLOFF"
    while IFS= read -r url; 
    do
    
    if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q "wp-" ; then
        echo -e "$RED ==============  IN $url Wordpress $COLOFF"
        wp_count=$((wp_count+1))
        echo $url >> wp-sites.txt
    else
        echo -e " $GREEN ===============   IN $url Not Wordpress $COLOFF"
    fi 
    done < $Target

    if [ $wp_count != 0 ]
    then
        echo "Its seems that you have some Wordpress sites"
        echo "Do you want to scan them using Wpscan (y/n)"
        read -r opt

        if [ $opt = "y" ]
        then
            bash wp-check.sh wp-sites.txt
        fi
    fi

    

elif [ $choice = "3" ]
then
    echo "Here Cursor send to cve.sh" # search the CVE keywords in the curled files
    bash cve.sh $Target

elif [ $choice = "4" ]
then
    #mkdir technologies
    while IFS= read -r url; 
    do
    echo -e "$ORANGE Testing For technologies ==> $url $COLOFF"
    if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E "Server:|server:" ; then
        
        if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E "Apache|apache" ; then
            #echo "It has Apache Server " #  >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
             echo $( cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -o "Apache/[0-9]\+\.[0-9]\+\.[0-9]\+" ) >> technologies/$( echo "$url" | awk -F/ '{print $3}')
    
        fi

        if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E "IIS|iis" ; then
            #echo "Its on Microsoft IIS"
                echo $( cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep "Microsoft-IIS/[0-9]\+.[0-9]" ) >> technologies/$( echo "$url" | awk -F/ '{print $3}')
        fi

    fi

    if  cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E "bootstrap|Bootstrap"; then
        echo "It has: Bootstrap" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
    fi
    if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E "Drupal|drupal"; then
        echo "Site with CMS: Drupal" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
    fi
    if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E -i "x-amz-bucket|x-amz-request|x-amz-id|amazons3|x-guploader-uploadid"; then
        echo "AWS Bucket Found " >> technologies/$( echo "$url" | awk -F/ '{print $3}')
    fi
    if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E "Joomla|joomla"; then
        echo "Site with CMS: joomla" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
    fi
    if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E -i "ZEROF"; then
        echo -e "Site uses ZEROF Web Server \nMay be vulnerable use CVE check" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
    fi
    if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E -i "Set-Cookie: wondercms_|Powered by WonderCMS"; then
        echo -e "Site uses Wonder CMS" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
    fi
    if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E -i "rx_sesskey1"; then
        echo -e "Site uses Rhymix CMS" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
    fi



    done < $Target

elif [ $choice = "5" ]
then
    echo "Checking for Sensitive Information Disclosure: "
    echo "Details are saved in technologies folder"
    #mkdir sensitive-data

    while IFS= read -r url; 
    do
        if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E "([-]+BEGIN [^\s]+ PRIVATE KEY[-])" ; then
            echo "This Site contains the SSH private KEY" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
        fi
        if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E "(?i)aws(.{0,20})?(?-i)['\"][0-9a-zA-Z\/+]{40}['\"]" ; then
            echo "This Site contains AWS KEY" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
        fi
        if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" ; then
            echo "Email Found:+ $( cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" )"  >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
        fi  

        if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E -i "Symfony" ; then
            echo "This Site is using Syfmony Profiler" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
            curl -i -k --max-time 15 $url/_profiler/phpinfo > testing.txt
            echo "$url"
            if cat testing.txt | grep -q -E -i "php version"; then
            echo "testing"
                echo "It has some sensitive data visit: $url/_profiler/phpinfo" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
            fi
        fi

        if cat curled_urls/$( echo "$url" | awk -F/ '{print $3}') | grep -q -E -i "xprober" ; then
            echo "This Site is using xprober Services" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
            curl -i -k --max-time 15 $url/xprober.php > testing.txt
            if cat testing.txt | grep -q -E -i "<title>X Prober"; then
                echo "It has some sensitive data visit: $url/xprober.php" >>  technologies/$( echo "$url" | awk -F/ '{print $3}')
            fi
        fi

    done < $Target
elif [ $choice = "6" ]
then
    echo -e "$RED %%%%%%%%%%%%%% STARTING AGRRESSIVE SCAN %%%%%%%%%%%%%%%%%% $COLOFF"
    mkdir aggressive
    echo -e "$BULE ######## Crawling all the given urls #########"
    echo -e "####### It may take time as per given urls ######"
    echo -e "###### Using Wapplyzer for technology scan ###### $COLOFF"
    mkdir aggressive/wappalyzer_results
    cat temp1.txt | while read f; do wappalyzer "${f}" > aggressive/wappalyzer_results/$( echo "$f" | awk -F/ '{print $3}') ; done;
    echo -e "$ORANGE ###### Crwalling all the urls within each urls using Wayback Machine ######$COLOFF"
    cat temp1.txt | waybackurls | grep "=" > waybackurls.txt
    

    # Do wapplyzer scan all the urls

    echo -e "$RED ########## Testing FOR: and only work on waybackurls found ############# $COLOFF"
    echo -e "$BLUE %%%%%% 1. XSS $COLOFF"
    echo -e "$BLUE %%%%%% 2. Open-redirect $COLOFF"


    read -r ch
     

    if [ $ch = '1' ]
    then
        cat waybackurls.txt | egrep -iv ".(jpg|jpeg|js|css|gif|tif|tiff|png|woff|woff2|ico|pdf|svg|txt)" | qsreplace '"><()'| tee combinedfuzz.json && cat combinedfuzz.json | while read host do ; do curl --silent --path-as-is --insecure "$host" | grep -qs "\"><()" && echo -e "$host \033[91m Vullnerable \e[0m \n" || echo -e "$host  \033[92m Not Vulnerable \e[0m \n"; done | tee XSS.txt
    fi

    if [ $ch = '2' ]
    then
        #echo "open redirect has some technical issues"
        cat waybackurls.txt | egrep -iv ".(jpg|jpeg|js|css|gif|tif|tiff|png|woff|woff2|ico|pdf|svg|txt)" | qsreplace 'http://evil.com'| tee combinedfuzz.json && cat combinedfuzz.json | while read host do ; do curl -I --silent --path-as-is --insecure "$host" | grep -i -qs "Location: http://evil.com" && echo -e "$host \033[91m Vullnerable \e[0m \n" || echo -e "$host  \033[92m Not Vulnerable \e[0m \n"; done | tee open_redirect.txt
    fi
    
elif [ $choice = "7" ]
then
    echo -e "$ORANGE ================== Finding Monthly Webtraffic ================== $COLOFF"
    while IFS= read -r url; 
    do
        curl -i --max-time 15 -X POST -d "ckwebsite=$url&submitter=Check" websiteseochecker.com/website-traffic-checker/ > test.txt
        echo "This site has Monthly  $(cat test.txt | grep -i -E "[0-9] visitors</td>" | awk -F'>' '{print $2}' | awk -F'<' '{print $1}'| sed -n 1p) " >> technologies/$( echo "$url" | awk -F/ '{print $3}')
    done < $Target

fi
#(?i)aws(.{0,20})?(?-i)['\"][0-9a-zA-Z\/+]{40}['\"]

