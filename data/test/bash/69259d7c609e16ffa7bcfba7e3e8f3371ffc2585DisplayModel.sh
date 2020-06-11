#!/bin/bash
## /**
## * @file DisplayModel.sh
## * @brief Display Created Model
## * @author fahdi@gm2001.net
## * @date April 2013 [update]
## */

#input
#define model dimension
model_name=model01
nx=100
dx=10
nz=300
dz=10

#housekeeping
model="../model/${model_name}"
nrcv=($(wc -l ${model}_receiver_list.txt | awk '{print $1}'))

#display
ximage < ${model}_vel_P.dat n1=$nz d1=$dz n2=$nx d2=$dx legend=1 \
	cmap=hsv2 npair=$nrcv,1 curve=${model}_receiver_list.txt,${model}_source_list.txt title="${model} Vp"&
ximage < ${model}_vel_S.dat n1=$nz d1=$dz n2=$nx d2=$dx legend=1 \
	cmap=hsv2 npair=$nrcv,1 curve=${model}_receiver_list.txt,${model}_source_list.txt title="${model} Vs"&
ximage < ${model}_density.dat n1=$nz d1=$dz n2=$nx d2=$dx legend=1 \
	cmap=hsv2 npair=$nrcv,1 curve=${model}_receiver_list.txt,${model}_source_list.txt title="${model} Density"&
