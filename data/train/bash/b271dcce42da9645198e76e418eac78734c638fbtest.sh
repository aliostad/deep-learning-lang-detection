#!/bin/zsh

IDENTIFIER=$RANDOM
[[ $ARGC > 0 ]] && IDENTIFIER=$argv[1]
MODEL_ID="test_${IDENTIFIER}"
MODEL_NAME="${MODEL_ID}.zpl"

GENERATE_DIR="$HOME/tesis/utils/"
GENERATE_CMD="./generate_testcase --professors=3 \
                                  --courses=2\
                                  --classes=2\
                                  --availability_probability=1\
                                  --start_weeks=1\
                                  --schedules=2\
                                  --max_roles=1\
                                  --roles=2\
                                  --weeks=2\
                                  --week_days=3\
                                  --random_seed=12345 > $MODEL_NAME"
CONVERT_CMD="./zimpl.bin $MODEL_NAME > /dev/null"
FPORTA_DIR="$HOME/tesis/enumerate/"
PIPELINE_CMD="./pipeline $MODEL_ID.lp"
MODEL_DIR="$FPORTA_DIR/$MODEL_ID"

print "Creating $MODEL_NAME..."
mkdir -p $MODEL_ID
pushd $GENERATE_DIR
eval $GENERATE_CMD
print "Converting to LP format..."
eval $CONVERT_CMD
mv $MODEL_ID.lp $MODEL_ID.zpl $MODEL_ID.tbl $MODEL_DIR
popd
cp xporta enumerate pipeline $MODEL_ID
print "Saving config to ${MODEL_ID}/config"
pushd $MODEL_ID
print $GENERATE_CMD >> config
print "Running pipeline..."
eval $PIPELINE_CMD
if [ $? -eq 0 ]; then;
   print "Inequalities written to $MODEL_ID.txt";
else;
   print "Inequalities not computed."
 fi
rm xporta pipeline enumerate
popd $MODEL_ID

