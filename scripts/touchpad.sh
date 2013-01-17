#!/bin/bash
#################
# Toggles the enabled/disabled state of Thinkpad's pointing devices.
#
# Written by /rozcietrzewiacz/ (jankeso -at- gmail com)
#
# TODO:
#  - Auto-detect "TPad" and "Joy" parameter values


########## Configuration:
## set these values to relevant device names,
## as recognised by `xinput list`

TPad="Mouse0"
Joy="PS/2 Generic Mouse"

##############################################
##############################################


isEnabled() {
   xinput list-props "$1" | grep -q "Device Enabled.*:.*1"
}

setState() {
   xinput set-prop "$1" "Device Enabled" $2
}

case "$1" in
	tt) # Toggle Touchpad
	  isEnabled "$TPad" && setState "$TPad" 0 || setState "$TPad" 1 
	;;

	tj) # Toggle Joy (TrackPoint)
	  isEnabled "$Joy" && setState "$Joy" 0 || setState "$Joy" 1 
	;;

	ton) # Touchpad ON
	  setState "$TPad" 1
	;;

	jon) # Joy ON
	  setState "$Joy" 1
	;;

	toff) # Touchpad OFF
	  setState "$TPad" 0
	;;

	joff) # Joy OFF
	  setState "$Joy" 0
	;;
	
	circ|*) # CIRCulate Touchpad/Joy states in order:
		# state | Touchpad | Joy (TrackPoint)
		#  1    |    on    |  on
		#  2    |    on    | off
		#  3    |   off    | off
		#  4    |   off    |  on
	  if isEnabled "$TPad"
	  then
	          isEnabled "$Joy" && setState "$Joy" 0 || setState "$TPad" 0 
	  else
	          isEnabled "$Joy" && setState "$TPad" 1 || setState "$Joy" 1 
	  fi
	;;
esac

