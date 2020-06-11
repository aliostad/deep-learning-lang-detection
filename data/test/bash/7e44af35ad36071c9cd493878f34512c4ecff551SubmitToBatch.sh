#!/bin/bash
# ==============================================================================
# = Submit LHE->Pool + Pool->Truth Ntuple to lxplus batch queue
# = This should be called from the BMinusLSUSY directort. It will create two
# = directories.
# =   jobs: hold job stearing files for the batch jobs - This can be discarded
# =         once jobs are completed
# =   d3pd: output ntuples will be copied here
# = usage: ./SubmitToBatch.sh <model dir> <model name> <queue>
# ==============================================================================

# DIR_ON_AFS_WORK=${PWD}
stop_mass=$1
xqcut=$2
qcut=$3
queue=$4

model_name="mstop_${stop_mass}__xqcut_${xqcut}__qcut_${qcut}"

echo "stop mass: $stop_mass"
echo "xqcut: $xqcut"
echo "qcut: $qcut"
echo "queue: $queue"

if [ ! -d "jobs" ] ; then
  mkdir jobs
fi

mkdir $model_name
cp CreateCard.py Reference*Card.dat $model_name

echo "#!/bin/bash" > jobs/jo__$model_name.sh
echo "" >> jobs/jo__$model_name.sh

echo "source ~/.bash_profile" >> jobs/jo__$model_name.sh
echo "" >> jobs/jo__$model_name.sh

# Copy files to worker node
echo "echo \"Copying files to worker node\"" >> jobs/jo__$model_name.sh
echo "cp -rf ${PWD}/../../MG5_aMC_v2_1_0 ." >> jobs/jo__$model_name.sh
echo "cp ${PWD}/$model_name/CreateCard.py ." >> jobs/jo__$model_name.sh
echo "cp ${PWD}/$model_name/Reference*Card.dat ." >> jobs/jo__$model_name.sh
echo "" >> jobs/jo__$model_name.sh

# Run MadGraph
echo "echo \"Running MadGraph\"" >> jobs/jo__$model_name.sh
echo "cd MG5_aMC_v2_1_0" >> jobs/jo__$model_name.sh
echo "${PWD}/RunTestProduction.sh ${PWD}/${model_name} ${stop_mass} ${xqcut} ${qcut}" >> jobs/jo__$model_name.sh
echo "" >> jobs/jo__$model_name.sh

# Copy output to work space
echo "echo \"copying cards to work space\"" >> jobs/jo__$model_name.sh
echo "cp config__${model_name}.sh $PWD/${model_name}" >> jobs/jo__$model_name.sh
echo "cp ${model_name}/Cards/*_card.dat $PWD/${model_name}" >> jobs/jo__$model_name.sh
echo "" >> jobs/jo__$model_name.sh

echo "echo \"copying jet matching plots to work space\"" >> jobs/jo__$model_name.sh
echo "mkdir ${PWD}/${model_name}/matching_plots" >> jobs/jo__$model_name.sh
echo "cp ${model_name}/HTML/run_01/plots_pythia_fermi/DJR* $PWD/${model_name}/matching_plots/" >> jobs/jo__$model_name.sh
echo "" >> jobs/jo__$model_name.sh

# echo "cp -r ${model_name} $PWD/${model_name}/" >> jobs/jo__$model_name.sh
# echo "" >> jobs/jo__$model_name.sh

# make executable
chmod +x jobs/jo__${model_name}.sh

# display job options
echo "command"
cat jobs/jo__${model_name}.sh
echo ""

# run on batch
bsub -q $queue ${PWD}/jobs/jo__${model_name}.sh
