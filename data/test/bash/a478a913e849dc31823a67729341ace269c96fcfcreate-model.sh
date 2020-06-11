#! /bin/sh
#
# generate a nonlinear hierarchial model from scaled mouse data


#set -e
set -o nounset

symmetric_dir='x'
model_norm_thresh='0.1'
model_min_step='1.0'

model="model.mnc"
stdev="stdev.mnc"

somewhere_really_big="."

# start logging
{

   # adjust this bit to suit
   filelist=`ls -1 mouse??.mnc | tr "\n" " "`

   volgenmodel \
         -symmetric \
         -symmetric_${symmetric_dir} \
         -clean \
         -check \
         -normalise \
         -model_norm_thresh $model_norm_thresh \
         -model_min_step $model_min_step \
         -pad 5 \
         -config_file fit.10-genmodel.conf \
         -fit_stages lin,1,3 \
         -output_model $model \
         -output_stdev $stdev \
         -workdir $somewhere_really_big/work \
         $filelist
   
   # checks
   mincpik -clobber \
      -triplanar -sagittal_offset_perc 5 \
      $model $model.jpg


} 2>&1 | tee log.txt

