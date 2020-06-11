#!/bin/sh

make all

### mkdir
#for i in 0 0.5 1; do			  # i: lambda (tradeoff)
for i in 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1; do
  for j in 0.0125 0.025; do	  # j: delta (variance)
#  for j in 0.0125 0.025 0.05 0.1 0.2 0.4 0.8 1.6; do	  # j: delta (variance)
    if [ ! -d "./all_save/$i/$j" ]; then
      mkdir -p ./all_save/"$i"/"$j"
    fi
  done
done

#for j in 0.0125 0.025 0.05 0.1 0.2 0.4 0.8 1.6; do	  # j: delta (variance)
#  if [ ! -d "./all_save/em/$j" ]; then 
#    mkdir -p ./all_save/em/"$j"
#  fi
#done

### run
for i in 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1; do
  for j in 0.0125 0.025; do	  # j: delta (variance)
#  for j in 0.0125 0.025 0.05 0.1 0.2 0.4 0.8 1.6; do	  # j: delta (variance)
    nohup ./a.out 1 "$j" "$i" ./all_save/"$i"/"$j"/ > ./log/"$i"_"$j".txt &
  done
done

# (em)
#for j in 0.0125 0.025 0.05 0.1 0.2 0.4 0.8 1.6; do	  # j: delta (variance)
#  nohup ./a.out 2 "$j" "$i" ./all_save/em/"$j"/ > ./log/em_"$j".txt &
#done

