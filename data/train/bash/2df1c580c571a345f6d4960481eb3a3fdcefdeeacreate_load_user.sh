#!/bin/bash

# install ssh server
sudo apt-get install openssh-server

# delete if load_test existed
sudo userdel load_test
sudo rm -rf /home/load_test/

# create load_test user
sudo useradd load_test -m -p pa5Xr9c1jRlbU -s /bin/bash # pw = projcs
echo "#### Password: projcs, just enter for everything"
sudo su - load_test -c "ssh-keygen -t rsa"

# /tmp folders are not created ...
sudo mkdir /tmp/home/load_test
sudo chown load_test /tmp/home/load_test
sudo chgrp load_test /tmp/home/load_test

# this path is hardcoded in riak...
# if a user EVER started riak this dir belongs to him
sudo sed -i "s:exit 0:mkdir -p /tmp/riak/slide-data/ \nchmod -R 777 /tmp/riak\nexit 0:g" /etc/rc.local
sudo chmod -R 777 /tmp/riak


# change the ulimit
sudo sh -c 'echo "* soft nofile 1000000\n* hard nofile 1000000" >> /etc/security/limits.conf'