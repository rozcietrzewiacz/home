#!/bin/bash
#################
# Toggles the enabled/disabled state of Thinkpad's pointing devices.
#
# Written by /rozcietrzewiacz/ (jankeso -at- gmail com)
#

TPad='xinput --list-props Mouse1 | grep "Device Enabled.*:.*1" >/dev/null'
Joy='xinput --list-props Mouse2 | grep "Device Enabled.*:.*1" >/dev/null'
TPad_on='xinput --set-prop Mouse1 "Device Enabled" 1'
Joy_on='xinput --set-prop Mouse2 "Device Enabled" 1'
TPad_off='xinput --set-prop Mouse1 "Device Enabled" 0'
Joy_off='xinput --set-prop Mouse2 "Device Enabled" 0'

case "$1" in
	tt) # Toggle Touchpad
	  eval $TPad && eval $TPad_off  || eval $TPad_on 
	;;

	tj) # Toggle Joy (TrackPoint)
	  eval $Joy  && eval $Joy_off || eval $Joy_on
	;;

	ton) # Touchpad ON
	  eval $TPad_on
	;;

	jon) # Joy ON
	  eval $Joy_on
	;;

	toff) # Touchpad OFF
	  eval $TPad_off
	;;

	joff) # Joy OFF
	  eval $Joy_off
	;;
	
	circ|*) # CIRCulate Touchpad/Joy states in order:
		# state | Touchpad | Joy (TrackPoint)
		#  1    |    on    |  on
		#  2    |    on    | off
		#  3    |   off    | off
		#  4    |   off    |  on
	  if eval $TPad
	  then
		  eval $Joy && eval $Joy_off || eval $TPad_off
	  else
		  eval $Joy && eval $TPad_on || eval $Joy_on
	  fi
	;;
esac
