#initial process_num
process_num=0;
nsets=0
for bsize in 8 16 32 64 128 256 512 1024; do
	for assoc in 1 2 4 8 16 32 64 128 256; do
		let "nsets=1024*8/${assoc}"
			gen_config.py -a "256 32 2 l" -b "128 32 4 l" -c "dl2" -d "${nsets} ${bsize} ${assoc} r" -r "32 2 1 1 1" -s "2 4 4 4" -f "./config/bsize_${bsize}_assoc_${assoc}.cfg" >./config/bsize_${bsize}_assoc_${assoc}_cfg.gen &
			
			#control process
			let "process_num = $process_num +1"        
			echo  "there are $process_num  processes runing now. bsize=${bsize} assoc=${assoc}"
			if [ $process_num -ge 12 ]; then
			        wait
			        let "process_num = 0"
			fi	
	done
done
wait

echo "should generate 8*9 files in config"
