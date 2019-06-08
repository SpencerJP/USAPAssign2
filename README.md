README for ledconfigurator

INTRODUCTION
------------

This program allows you to switch on and off the hardware leds listed in the /sys/class/leds/ directory, 
and assign system events/triggers to each light, satisfying tasks 2 - 5 in the second USAP assignment.


HOW TO USE
----------

To use, run the script with elevated permissions (e.g. "sudo ./ledconfigurator.sh"). A menu will appear, listing the different leds, found as directories
within the /sys/class/leds directory. To select a led, input the number of that led (or the number to quit). After selecting a led, a  new menu will appear with 4 options,
1) Turn on -- turns the led on (does nothing if the led is already on)
2) Turn off -- turns the led off (does nothing if the led is already off)
3) Associate with a system event -- opens the system event menu. This allows you to change which event triggers the light, by inputting the number next to the light.
 Selecting "none" will disable the event for this light.
4) Quit  -- returns you to the first menu.

REQUIREMENTS
------------

Nothing is required for this script to be run, other than making sure you run it with elevated permissions (e.g. "sudo ./ledconfigurator.sh")

