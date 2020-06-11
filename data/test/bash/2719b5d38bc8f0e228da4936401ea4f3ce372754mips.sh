#initial process_num
#initial process_num
process_num=0;

echo "------------------begin mips.sh----------------------"
ps -auxww | grep zemao | grep sim
let "process_num = 0"
for bsize in 32 64 128 256; do
	for assoc in 1 2 4 8 16 ; do
		let "nsets=2048*128*2/${assoc}/${bsize}"
			get_mips.py -f "./output/l2_bsize_${bsize}_assoc_${assoc}_nsets_${nsets}*.out" -t "./config/l2_bsize_${bsize}_assoc_${assoc}_nsets_${nsets}.cfg" >./output/l2_bsize_${bsize}_assoc_${assoc}_nsets_${nsets}.mips &
			let "process_num = $process_num +1"        
			echo  "there are $process_num  processes runing now. bsize_${bsize} assoc=${assoc} "
			if [ $process_num -ge 20 ]; then
			        wait
			        let "process_num = 0"
			fi	
	done
done

