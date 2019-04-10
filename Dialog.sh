#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="System infomation"
TITLE="MENU"
MENU="System settings:"

DIALOG_CANCEL=1
DIALOG_ESC=255

display_result() {
	dialog --title "$1" \
		--no-collapse \
		--msgbox "$result" 0 0
}
OPTIONS=(1 "Live"
         2 "Dev"
         3 "Test")

while true; do
 exec 3>&1
 CHOICE=$(dialog --clear \
	        --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
		$HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 1>&3)

#clear
 exit_status=$?
 exec 3>&-
 case $exit_status in
	$DIALOG_CANCEL)
		clear
		echo "Program terminated"
		exit
		;;
	$DIALOG_ESC)
		clear
		echo "Program aborted" >&2
		exit 1
		;;
 esac

 case $CHOICE in
	0)
		clear
		echo "Program terminated"
		;;
	1)
	     	HEIGHT=15
            	WIDTH=40
            	CHOICE_HEIGHT=4
		TITLE="Live"
		MENU="Select:"
	    	option1=(1 "Configuration"
		     	 2 "Show Interface"
		      	 3 "option 3"
		     	 4 "option 4")

	    	s1=$(dialog    	--title "$TITLE" \
			 	--menu "$MENU" \
				$HEIGHT $WIDTH $CHOICE_HEIGHT \
				"${option1[@]}" \
				2>&1 >/dev/tty)
		case $s1 in
			1)
				interface=$(ifconfig -a | grep ens | awk '{print $1 " "$4 $5}')
				select=$(dialog --title "Enthernet Interfaces" \
					--menu "Select: " 0 0 0 \
				 	${interface} 3>&1 1>&2 2>&3)

				address=""
				netmask=""
				network=""
				gateway=""
				broadcast=""
				#dialog --inputbox "Enter your IP: " 10 30 192.168.1.x
				exec 3>&1
				VALUES=$(dialog --ok-label "Submit" \
						  --backtitle "Configuration" \
						  --title "Provide the values for static IP configuration" \
						  --form "$select" \
							0 50 0 \
				"Address:"    1 1	"$address" 	1 11 40 15 \
				"Netmask:"    2 1	"$netmask"  	2 11 40 15 \
				"Network:"    3 1	"$network"  	3 11 40 15 \
				"Gateway:"    4 1	"$gateway" 	4 11 40 15 \
				"Broadcast:"  5 1	"$broadcast"	5 11 41 15 \
				2>&1 1>&3)
				exec 3>&-

				echo "$VALUES" >> /home/huangvinh/output.txt
				;;
			2)
				result=$(ifconfig -a)
				display_result "Interfaces"
		esac
           	;;
	2)
	   #while true; do
		HEIGHT=15
	    	WIDTH=40
	    	CHOICE_HEIGHT=4
	        TITLE="Dev"
	    	MENU="Select:"
	    	option2=(1 "install program"
		 	 2 "option 2"
		    	 3 "option 3")
	    	s2=$(dialog --clear \
			   --title "$TITLE" \
			   --menu "$MENU" \
			   $HEIGHT $WIDTH $CHOICE_HEIGHT \
			   "${option2[@]}" \
			   2>&1 >/dev/tty)
		clear
	    	case $s2 in
	    		1)
	 	 	 dialog --title "My Question" --yesno "Do you want install this program?" 10 40;;
			2)
		 	 #dialog --title "My Message" --msgbox "no information" 10 40;;
			 result=$(echo "Hostname: $HOSTNAME"; uptime)
			 display_result "System Information"
	    	esac
	        ;;
	3)
		result=$(df -h)
            	display_result "Disk Space"
           	 ;;
 esac
done
