#!/bin/bash

func="dct_based"

for expnum in 0 1 2; do
    ipnut_dir="\/u\/yichao\/anomaly_compression\/condor_data\/subtask_inject_error\/TM_err\/"
    filename="TM_Airport_period5_.exp"
    num_frames=12
    width=300
    height=300

    for opt_swap_mat in 0 1 2 3; do
        for group_size in 4; do
            for opt_type in 0 1; do

                if [[ ${opt_type} -eq 0 ]]; then
                    chunk_size=0
                    sel_chunks=0

                    for quantization in 5 10 20 30 50; do
                        for thresh in 5 10 15 20 30 50 70 100 150 200 250; do
                            echo ${func}.${filename}${expnum}.${num_frames}.${width}.${height}.${group_size}.${thresh}.${opt_swap_mat}.${opt_type}.${chunk_size}.${chunk_size}.${sel_chunks}.${quantization}
                            sed "s/INPUT_DIR/${ipnut_dir}/g; s/FILENAME/${filename}${expnum}./g;s/NUM_FRAMES/${num_frames}/g;s/CHUNK_WIDTH/${chunk_size}/g;s/CHUNK_HEIGHT/${chunk_size}/g;s/WIDTH/${width}/g;s/HEIGHT/${height}/g;s/GROUP_SIZE/${group_size}/g;s/THRESH/${thresh}/g;s/OPT_SWAP_MAT/${opt_swap_mat}/g;s/OPT_TYPE/${opt_type}/g;s/SEL_CHUNKS/${sel_chunks}/g;s/QUANTIZATION/${quantization}/g;" ${func}.mother.sh > tmp.${func}.${filename}${expnum}.${num_frames}.${width}.${height}.${group_size}.${thresh}.${opt_swap_mat}.${opt_type}.${chunk_size}.${chunk_size}.${sel_chunks}.${quantization}.sh
                            sed "s/XXX/${filename}${expnum}.${num_frames}.${width}.${height}.${group_size}.${thresh}.${opt_swap_mat}.${opt_type}.${chunk_size}.${chunk_size}.${sel_chunks}.${quantization}/g" ${func}.mother.condor > tmp.${func}.${filename}${expnum}.${num_frames}.${width}.${height}.${group_size}.${thresh}.${opt_swap_mat}.${opt_type}.${chunk_size}.${chunk_size}.${sel_chunks}.${quantization}.condor
                            condor_submit tmp.${func}.${filename}${expnum}.${num_frames}.${width}.${height}.${group_size}.${thresh}.${opt_swap_mat}.${opt_type}.${chunk_size}.${chunk_size}.${sel_chunks}.${quantization}.condor
                        done
                    done

                elif [[ ${opt_type} -eq 1 ]]; then
                    quantization=0

                    for chunk_size in 30 50 100; do
                        for sel_chunks in 1 5 10 20 30; do
                            for thresh in 5 10 15 20 30 50 70 100 150 200 250; do
                                echo ${func}.${filename}${expnum}.${num_frames}.${width}.${height}.${group_size}.${thresh}.${opt_swap_mat}.${opt_type}.${chunk_size}.${chunk_size}.${sel_chunks}.${quantization}
                                sed "s/FILENAME/${filename}${expnum}./g;s/NUM_FRAMES/${num_frames}/g;s/CHUNK_WIDTH/${chunk_size}/g;s/CHUNK_HEIGHT/${chunk_size}/g;s/WIDTH/${width}/g;s/HEIGHT/${height}/g;s/GROUP_SIZE/${group_size}/g;s/THRESH/${thresh}/g;s/OPT_SWAP_MAT/${opt_swap_mat}/g;s/OPT_TYPE/${opt_type}/g;s/SEL_CHUNKS/${sel_chunks}/g;s/QUANTIZATION/${quantization}/g;" ${func}.mother.sh > tmp.${func}.${filename}${expnum}.${num_frames}.${width}.${height}.${group_size}.${thresh}.${opt_swap_mat}.${opt_type}.${chunk_size}.${chunk_size}.${sel_chunks}.${quantization}.sh
                                sed "s/XXX/${filename}${expnum}.${num_frames}.${width}.${height}.${group_size}.${thresh}.${opt_swap_mat}.${opt_type}.${chunk_size}.${chunk_size}.${sel_chunks}.${quantization}/g" ${func}.mother.condor > tmp.${func}.${filename}${expnum}.${num_frames}.${width}.${height}.${group_size}.${thresh}.${opt_swap_mat}.${opt_type}.${chunk_size}.${chunk_size}.${sel_chunks}.${quantization}.condor
                                condor_submit tmp.${func}.${filename}${expnum}.${num_frames}.${width}.${height}.${group_size}.${thresh}.${opt_swap_mat}.${opt_type}.${chunk_size}.${chunk_size}.${sel_chunks}.${quantization}.condor
                            done
                        done
                    done
                fi

            done
        done
    done
done




