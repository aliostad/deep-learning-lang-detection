#!/bin/bash

# Description: the use of kill and kill

# <1> kill: terminate a process by pid

# Signal is one of inter-process connection mechanism. We can use specified signal to terminate process. Every signal is equal to one integer. 

# 1. list all available signal
kill -l

# 2. terminate one process
#    $ kill -s signal PID
#  SIGHUP 1 -- hangup detection
#  SIGINT 2 -- CTRL+C
#  SIGKILL 9 -- terminate process force
#  SIGTERM 15 -- terminate process default
#  SIGTSTP 20 -- CTRL+Z
kill -9 pid
# is equal to 
kill -s SIGKILL pid


# <2> killall: terminate a process by name

# 1. killall process_name

killall less

# 2. killall -u USERNAME -s SIGNAL process_name

