#!/bin/bash

model=sm_ckm
suffix="ppttlpvljj"

cd PROC_SA_CPP_${model}_DECAY_${suffix}
echo Entering PROC_SA_CPP_${model}_DECAY_${suffix}

cd src
echo fixing src
mv HelAmps_${model}.cc HelAmps_${model}_${suffix}.cc
mv HelAmps_${model}.h HelAmps_${model}_${suffix}.h
mv Parameters_${model}.cc Parameters_${model}_${suffix}.cc
mv Parameters_${model}.h Parameters_${model}_${suffix}.h
mkdir tmp
mv read_slha.* tmp/
sed -i s/_${model}/_${model}_${suffix}/g HelAmps_${model}_${suffix}.cc
sed -i s/_${model}/_${model}_${suffix}/g HelAmps_${model}_${suffix}.h
sed -i s/_${model}/_${model}_${suffix}/g Parameters_${model}_${suffix}.cc
sed -i s/_${model}/_${model}_${suffix}/g Parameters_${model}_${suffix}.h
sed -i s,read_slha,../../PROC_SA_CPP_sm_4/src/read_slha,g Makefile
sed -i s/_${model}/_${model}_${suffix}/g Makefile
sed -i s,read_slha,../../PROC_SA_CPP_sm_4/src/read_slha,g Parameters_${model}_${suffix}.h
make clean
make

cd ../SubProcesses
ls -d */ | awk -F "/" '{ print $1 }' > listdir
for dir in `cat listdir`
do
  cd ${dir}
  echo fixing ${dir}
  #cd ../SubProcesses/P0*
  mv CPPProcess.cc CPPProcess_${dir}.cc
  mv CPPProcess.h CPPProcess_${dir}.h
  sed -i s/_${model}/_${model}_${suffix}/g CPPProcess_${dir}.cc
  sed -i s/_${model}/_${model}_${suffix}/g CPPProcess_${dir}.h
  sed -i s/_${model}/_${model}_${suffix}/g Makefile
  sed -i s/CPPProcess/CPPProcess_${dir}/g CPPProcess_${dir}.cc
  sed -i s/CPPProcess/CPPProcess_${dir}/g CPPProcess_${dir}.h
  sed -i s/CPPProcess/CPPProcess_${dir}/g Makefile
  sed -i s/CPPProcess/CPPProcess_${dir}/g check_sa.cpp
  make clean
  make
  cd ..
done

