#./svm_latent_learn_online -n 4 -f tmp3/ -w 0.5 -y 0.9 -z dataset/v.small.stats -o 0.0 -a 0 -b 1 -C 5 -c 5 -e 0.5 dataset/v.small.data temp-x.model >> abc.txt 2>>abc.txt & -- command to run online svm pre-version -- working without segfaults -- java code to split datasets
#./svm_latent_learn_online -n 4 -f tmp3/ -w 0.5 -y 0.9 -z dataset/v.small.stats -o 0.0 -a 0 -b 1 -C 5 -c 5 -e 0.5 -K 5 -E 2 dataset/v.small.data temp-y.model >> cdf.txt 2>>cdf.txt & -- online svm-version -- running without faults on the local m/c on a small dataset (change of vars, augmenting loss multiple epochs)


#export MOSEKLM_LICENSE_FILE=/home/sandip/eclipse/Luna_Workspace/online_rewrite/lib/mosek/mosek.lic
#export LD_LIBRARY_PATH='/home/sandip/mosek/5/tools/platform/linux64x86/bin;/home/sandipiitb/Sem-2/RandD/Sunny_MTP/Luna_Workspace/online_rewrite/java/lib:/usr/lib/lp_solve'
#ulimit -c unlimited
export MOSEKLM_LICENSE_FILE=/home/sandip/sandip_mtp/mosek/mosek.lic
export LD_LIBRARY_PATH='/home/sandip/sandip_mtp/mosek/5/tools/platform/linux64x86/bin;/home/sandip/sandip_mtp/codebase/online_rewrite_random_chunk/java/lib:/home/sandip/sandip_mtp/lp_solve'
ulimit -c unlimited


echo Dont look at the screen!!! Do some other work. It will take a long time!!!

COUNTER_EPOCH=20
COUNTER_CHUNK=15

echo --------- Start  --------- > progress.data

while [  $COUNTER_EPOCH -le 20 ]; do
	#Initialize Chunk for each EPOCH
	COUNTER_CHUNK=15
	while [  $COUNTER_CHUNK -le 50 ]; do
		
		echo --------- Start -  COUNTER_EPOCH = $COUNTER_EPOCH --- COUNTER_CHUNK - $COUNTER_CHUNK --------- >> progress.data
		#Training
		./svm_latent_learn_online -n 10 -f tmp1/ -w 0.5 -y 0.9 -z dataset/train-riedel-full.stats -o 0.0 -a 0 -b 1 -C 5 -c 5 -e 0.5 -M 5 -K $COUNTER_CHUNK -E $COUNTER_EPOCH dataset/reidel_trainSVM.data temp_{$COUNTER_CHUNK}_{$COUNTER_EPOCH}.model > print_{$COUNTER_CHUNK}_{$COUNTER_EPOCH}.log
		
		echo ---------  Training Done -  COUNTER_EPOCH = $COUNTER_EPOCH --- COUNTER_CHUNK - $COUNTER_CHUNK --------- >> progress.data
		#Inference		
		java -Xmx4G -cp java/lib/*:java/bin/:/usr/lib/lp_solve/ evaluation.ClassifyStructEgAllOnline temp_{$COUNTER_CHUNK}_{$COUNTER_EPOCH}.model dataset/testSVM.pos_r.data dataset/reidel_mapping

		echo ---------  Inference Done -  COUNTER_EPOCH = $COUNTER_EPOCH --- COUNTER_CHUNK - $COUNTER_CHUNK --------- >> progress.data
		#Test Results
		java -Xmx4G -cp java/lib/*:java/bin/:/usr/lib/lp_solve/ evaluation.ReidelEval temp_{$COUNTER_CHUNK}_{$COUNTER_EPOCH}.model.result 0.5 > result_{$COUNTER_CHUNK}_{$COUNTER_EPOCH}.data

		
		if [ $COUNTER_CHUNK -le 20 ]
		then
		 let COUNTER_CHUNK=COUNTER_CHUNK+10
		else
		 let COUNTER_CHUNK=COUNTER_CHUNK+10
		fi
	done
	let COUNTER_EPOCH=COUNTER_EPOCH+5
done
echo Finally Done!!!

