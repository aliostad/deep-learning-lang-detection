#initial process_num
#initial process_num
process_num=0;

echo "------------------begin mips.sh----------------------"
let "process_num = 0"
for decode in 1 2 4 8 16; do
	for issue in 1 2 4 8 16; do
		for commit in 1 2 4 8 16; do
			for fetch in 1 2 4 8 16; do
			get_mips.py -f "./output/decode_${decode}_issue_${issue}_commit_${commit}_fetch_${fetch}.out" -t "./config/width.cfg" >./output/decode_${decode}_issue_${issue}_commit_${commit}_fetch_${fetch}.mips &
			let "process_num = $process_num +1"        
			echo  "there are $process_num  processes runing now. decode_${decode} issue=${issue} "
			if [ $process_num -ge 24 ]; then
			        wait
			        let "process_num = 0"
			fi	
			done
		done
	done
done

