ANALYSISDIR=$HOME/Projects/mutation-analysis

# usage:
# sh review.sh $HOME/Analysis fap absolute/dnacopy-adj-tgt

sed '1d' review.txt | cut -f1,14 | while read sample num; do 
	if [ $num != 0 ]; then
		echo "rerun $sample..."
		cd $sample
		orig_call=$sample.PP-calls_tab.txt.bak
		curr_call=$sample.PP-calls_tab.txt
		if [ ! -e "$orig_call" ]; then
			cp $curr_call $orig_call
		fi
			
		# restore original
		cp $orig_call $curr_call
		awk -v num=$num '{FS=OFS="\t"; print num, $0}' $curr_call > tmpfile
		mv tmpfile $curr_call

		# re-extract absolute 
		CMD="Rscript $ANALYSISDIR/absolute.R $1 $2 $3 $sample.maf $sample.seg $sample hg19 1"
		echo $CMD
		$CMD	
		cd ..
	fi
done

