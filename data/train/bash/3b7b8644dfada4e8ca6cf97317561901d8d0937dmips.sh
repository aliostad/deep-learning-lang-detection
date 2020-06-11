#initial process_num
#initial process_num
process_num=0;

echo "------------------begin mips.sh----------------------"
ps -auxww | grep zemao | grep sim
let "process_num = 0"
for l1inset in 256 ; do
for btbsize in 64 128 256 512; do
for assoc in 1 2 4 8 ; do
		let "bsize=${btbsize}/${assoc}"
			get_mips.py -f "./output/assoc_${assoc}_bsize_${bsize}*.out" -t "./config/l1inset_${l1inset}.cfg" >./output/assoc_${assoc}_bsize_${bsize}.mips &
			let "process_num = $process_num +1"        
			echo  "there are $process_num  processes runing now. assoc_${assoc}_bsize_${bsize} "
			if [ $process_num -ge 20 ]; then
			        wait
			        let "process_num = 0"
			fi	
	done
done
done
cd output
para_pick_up.py -f "*.mips" > a.result

