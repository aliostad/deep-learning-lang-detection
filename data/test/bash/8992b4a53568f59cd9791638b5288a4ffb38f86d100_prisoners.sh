#!/bin/bash
# vim: sts=4 sw=4 et tw=0:

sample_done=0
sample_size=100
failure=0
success=0
total_found=0
num_inmates=100
inmates=($(seq 1 $num_inmates))

locate() {
    for wanted in "$@"; do
        local count=0
        local found=${boxes[$((wanted-1))]}
        # Walk the boxes till we find 'wanted'
        while [[ $count -lt $((num_inmates >> 1)) ]]; do
            if [[ $found == $wanted ]]; then
                echo 1
                break
            fi
            found=${boxes[$((found-1))]}
            count=$((count+1))
        done
    done
}

while [[ $sample_done -lt $sample_size ]]; do
    boxes=($(shuf -e "${inmates[@]}"))
    inmate_success=($(locate "${inmates[@]}"))
    inmate_success=${#inmate_success[@]}
    total_found=$((total_found+inmate_success));
    sample_done=$((sample_done+1));
    if [[ $inmate_success == $num_inmates ]]; then
        success=$((success+1));
    elif [[ $inmate_success == 0 ]]; then
        failure=$((failure+1));
    fi
done
 
echo "Successes: $(bc -l <<<$success*100.0/$sample_size)"
echo "Partial Successes: $(bc -l <<<\($sample_size-$success-$failure\)*100.0/$sample_size)"
echo "Failures: $(bc -l <<<$failure*100.0/$sample_size)"
echo "Individual chances: $(bc -l <<<$total_found*100.0/\($sample_size*$num_inmates\))"
