#!/bin/bash

echo "deb http://www.rabbitmq.com/debian/ testing main" | sudo tee -a /etc/apt/sources.list
wget https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo apt-key add rabbitmq-signing-key-public.asc

sudo apt-get update

sudo apt-get -y install rabbitmq-server

sudo invoke-rc.d rabbitmq-server start

sudo rabbitmq-plugins enable rabbitmq_management

sudo touch /etc/rabbitmq/rabbitmq.config 
echo "[{rabbit, [{loopback_users, []}]}]." | sudo tee -a /etc/rabbitmq/rabbitmq.config 

sudo invoke-rc.d rabbitmq-server stop

echo "QUUMLSWQZHZBHDGRBNLU" | sudo tee /var/lib/rabbitmq/.erlang.cookie


