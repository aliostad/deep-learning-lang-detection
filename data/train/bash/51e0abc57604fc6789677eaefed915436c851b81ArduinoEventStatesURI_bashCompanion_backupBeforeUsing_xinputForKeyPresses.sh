#!/bin/bash

# quick & ditry test to see if "We/I can make this particular bear dance [again]" ;D
#
# Nb: digg the following for maybe a way to know wich keys are currently pressed ( aka more than one at a time -> better to update our event states URI ;p )
# http://superuser.com/questions/248517/show-keys-pressed-in-linux
# also
# http://stackoverflow.com/questions/9731281/bash-script-listen-for-key-press-to-move-on
# &
# http://stackoverflow.com/questions/23462221/bash-read-input-only-once-and-do-not-continue-reading-until-key-is-released


# --------------------------------------------
# Source used aliases & fcns
source ~/.bash_stephaneag_functions
source ~/.bash_stephaneag_aliases

# --------------------------------------------
# trap ctrl-c and call ctrl_c() ( useful for cleanup )
trap ctrl_c INT

ctrl_c() {
  #echo
  #echo "** Trapped CTRL-C ! **"
  # do some cleanup
  cleanup

  # fix to restore the prompt ( ' having invisible commands typing, because "read" disbles local echo ( .. ) )
  #reset - as efficient but has side effects :/
  stty "$console_bckp"
  
  exit 0
}

#--------------------------------------------
# cleanup
cleanup(){
  # TODO: delete file descriptor used for the Arduino serial conn
  echo -en "\rcleanup done!"
}


#--------------------------------------------
# Arduino event states URI chunks
read_chunk_C1=0   # chunk #1  ( ltrig )
read_chunk_H1=0   # chunk #2  ( rtrig )
read_chunk_C2=128 # chunk #3  ( ljoyY )      / resting voltage 2.3V on 4.6V 
read_chunk_H2=128 # chunk #4  ( ljoyX )      / resting voltage 2.3V on 4.6V
read_chunk_C3=1   # chunk #5  ( ljoyS )      / HIGH by default ( 4.4V on 4.6V )
read_chunk_H3=128 # chunk #6  ( rjoyY )      / resting voltage 2.3V on 4.6V 
read_chunk_C4=128 # chunk #7  ( rjoyX )      / resting voltage 2.3V on 4.6V
read_chunk_H4=1   # chunk #8  ( rjoyS )      / HIGH by default ( 4.4V on 4.6V )
read_chunk_C5=1   # chunk #9  ( btnBack )    / HIGH by default ( 4.4V on 4.6V )
read_chunk_H5=1   # chunk #10 ( btnStart )   / HIGH by default ( 4.4V on 4.6V )
read_chunk_C6=0   # chunk #11 ( btnY )
read_chunk_H6=0   # chunk #12 ( btnA )
read_chunk_C7=0   # chunk #13 ( btnX )
read_chunk_H7=0   # chunk #14 ( btnB )
read_chunk_C8=1   # chunk #15 ( keypadUp )   / HIGH by default ( 4.4V on 4.6V )
read_chunk_H8=1   # chunk #16 ( keypadDown ) / HIGH by default ( 4.4V on 4.6V )

#--------------------------------------------
# No need to specify control defaults ( & neither keyup events ) as they're automatically reset at the beginning of each loop on the uC side

#--------------------------------------------
# Analog controls defaults & range to be used in arithmetical expressions responsible for smoothing - not currently used
# chunk #1  ( ltrig )
ltrig_min=0
ltrig_max=255
curr_ltrig=0
# chunk #2  ( rtrig )
ltrig_min=0
ltrig_max=255
curr_ltrig=0

# chunk #3  ( ljoyY )      / resting voltage 2.3V on 4.6V
ljoyY_min=0
ljoyY_max=255
curr_ljoyY=128
# chunk #4  ( ljoyX )      / resting voltage 2.3V on 4.6V
ljoyY_min=0
ljoyY_max=255
curr_ljoyY=128
# chunk #6  ( rjoyY )      / resting voltage 2.3V on 4.6V
ljoyY_min=0
ljoyY_max=255
curr_ljoyY=128
# chunk #7  ( rjoyX )      / resting voltage 2.3V on 4.6V
ljoyY_min=0
ljoyY_max=255
curr_ljoyY=128



#--------------------------------------------
# Simple arithmetical expressions & stuff ( maybe to be used later with AAF for a character control on a map ? ;P )
x=0
x_max=100 # screen width
y=0
y_max=50 # screen height
curr_x=50
curr_y=25

zoom=0
zoom_max=100
curr_zoom=50



#--------------------------------------------
# Functions using arithmetical expressions to update curr_x & curr_y, and also curr_zoom ;)
upKeyPress(){
  if (( "$curr_x" >= "$x_max" )); then
    curr_x="$x"
  else
    let curr_x++
  fi
}
downKeyPress(){
  if (( "$curr_x" <= "$x" )); then
    curr_x="$x_max"
  else
    let curr_x--
  fi
}
leftKeyPress(){
  if (( "$curr_y" <= "$y" )); then
    curr_y="$y_max"
  else
    let curr_y--
  fi
}
rightKeyPress(){
  if (( "$curr_y" >= "$y_max" )); then
    curr_y="$y"
  else
    let curr_y++
  fi
}


#--------------------------------------------
# Event states URI logging
# the following is the default uC callback received from serial
eventStatesURI="ltrig:0/rtrig:0/ljoyY:128/ljoyX:128/ljoyS:1/rjoyY:128/rjoyX:128/rjoyS:1/back:1/start:1/Y:0/A:0/X:0/B:0/Up:1/Up:1"
logEventStates(){
  echo -en "\rARDUINO CALLBACK: [ $eventStatesURI ]"
}


#--------------------------------------------
# Hacky handling of arrow keys ( using "A"(up), "B"(down), "D"(left), "C"(right))
hackyKeyboardHandle(){
  # fix to prevent previous lines from appearing ( contains more spaces than the most wide stuff echoed, nb: better ? -> cursor ( AAF ) )
  echo -en "\r                                                                                                                                                                   "
  case $key in
  x) ltrigPress ;; # LTRIG
  n) rtrigPress ;; # RTRIG
  f) ljoyUp ;; # LJOY UP
  v) ljoyDown ;; # LJOY DOWN
  d) ljoyLeft ;; # LJOY LEFT
  g) ljoyRight ;; # LJOY RIGHT
  r) ljoySelect ;; # LJOY SELECT
  A) btnYPress ;; # BTN Y
  B) btnAPress ;; # BTN A
  D) btnXPress ;; # BTN X
  C) btnBPress ;; # BTN B
  u) btnBackPress ;; # BTN BACK
  i) btnStartPress ;; # BTN START
  o) keypadUpPress ;; # KEYPAD UP
  p) keypadUpPress ;; # KEYPAD DOWN
  *) logInfos $key # helpful for debugging
  esac
  
  # log either the default infos or actual infos updated after getting a serial callback from the Arduino
  logEventStates
  
}

#--------------------------------------------
#Init & args debug

# TODO: init the arduino serial conn & hackety trick

# fix to restore the prompt ( see code in trap Ctrl-C )
console_bckp=$(stty -g)


#--------------------------------------------
# Automation -> if we're passed an automation script, we should source it instead of runnig an infinite loop to get the user's controls
# the so-colled automation script is 
automation_path_arg="$1"
echo "AUTOMATION PATH PASSED AS ARG: $automation_path_arg"


#--------------------------------------------
# Infinite loop
while true
do
  read -s -n1 key # Read 1 characters.
  #echo -en "\rREAD: [" $key "]"
  hackyKeyboardHandle
done
