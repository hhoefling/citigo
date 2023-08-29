#!/bin/bash
# Verbindungsglied von apache(soc.php) und (skodakonnect)
# Author Heinz Hoefling
# Nov 2021


#
# Parameter einlesen
#
self=$(realpath $0)
base=$(dirname $self)
paramsfile=${self%.*}.conf
logfile=${self%.*}.log
lastrunf=${self%.*}.last
socfile=$(dirname $base)/soc.txt
while read -r line; do
    line=${line//\"/}
    line=${line%%#*}
    if [[ ! -z "$line" ]] ; then 
        #echo "declare:"  "${line/: /=}" ":"
        declare -x "${line/: /=}"
    fi    
done<$paramsfile
#echo "self $self at $base"
#echo $paramsfile
#echo "$username"
#echo "$password"
#echo "optc $optc"
#echo "optmqtt $optmqtt"
#echo "lp $lp"
#echo "mqtthost $mqtthost"
#echo "minold $minold"
#echo "logile: $logfile"
#echo "lastrunf: $lastrunf"

# los gehts
now=`date +%s`
cd $base


date=`date +%x_%X`
para=${1:-timer}
echo "$date $0 para=$para" >>$logfile

  # trim logfile
if [ -f "$logfile" ] ; then
    # Tructate logfile if bigger than 120000 bytes
    logfilesize=$(stat --format=%s "$logfile")
    echo "$date $logfilesize bytes" >>$logfile
    if  (( $logfilesize > 120000 )) ; then
        lines=$(wc -l <"$logfile" )
        lines=$(( $lines / 2 ))   # truncate to half
        echo "$(tail -$lines $logfile)" > $logfile
        echo "$date truncate $lines" >>$logfile
        sudo chmod a+rw $logfile
    fi
else
    echo "$date init" >$logfile
    chmod a+rw $logfile
fi


# check Lastrun
if [ -f "$lastrunf" ] ; then
	lastrun=$(<$lastrunf)
else	
	lastrun=0
	echo "0" >$lastrunf
	chmod a+rw $lastrunf
fi
# values are connect/disconnect/startcharge/stopcharge and timer
case $para in
    connect | disconnect | startcharge | stopcharge | reload)
        # uebersteure lastrun um sofotige ausf?hrung zu erwingen
        #lastrun=0
        minold=30   # mindestes 30 Sekunden abstand
        ;;
esac   
diff="$((now-lastrun))"




if (( $diff >= $minold )) ; then
  echo $now >$lastrunf  
  chmod a+rw $lastrunf

  # check if any process from last loop are allready active
  pid=$(pgrep -f 'python3 ./callskoda.py')
  cnt=$?
  #echo $cnt $pid
  if (( $cnt == 0 )) ; then
     echo "killing old script $pid" >>$logfile 
     pkill -f 'python3 ./callskoda.py'
  fi
  #
  # Asnycron aufrufen
  #
  echo "$date call it now" >>$logfile
  python3 ./callskoda.py -d 2 -l $lp -u $username -p $password $optc -m $mqtthost $optmqtt -s $socfile >>$logfile 2>&1 &

else 
  wait="$((minold-diff))"
  echo "$date to fast. wait $wait secounds" >>$logfile
fi

# Nehme letzen bekannten SOC mit zur?ck 
cat $(dirname $base)/soc.txt
exit 0

