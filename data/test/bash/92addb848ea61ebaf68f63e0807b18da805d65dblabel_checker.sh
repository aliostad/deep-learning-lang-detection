
# run on blue in ~/gits/emdrp/recon/python

fnraw=/home/watkinspv/Downloads/K0057_D31_dsx3y3z1_cropped_to_labels.h5
dataset=data_mag_x3y3z1
fnpath=/home/watkinspv/Downloads/K0057_tracing_combined
outpath=/home/watkinspv/Downloads/K0057_tracing_combined/tmp
tmp=/home/watkinspv/Downloads/tmp.h5
ctx_chunk='0 0 0'
declare -a ctx_offset=(64 64 16); ctx_ofst=$( IFS=' '; echo "${ctx_offset[*]}" )
minsize=9
smooth_size='5 5 5'

declare -a sizes=('256 256 128' '256 256 128' '256 256 128' '128 256 128' '256 256 32' '256 256 32' '256 256 32')
declare -a chunks=("6 23 2" "16 19 15" "4 35 2" "4 11 14" "24 14 8" "13 18 15" "10 11 18")
declare -a offsets=("0 0 32" "0 0 32" "96 96 96"  "96 64 112" "0 0 0" "0 0 64" "32 96 48")
declare -a contour_level_rngs=('0.25 0.45 0.01' '0.25 0.45 0.01' '0.25 0.45 0.01' '0.25 0.42 0.01' '0.25 0.45 0.01' '0.25 0.45 0.01' '0.25 0.42 0.01')

count=0
for chunk in "${chunks[@]}";
do
    echo processing $chunk

    # subtract context offset from offset
    coffset=(${offsets[$count]}); csize=(${sizes[$count]}); cnt=0
    while [ $cnt -lt 3 ]
    do
        coffset[$cnt]=`expr ${coffset[$cnt]} - ${ctx_offset[$cnt]}`
        csize[$cnt]=`expr ${csize[$cnt]} + 2 \* ${ctx_offset[$cnt]}`
        cnt=`expr $cnt + 1`
    done
    # convert back to space delimited strings
    ofst=$( IFS=' '; echo "${coffset[*]}" ); sz=$( IFS=' '; echo "${csize[*]}" )

    # create the filename
    cchunk=($chunk); coffset=(${offsets[$count]})
    fn=`printf 'K0057_D31_dsx3y3z1_x%do%d_y%do%d_z%do%d' ${cchunk[0]} ${coffset[0]} ${cchunk[1]} ${coffset[1]} ${cchunk[2]} ${coffset[2]}`
    size=${sizes[$count]}
    ctx_size=${sz}

    # load raw data and write out nrrd
    dpLoadh5.py --srcfile $fnraw --dataset $dataset --outraw $outpath/${fn}_crop.nrrd --chunk $chunk --size $size --offset ${offsets[$count]}
    
    # save labels into temp hdf5 file and crop out middle labeled region into nrrd
    rm -rf $tmp
    dpWriteh5.py --inraw $fnpath/${fn}_labels.nrrd --chunksize 128 128 64 --datasize $ctx_size --size $ctx_size --chunk 0 0 0 --outfile $tmp --data-type-out uint16 --dataset labels
    dpLoadh5.py --srcfile $tmp --dataset labels --outraw $outpath/${fn}_labels_crop.nrrd --chunk $ctx_chunk --offset $ctx_ofst --size $size
    
    # main label cleaning steps, all steps are done in 3d (NOT per 2d zslice)
    
    # (1) smoothing, done per label
    #dpCleanLabels.py --srcfile $tmp --chunk $ctx_chunk --offset $ctx_ofst --size $size --smooth --smooth-size $smooth_size --contour-lvl ${contour_levels[$count]} --dpC
    dpCleanLabels.py --srcfile $tmp --chunk $ctx_chunk --offset $ctx_ofst --size $size --smooth --smooth-size $smooth_size --contour-lvl ${contour_level_rngs[$count]} --dpC
    
    # (2) remove adjacencies
    dpCleanLabels.py --srcfile $tmp --chunk $ctx_chunk --offset $ctx_ofst --size $size --remove_adjacencies 5 --fg-connectivity 3 --dpC
    
    # (3) connected components
    dpCleanLabels.py --srcfile $tmp --chunk $ctx_chunk --offset $ctx_ofst --size $size --relabel --fg-connectivity 3 --dpC
    
    # (4) remove small components by voxel size
    dpCleanLabels.py --srcfile $tmp --chunk $ctx_chunk --offset $ctx_ofst --size $size --minsize $minsize --dpC
    
    # (5) fill cavities
    dpCleanLabels.py --srcfile $tmp --chunk $ctx_chunk --offset $ctx_ofst --size $size --outraw $outpath/${fn}_labels_clean.nrrd --cavity-fill --dpC

    count=`expr $count + 1`
done

