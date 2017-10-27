#!/bin/bash
source "/root/mrminer/lib/functions.sh"

DATA=`curl -k -s -d api="$API" -d email="$EMAIL" $URL/getcommand`
RESPONSE=`echo "$DATA" | jq -r .response`

# Execute Command
if [ -n "$RESPONSE" ]
then
	if [ "$RESPONSE" == "reboot" ]; then

    	sudo bash /root/mrminer/tool/reboot.sh

	elif [ "$RESPONSE" == "restart" ]; then

		killall xterm -9
		killall screen -9
		clear
		screen -dm -S miner bash -c "/root/mrminer/boot/configure.sh" &

	elif [ "$RESPONSE" == "settings" ]; then

		if config; then
			sudo /root/mrminer/tool/overclock.sh > /dev/null 2>&1 &
			sudo /root/mrminer/tool/fanspeed.sh &			
		fi		


	elif [ "$RESPONSE" == "update" ]; then

	    screen -X -S miner quit
	    sleep 1
	    screen -dm -S miner bash -c "bash <(curl -k -s https://mrminer.co/update/update.sh)"

	fi
fi


settings