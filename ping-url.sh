#!/bin/bash
# Program name: ping-url.sh
CONF="/usr/local/etc/urls"
LOG="/var/run"
LOG_FILE="/var/log/ping-url.log"

LOG_MAIL="/var/run/log_mail"

rm -f $LOG_MAIL

NOW=$(date +%s)
NOW_STRING=$(date +"%Y-%m-%d %T")
echo $NOW_STRING

function send_message() {
	curl -X POST --data "payload={\"channel\": \"#log\", \"username\": \"vm90-ping-url\", \"text\": \"$1\", \"icon_emoji\": \":$2:\"}" https://hooks.slack.com/services/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	
}

cat $CONF | while read url
do
  	file_name=$(sed 's/[\/:.]/-/g' <<< $url)

        http_code=`curl -sL --max-time 5 "$url" -w "%{http_code}" -o /dev/null`

        if [ "$http_code" != "200" ]; then
                printf "%-65s %5s %-30s \n" $url $http_code "*** error *** "

                if [ ! -f "$LOG/$file_name" ]; then
                        touch "$LOG/$file_name"
                else
                        FILE_DATE=$(stat -c%Y "$LOG/$file_name")
                        ERROR_TIME=$((($NOW - $FILE_DATE)/60))

                        if [ $ERROR_TIME -gt 4 ] && [ $ERROR_TIME -lt 6 ]; then
                                echo "$NOW_STRING $url $http_code ---- Parado ha $ERROR_TIME minuto(s) " >> $LOG_MAIL
				send_message "$NOW_STRING $url $http_code ---- Parado ha $ERROR_TIME minuto(s) " "warning"
                        fi 
                fi
        else
            	printf "%-65s %5s %-30s \n" $url $http_code " "

                if [ -f "$LOG/$file_name" ]; then
                        FILE_DATE=$(stat -c%Y "$LOG/$file_name")
                        ERROR_TIME=$((($NOW - $FILE_DATE)/60))

                        rm -f "$LOG/$file_name"
                        if [ $ERROR_TIME -gt 4 ]; then
                                echo "$NOW_STRING $url $http_code ---- Ficou parado por $ERROR_TIME minuto(s)" >> $LOG_MAIL
				send_message "$NOW_STRING $url $http_code ---- Ficou parado por $ERROR_TIME minuto(s)" "white_check_mark"
                        fi;
                fi
        fi
done

if [ -f "$LOG_MAIL" ]; then

        if [ ! -f "$LOG_FILE" ]; then
                touch $LOG_FILE
        fi
	cat $LOG_MAIL >> $LOG_FILE
fi
