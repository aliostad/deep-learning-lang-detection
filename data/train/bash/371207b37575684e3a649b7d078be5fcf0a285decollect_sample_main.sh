export MASKVAL=$1
printf "$MASKVAL = $MASKVAL\n* = NULL" | r.reclass input=gt_rast output=mask_$MASKVAL rules=- --overwrite
r.random input=gt_rast n=2 cover=mask_$MASKVAL vector_output=gt_sample_$MASKVAL --overwrite
v.db.addtable   map=gt_sample_$MASKVAL table=gt_sample_$MASKVAL columns='cat integer'
v.db.connect -o map=gt_sample_$MASKVAL table=gt_sample_$MASKVAL
v.db.addcol     map=gt_sample_$MASKVAL columns='x double precision, y double precision'
v.to.db         map=gt_sample_$MASKVAL type=point option=coor columns='x,y'
v.db.select -c  map=gt_sample_$MASKVAL columns=x,y | xargs parallel --jobs 5 ./collect_sample.sh :::
