#!/bin/bash
###for i in `seq -w 1 1 16`; do echo -n "$i"; more cluster_$i.log | awk '{if(NF==15 && $1 == 1) print $0}'; echo -n " $i"; more cluster_$i.log | awk '{if(NF==15 && $1 == 2) print $0}'; done   | awk '{print $1,$2,$4}' | sort -nr -k3 | head -n 9 | sed 's/^/cp model_/g'| awk '{printf("%s %s_%s.pdb rank_$i.pdb\n", $1,$2,$3)}' 


#cp model_11.pdb rank_$i.pdb
#cp model_11_2.pdb rank_$i.pdb
#cp model_08.pdb rank_$i.pdb
#cp model_15.pdb rank_$i.pdb
#cp model_13.pdb rank_$i.pdb
#cp model_15_2.pdb rank_$i.pdb
#cp model_13_2.pdb rank_$i.pdb
#cp model_06.pdb rank_$i.pdb
#cp model_06_2.pdb rank_$i.pdb
j=1;
for i in model_11.pdb model_11_2.pdb model_08.pdb model_15.pdb model_13.pdb model_15_2.pdb model_13_2.pdb model_06.pdb model_06_2.pdb 
    do
        cp $i rank_$j.pdb
        j=$(($j+1))
    done
