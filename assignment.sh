#!/bin/bash

QUIT=0 #first quit variable
LEDLIST=()


# this function prints the main menu.
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

#this function prints the menu for editing the triggers.
trigger_menu(){
	QUIT_LED_MENU=0 #exit variable
	while [ $QUIT_LED_MENU -eq 0 ] ; do 
		echo "========================"
		echo "Available events are (enter to scroll, get to bottom to begin input):"
		event_array=( `cat "/sys/class/leds/$1/trigger" `)
		string_to_pipe="";
		option=0
		for i in "${event_array[@]}"
		do
			string_to_pipe="${string_to_pipe} ${option}) $i\n"
			((option++))
		done
		string_to_pipe="${string_to_pipe} ${option}) Quit"
		printf "${string_to_pipe}" | more #pipe into more for pagination

		read CHOICE
		option=0
		for i in "${event_array[@]}"
		do
			if [[ $option = $CHOICE ]] ; then
				#using tee to get around permissions bug, even with sudo it seems to have an issue
				echo $i | sudo tee /sys/class/leds/$1/trigger >/dev/null
				echo "${1} set to respond to event ${i}" 
			fi
			((option++))
		done
		quitnum=${#event_array[@]}
		if [[ $CHOICE = $quitnum ]] ; then
			break
		fi
		
	done
	
}

#menu for each LED
led_menu(){
	QUIT_LED_MENU=0 #exit variable
	while [ $QUIT_LED_MENU -eq 0 ] ; do 
		echo ""
		echo $1 #print name of led
		echo "========================"
		echo "What would you like to do with this LED:"
		echo "1) Turn on"
		echo "2) Turn off"
		echo "3) Associate with a system event"
		echo "4) Quit"
		echo "Please enter a number for your choice:"
		read CHOICE
		if [[ $CHOICE = 1 ]] ; then
			echo "1" >/sys/class/leds/$1/brightness #turn light on
		fi

		if [[ $CHOICE = 2 ]] ; then
			echo "0" >/sys/class/leds/$1/brightness #turn it off
		fi

		if [[ $CHOICE = 3 ]] ; then
			trigger_menu $1 #enter trigger menu
			CHOICE=-1
		fi

		if [[ $CHOICE = 4 ]] ; then
			QUIT_LED_MENU=1
		fi
	done
}

#Program entry point

#get all the LED dirs in /sys/class/leds/

for dir in /sys/class/leds/*/; do
  		a=(${dir#"/sys/class/leds/"}) #remove directory prefix
  		a=(${a%"/"}) #remove directory suffix
  		LEDLIST+=($a) #add to LEDLIST array
	done


#main program loop
while [ $QUIT -eq 0 ] ; do
	print_menu "${LEDLIST[@]}"
	
	read CHOICE #get user input for menu

	for i in ${!LEDLIST[@]}; do
		if [[ $i = $CHOICE ]] ; then
			led_menu ${LEDLIST[$i]}
			CHOICE=-1
		fi
	done

	quitnum=${#LEDLIST[@]}
	if [[ $CHOICE = $quitnum ]] ; then
		QUIT=1
	fi
done
