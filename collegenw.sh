#!/bin/bash

#	Title    @ LOAD BALANCER FOR MULITIPLE N/W LINKS
#   Author   @ Yadu Nand B
#	Email    @ yadudoc1729@gmail.com
#	Date     @ 13/1/10
#   Version  @ 0.6
#
#            			BASIC INSTRUCTIONS
#	Script needs to be run as super-user
#   Configure the modems to have different subnet addresses
#	Use different interfaces for each connection (eth0 , eth1 ...)
#   todo 
# put in a readme
# check the code


# Make sure only root can run the script
if [[ $EUID -ne 0 ]]; 
then
   echo "This script must be run as root" 1>&2
   exit 1
fi


routetable="/etc/iproute2/rt_tables"   	;
config=`pwd`"/config" 


# check if config file is present 
if ! [ -f $config ]
then 
echo "Error(1) : Config file missing " 1>&2 ;
exit 1;
fi ;

# check if the config file has been configured 
a=`head --lines=1 config` ;
b='configured' ;

if ! [ $a = $b ]
then
echo "Error(2) : Config file not configured " 1>&2 ;
exit 2;
fi ;

# retreive config lines from the config file
parse_string=`grep '[0-9][0-9][0-9].' $config` ;

declare -a array
linecount=1;

echo "$parse_string" | 
while read line
do
#	echo $line ;
	
	count=0 ;
	for i in `echo $line`
	do
		#echo $i	 ;
		array[$count]=$i;
		count=$(($count+1)) ;
		#echo $count ;
	done ;
	
	IP=${array[0]};
	GW=${array[1]};
	IF=${array[2]};
	WT=${array[3]};
	PR=${array[4]};
	
	#            correction redirect to routetable 
	echo -e "$linecount\t$PR" >> ./routetable   ;         #$routetable ;
	
#	echo " $IP is the IP "
#	echo " $GW is the gateway "
#	echo " $IF is the interface"
#	echo " $WT id the weight  "
#	echo " $PR is the provider " ;

	linecount=$(($linecount+1));
done ;




#ip route add 192.168.1.0/24 dev $IF src 192.168.1.10 table $PR
#ip route add default via 192.168.1.1 table $PR
#ip rule add from 192.168.1.10 table $PR

#ip route add default scope global nexthop via 192.168.1.1 dev eth1 weight 1 nexthop via 192.168.0.1 dev eth2 weight 4
