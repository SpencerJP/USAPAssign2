#!/bin/bash
print_menu(){
	ledlist=("$@")
	echo ""
	echo "Led Configurator"
	echo "========================"
	echo "Please select a led to configure:"
	option=0
	for i in "${ledlist[@]}";
	do
		echo "${option}) $i"
		((option++))
	done
	echo "${option}) Quit"
	echo "Please enter a number for your choice:"
	

}


#Program entry point
QUIT=0
LEDLIST=()

#get the dir
for dir in /sys/class/leds/*/; do
  		a=(${dir#"/sys/class/leds/"}) #remove directory prefix
  		a=(${a%"/"}) #remove directory suffix
  		LEDLIST+=($a)
	done


while [ $QUIT -eq 0 ] ; do 
	print_menu "${LEDLIST[@]}"
	
	read CHOICE #get user input for menu

	for i in ${!LEDLIST[@]}; do
		if [[ $i = $CHOICE ]] ; then
			echo ${LEDLIST[$i]}
		fi
	done
done
