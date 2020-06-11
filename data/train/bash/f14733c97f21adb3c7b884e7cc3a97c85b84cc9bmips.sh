#initial process_num
#initial process_num
process_num=0;

echo "------------------begin mips.sh----------------------"
let "process_num = 0"
for decode in 1 2 4 8 16 32; do
	issue=${decode} 
	commit=${decode} 
	fetch=${decode}
	for mem in 1 2 4 8 16 32; do
	get_mips.py -f "./output/decode_${decode}_issue_${issue}_commit_${commit}_fetch_${fetch}_mem_${mem}*.out" -t "./config/decode_${decode}_issue_${issue}_fetch_${fetch}_mem_${mem}.cfg" >./output/decode_${decode}_issue_${issue}_commit_${commit}_fetch_${fetch}_mem_${mem}.mips &
	let "process_num = $process_num +1"        
	echo  "there are $process_num  processes runing now. decode_${decode} issue=${issue} "
	if [ $process_num -ge 16 ]; then
	        wait
	        let "process_num = 0"
	fi	
	done
done

