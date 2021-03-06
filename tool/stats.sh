#!/bin/bash

source "/root/mrminer/lib/settings.txt"
source "/root/mrminer/lib/functions.sh"

MINER="claymore"
STATS='{}'

## MINER HASHRATE
if [[ $MINER == "claymore" ]]; then
	CLAYMORE=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}' | nc localhost 3333`
	HASH=`echo "$CLAYMORE" | jq -r .result[2] | cut -d ';' -f 1`
	GPU_HASH=`echo "$CLAYMORE" | jq -r .result[3]`
	HASH_DUAL=`echo "$CLAYMORE" | jq -r .result[4] | cut -d ';' -f 1`
	GPU_HASH_DUAL=`echo "$CLAYMORE" | jq -r .result[5]`
	HASH_UNIT="MH"
fi

STATS=`echo "$STATS" | jq ".total_hash=\"$HASH\""`
STATS=`echo "$STATS" | jq ".total_hash_dual=\"$HASH_DUAL\""`
STATS=`echo "$STATS" | jq ".gpu_hash=\"$GPU_HASH\""`
STATS=`echo "$STATS" | jq ".gpu_hash_dual=\"$GPU_HASH_DUAL\""`
STATS=`echo "$STATS" | jq ".hash_unit=\"$HASH_UNIT\""`

## GPU STATS
x=0;
while [ $x -le 14 ]; do
    if [ -e "/sys/class/drm/card$x/device/pp_table" ]; then
    	STATS=`echo "$STATS" | jq ".core += \"$(cat /sys/class/drm/card$x/device/pp_dpm_sclk  | grep "*" | awk '{print $2}' | tr -d 'Mhz');\""`
    	STATS=`echo "$STATS" | jq ".mem += \"$(cat /sys/class/drm/card$x/device/pp_dpm_mclk  | grep "*" | awk '{print $2}' | tr -d 'Mhz');\""`
    	STATS=`echo "$STATS" | jq ".temp += \"$(sudo /root/mrminer/tool/ohgodatool --show-temp -i $x | tr -d 'C');\""`
    	STATS=`echo "$STATS" | jq ".fan += \"$(sudo /root/mrminer/tool/ohgodatool --show-fanspeed -i $x | tr -d '%');\""`
        STATS=`echo "$STATS" | jq ".watt += \"$(sudo /opt/rocm/bin/rocm-smi -P -d $x | grep "Power:" | cut -b 32- | tr -d ' W');\""`
    fi
    x=$[x + 1]
done


echo $STATS
