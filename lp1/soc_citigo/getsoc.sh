#!/bin/bash

# Params einlesen
paramsfile=${0%.*}.conf
while read -r line; do
    line=${line//\"/}
    line=${line%%#*}
    if [[ ! -z "$line" ]] ; then 
        #echo "declare:"  "${line/: /=}" ":"
        declare -x "${line/: /=}"
    fi    
done<$paramsfile

#echo $paramsfile
#echo "$username"
#echo "$password"
#echo "optc $optc"
#echo "optmqtt $optmqtt"
#echo "lp $lp"
#echo "mqtthost $mqtthost"



cd ./soc_citigo
python3 callskoda.py -d 1 -l $lp -u $username -p $password $optc -m $mqtthost $optmqtt 

