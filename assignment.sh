#!/bin/bash

QUIT=0
LEDLIST=()


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

trigger_menu(){
	QUIT_LED_MENU=0
	while [ $QUIT_LED_MENU -eq 0 ] ; do 
		echo "========================"
		echo "Available events are:"
		event_array=( `cat "/sys/class/leds/$1/trigger" `)
		option=0
		for i in "${event_array[@]}"
		do
			echo "${option}) $i"
			((option++))
		done
		echo "${option}) Quit"
		read CHOICE
	done
	
}

led_menu(){
	QUIT_LED_MENU=0
	while [ $QUIT_LED_MENU -eq 0 ] ; do 
		echo ""
		echo $1
		echo "========================"
		echo "What would you like to do with this LED:"
		echo "1) Turn on"
		echo "2) Turn off"
		echo "3) Associate with a system event"
		echo "4) Associate with a process' performance"
		echo "5) Stop association with a process' performance"
		echo "6) Quit"
		echo "Please enter a number for your choice:"
		read CHOICE
		if [[ $CHOICE = 1 ]] ; then
			echo "1" >/sys/class/leds/$1/brightness
		fi

		if [[ $CHOICE = 2 ]] ; then
			echo "0" >/sys/class/leds/$1/brightness
		fi

		if [[ $CHOICE = 3 ]] ; then
			trigger_menu $1
		fi

		if [[ $CHOICE = 6 ]] ; then
			break
		fi
	done
}

#Program entry point

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
			led_menu ${LEDLIST[$i]}
		fi
	done
done
