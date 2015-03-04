#!/bin/bash
## script to monitor network and trace the last reachable hop in case of disconnection
## Author : Srinivas Gannavarapu
## Note: using ping to identify network disconnections might not be a reliable. But this script will help
##      in basic monitoring. User can select how many number of hops to trace in case of a disconnection.
##
## Usage: checkconnection.sh <ip/web address> [hops] > logfle
## use control + c to stop the script ; sometimes you might have to use kill to stop the script
##
##


## check for usage 
if [ -n "$1" ]
then
	echo Invalid usage
	echo "Usage: checkconnection.sh <ip or website> [hops]"
fi
## set number of hops to trace in case of a disconnection 
## default is 10
hops=10
if [ -n "$2" ]
then
	hops=$2
fi

echo Monitoring network between you and $1 starts at `date`
status=1
pingAvailable=`which ping`
tracepathAvailable=`which tracepath`
if [ -f $pingAvailable ]
then
    echo
else    
    echo Cannot proceed as ping is NOT available in this machine
    exit
fi
while true 
do
	ping -c1 $1 &> /dev/null
	if [ $? -ne 0 ]
	then 
		if [ $status -eq 1 ]
                then
                    echo Disconnected `date`
                    if [ -f $tracepathAvailable ]
                    then
                        echo Tracing for $hops hops 
                        tracepath -n -l 29 -m $hops $1
                    fi
                fi
		status=0
	else
		if [ $status -eq 0 ]
                then
                    echo Connected `date`
                fi		
		status=1
	fi
done
