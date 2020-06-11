

for sample in $(seq 1 8)
do
	for chromosome in $(seq 1 36)
	do	
		(
		echo "<html><head><title>"
		echo "Sample $sample, Chromosome $chromosome"
		echo "</title></head><body>"
		echo "Sample: "
		for sample2 in $(seq 1 8)
		do
			echo "<a href=\"simple-$sample2-$chromosome.html\">$sample2</a> "
		done
		echo "<br />"
		echo "Chromosome: "
		for chromosome2 in $(seq 1 36)
		do
			echo "<a href=\"simple-$sample-$chromosome2.html\">$chromosome2</a> "
		done
		echo "<br />"
		echo "<h1>Sample $sample, Chromosome $chromosome</h1>"
		
		
		file=Sample$sample"Chromosome"$chromosome"-RawReadsNormalizedGCNormalizedAgainst1.png"
		echo "<img src=\"$file\" />"
		echo "</body></html>"
		)> simple-$sample-$chromosome.html

	done 
done
