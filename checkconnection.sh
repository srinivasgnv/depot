#!/bin/bash
## script to monitor network and trace the last reachable hop in case of disconnection
## Author : Srinivas Gannavarapu
## Note: using ping to identify network disconnections might not be a reliable. But this script will help
##      in basic monitoring
##
## Usage: checkconnection.sh <ip/web address> > logfle
## use control + c to stop the script ; sometimes you might have to use kill to stop the script
##
##

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
                        echo Tracing for 10 hops 
                        tracepath -n -l 29 -m 10 $1
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
