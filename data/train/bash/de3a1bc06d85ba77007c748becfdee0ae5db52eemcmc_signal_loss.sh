NSAMP=100
VERSIONS=(.01 .05 .1 .2 .5 1.0 2.0 5.0 10.0) #array
SIGNALDIR=/Users/sherlock/projects/paper/analysis/psa64/signal_loss/signal/sim
STARTSAMP=0
for SAMPLE in `seq ${STARTSAMP} ${NSAMP}`; do
    echo Sample Number   : ${SAMPLE}
    echo Making Noise Simulations with mean 0 and variance 1
    echo Fringe rate filtering to match the data
    ./make_noise.sh
    for VER in ${VERSIONS[*]}; do 
        echo '   Version Number ${VERSION}'
        mkdir sep0,1/level_${VER}
        cd sep0,1/level_${VER}
        mkdir sample_${SAMPLE}
        cd sample_${SAMPLE}
        python /Users/sherlock/src/capo/zsa/scripts/pspec_cov_v002.py -C psa6240_v003 --window=none -c 95_115 --sep=sep0,1 --loss=${SIGNALDIR} --level=${VER}
        cd ../../../

        echo `pwd`
        if [ ! -d level_${VER} ]; then
            mkdir level_${VER}
        fi
        cd level_${VER}
        mkdir sample_${SAMPLE}
        cd sample_${SAMPLE}

        python ../../pspec_cov_boot.py ../../sep0,1/level_${VER}/sample_${SAMPLE}/pspec_boot00*.npz
        python ../../pspec_cov_boot.py ../../sep0,1/level_${VER}/sample_${SAMPLE}/pspec_boot00*.npz --nocov


#dont plot!
        #pspec_plot_pk_k3pk.py pspec.npz --show --cov --afrf
#        pspec_plot_pk_k3pk_multi.py pspec.npz nocov_pspec.npz --show --cov

        #echo Signal Level at ${VERSION}\n Sample number ${SAMPLE}\n Simulation in ${SIGNALDIR}\n > README
        cd ../..
    done 

done
