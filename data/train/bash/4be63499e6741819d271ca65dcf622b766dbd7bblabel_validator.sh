
# run on blue in ~/gits/emdrp/recon/python

outpath=/home/watkinspv/Downloads/K0057_tracing_combined/tmp_validate
fnraw=/home/watkinspv/Downloads/K0057_D31_dsx3y3z1_cropped_to_labels.h5
inlabels=/home/watkinspv/Downloads/K0057_D31_dsx3y3z1_labels.h5
dataset=data_mag_x3y3z1

declare -a sizes=('256 256 128' '256 256 128' '256 256 128' '128 256 128' '256 256 32' '256 256 32' '256 256 32')
declare -a chunks=("6 23 2" "16 19 15" "4 35 2" "4 11 14" "24 14 8" "13 18 15" "10 11 18")
declare -a offsets=("0 0 32" "0 0 32" "96 96 96"  "96 64 112" "0 0 0" "0 0 64" "32 96 48")

# only for validation
count=0
for chunk in "${chunks[@]}";
do
    # create the filename
    cchunk=($chunk); coffset=(${offsets[$count]})
    fn=`printf 'K0057_D31_dsx3y3z1_x%do%d_y%do%d_z%do%d' ${cchunk[0]} ${coffset[0]} ${cchunk[1]} ${coffset[1]} ${cchunk[2]} ${coffset[2]}`
    size=${sizes[$count]}

    echo processing $chunk
    dpLoadh5.py --srcfile $fnraw --chunk $chunk --size $size --offset ${offsets[$count]} --dataset $dataset --outraw $outpath/${fn}.nrrd --dpL
    dpLoadh5.py --srcfile $inlabels --chunk $chunk --size $size --offset ${offsets[$count]} --dataset labels --outraw $outpath/${fn}_labels.nrrd --dpL

    count=`expr $count + 1`
done
