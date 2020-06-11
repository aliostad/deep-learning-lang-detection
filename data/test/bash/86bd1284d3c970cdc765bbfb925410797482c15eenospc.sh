#Copy chunk of data untill ENOSPC and we show if all blocks
#freed with rm command.
i=1
    while true; do
            size=$((i*1024))
            head -c $size /dev/urandom > /random
            df -B 512
            j=1
            while true; do
                    echo "copying chunk $j: "
                    cp /random /pram/random$j
                    if [ $? -ne 0 ]; then
                            echo "$((j-1)) chunks of $i KB"
                            if [ $j -eq 1 ]; then
                                    exit
                            fi
                            break
                    fi
                    df -B 512 | grep pram
                    j=$((j+1))
            done
            i=$((i+1))
            rm -rf /pram/*
    done
