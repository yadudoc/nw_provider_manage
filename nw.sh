#!/bin/bash

# set default location of config file to present dir 
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

#echo "$parse_string" ;

declare -a array
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
	
#	echo " $IP is the IP "
#	echo " $GW is the gateway "
#	echo " $IF is the interface"
#	echo " $WT id the weight  "
#	echo " $PR is the provider " ;
done ;


