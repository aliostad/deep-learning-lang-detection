#!/bin/bash
clear

echo "./bfctl --append INPUT"
./bfctl --append INPUT
echo "----------------------"
echo "./bfctl --append INPUT --proto UDP"
./bfctl --append INPUT --proto UDP
echo "----------------------"
echo "./bfctl --append INPUT --source 192.9.206.14"
./bfctl --append INPUT --source 192.9.206.14
echo "----------------------"
echo "./bfctl --append INPUT --source 192.9.206.:208"
./bfctl --append INPUT --source 192.9.206.:208
echo "----------------------"
echo "./bfctl --append INPUT --source 192.9.206.14/24"
./bfctl --append INPUT --source 192.9.206.14/24
echo "----------------------"
echo "./bfctl --append INPUT --source 192.9.206.14 --destination *"
./bfctl --append INPUT --source 192.9.206.14 --destination *
echo "----------------------"
echo "./bfctl --append INPUT --source 192.9.206.14 --sport 12000 --dport 40000"
./bfctl --append INPUT --source 192.9.206.14 --sport 12000 --dport 40000
echo "----------------------"
echo "./bfctl --append INPUT --source 192.9.206.14 --proto UDP"
./bfctl --append INPUT --source 192.9.206.14 --proto UDP
echo "----------------------"
echo "./bfctl --append INPUT --source 192.9.206.:208 --proto 17"
./bfctl --append INPUT --source 192.9.206.:208 --proto 17
echo "----------------------"
echo "./bfctl --append INPUT --source 192.9.206.14 --proto hkjhjklsdfhgjkh"
./bfctl --append INPUT --source 192.9.206.14 --proto hkjhjklsdfhgjkh
echo "----------------------"
echo "./bfctl --append INPUT --source 192.9.206.14 --proto TCP"
./bfctl --append INPUT --source 192.9.206.14 --proto TCP
echo "----------------------"
echo "./bfctl --append INPUT --source 192.9.206.14 --sport 12000 --dport 40000"
./bfctl --append INPUT --source 192.9.206.14 --sport 12000 --dport 40000








