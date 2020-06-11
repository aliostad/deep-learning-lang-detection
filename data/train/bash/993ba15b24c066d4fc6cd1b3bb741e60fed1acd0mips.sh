#initial process_num
#initial process_num
process_num=0;

ps -auxww | grep zemao | grep sim
let "process_num = 0"
for assoc in 1 2 4 8 16 32; do
	for replace in l r f; do
		get_mips.py -f "./assoc_output/assoc_${assoc}_replace_${replace}*.out" -t "./assoc_config/assoc_${assoc}_replace_${replace}.cfg" >./assoc_output/assoc_${assoc}_replace_${replace}.mips &
		let "process_num = $process_num +1"        
		echo  "there are $process_num  processes runing now. assoc=${assoc} replace=${replace}"
		if [ $process_num -ge 24 ]; then
		        #ps -auxww | grep zemao | grep sim
		        wait
		        let "process_num = 0"
		fi	
	done
done

