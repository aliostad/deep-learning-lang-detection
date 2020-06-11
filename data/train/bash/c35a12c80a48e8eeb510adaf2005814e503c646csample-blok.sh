#!/usr/bin/bash

for sample in 4 7 16 34 74 160 346 746 1609
do
for try in 1 2 3
do
echo +++++++++ try num= "$try" >> samples-blok-a
./blokice "pow(x*x+y*y+z*z,1.5)" -3 3 $sample "-1*pow(9-x*x,0.5)" "pow(9-x*x,0.5)" $sample "-1*pow(9-x*x-y*y,0.5)" "pow(9-x*x-y*y,0.5)" $sample 24 hostfiles/host_cluster >> samples-blok-a
done
done

for sample in 4 7 16 34 74 160 346 746 1609
do
for try in 1 2 3
do
echo +++++++++ try num= "$try" >> samples-blok-b
./blokice "y/(y*y+z*z)" 1 2 $sample x 3 $sample 0 "y*pow(3,0.5)" $sample 24 hostfiles/host_cluster >> samples-blok-b
done
done

for sample in 4 7 16 34 74 160 346 746 1609
do
for try in 1 2 3
do
echo +++++++++ try num= "$try" >> samples-blok-c
./blokice "pow(x*x+y*y,0.5)" 0 3 $sample 0 "pow(9-x*x,0.5)" $sample 0 2 $sample 24 hostfiles/host_cluster >> samples-blok-c
done
done

for sample in 4 7 16 34 74 160 346 746 1609
do
for try in 1 2 3 
do
echo +++++++++ try num= "$try" >> samples-blok-d
./blokice "z*pow(4-x*x-y*y,0.5)" 0 2 $sample 0 "pow(4-x*x,0.5)" $sample 0 "pow(4-x*x-y*y,0.5)" $sample 24  hostfiles/host_cluster >> samples-blok-d
done
done
