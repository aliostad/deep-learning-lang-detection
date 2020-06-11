#!/usr/bin/bash

for sample in 1000 100000 10000000 1000000000 100000000000
do
for try in 1 2 3 4 5 6 7 8
do
echo +++++++++ try num= "$try" >> samples-a-$sample
./montice "pow(x*x+y*y+z*z,1.5)" -3 3 "-1*pow(9-x*x,0.5)" "pow(9-x*x,0.5)" "-1*pow(9-x*x-y*y,0.5)" "pow(9-x*x-y*y,0.5)" 1000000000 $sample host_cluster >> samples-a-$sample
done
done

for sample in 1000 100000 10000000 1000000000 100000000000
do
for try in 1 2 3 4 5 6 7 8
do
echo +++++++++ try num= "$try" >> samples-b-$sample
./montice "y/(y*y+z*z)" 1 2 3 x 0 "y*pow(3,0.5)" $sample 24 host_cluster >> samples-b-$sample
done
done

for sample in 1000 100000 10000000 1000000000 100000000000
do
for try in 1 2 3 4 5 6 7 8
do
echo +++++++++ try num= "$try" >> samples-c-$sample
./montice "pow(x*x+y*y,0.5)" 0 3 0 "pow(9-x*x,0.5)" 0 2 $sample 24 host_cluster >> samples-c-$sample
done
done

for sample in 1000 100000 10000000 1000000000 100000000000
do
for try in 1 2 3 4 5 6 7 8
do
echo +++++++++ try num= "$try" >> samples-d-$sample
./montice "z*pow(4-x*x-y*y,0.5)" 0 2 0 "pow(4-x*x,0.5)" 0 "pow(4-x*x-y*y,0.5)" $sample 24  host_cluster >> samples-d-$sample
done
done




