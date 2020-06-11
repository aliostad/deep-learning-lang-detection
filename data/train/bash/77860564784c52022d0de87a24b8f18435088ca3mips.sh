#initial process_num
#initial process_num
process_num=0;

echo "------------------begin mips.sh----------------------"
ps -auxww | grep zemao | grep sim
let "process_num = 0"
for l1inset in 256; do
for hissize in 10 12 14 16 18 20 21 22 ; do
		let "l2size=(2**(${hissize}))"
			get_mips.py -f "./output/l1inset_${l1inset}_hissize_${hissize}*.out" -t "./config/l1inset_${l1inset}.cfg" >./output/l1inset_${l1inset}_hissize_${hissize}.mips &
			let "process_num = $process_num +1"        
			echo  "there are $process_num  processes runing now. hissize_${hissize} l1inset=${l1inset} "
			if [ $process_num -ge 20 ]; then
			        wait
			        let "process_num = 0"
			fi	
	done
done

