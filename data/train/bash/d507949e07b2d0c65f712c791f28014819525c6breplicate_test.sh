#!/bin/bash

ssh='ssh -o StrictHostKeyChecking=no '

echo "##########################################################"
echo "#           HOW GOOD IS THIS SCRIPT? SO GOOD.            #"
echo "##########################################################"

sleep 1

pwd=`pwd`
$ssh mumble-01 "$pwd/master/master"&
sleep 1
$ssh mumble-40 "$pwd/chunk/serv mumble-01"&
$ssh mumble-39 "$pwd/chunk/serv mumble-01"&
$ssh mumble-38 "$pwd/chunk/serv mumble-01"&
sleep 1
client/test mumble-01
sleep 1
$ssh mumble-37 "$pwd/chunk/serv mumble-01"&
sleep 1
$ssh mumble-40 "killall serv"&
sleep 12
./cleanup.sh


