#initial process_num
#initial process_num
process_num=0;

echo "------------------begin mips.sh----------------------"
ps -auxww | grep zemao | grep sim
let "process_num = 0"
for bsize in 8 16 32 64 128 256 512; do
	for assoc in 1 2 4 8 16 32 64 128 256; do
			get_mips.py -f "./output/bsize_${bsize}_assoc_${assoc}*.out" -t "./config/bsize_${bsize}_assoc_${assoc}.cfg" >./output/bsize_${bsize}_assoc_${assoc}.mips &
			let "process_num = $process_num +1"        
			echo  "there are $process_num  processes runing now. bsize_${bsize} assoc=${assoc} "
			if [ $process_num -ge 24 ]; then
			        wait
			        let "process_num = 0"
			fi	
	done
done

