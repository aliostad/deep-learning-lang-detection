prev=""
while true ; do	
	sleep 1
	text=`iostat`

	IFS='
	'
	don="0"
	for i in $text
	do
		IFS=' '
		flag="0"
		sample=""
		for j in $i
		do
			if [ "$j" == "sdb" ]; then
				flag="1"
			fi

			if [ $flag -eq "0" ] ; then
				break
			fi

			sample=$j

		done

		if [ "$sample" != "" ]; then
			#echo $sample
			#echo $prev
			echo "Copying"
			if [[ "$prev" -eq "$sample" ]]; then
				echo "Done"
				don="1"
				break
			fi
			prev=$sample
		fi

		IFS='
		'
	done

	if [[ "$don" -eq "1" ]]; then
		break
	fi
done
