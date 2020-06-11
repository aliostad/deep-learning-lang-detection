#!/bin/sh -x
cgview=../cgview_comparison_tool/bin/cgview.jar

if [ ! -d ./sample_output ]; then
    mkdir ./sample_output
fi

for size in small medium large x-large
do
    #simple
    perl cgview_xml_builder.pl -sequence sample_input/R_denitrificans.gbk -genes sample_input/R_denitrificans.cogs -output sample_output/${size}_simple.xml -gc_content T -gc_skew T -size $size -title 'Roseobacter denitrificans' -draw_divider_rings T

    java -jar -Xmx2000m $cgview -i sample_output/${size}_simple.xml -o sample_output/${size}_simple.png -f png

    #complex
    perl cgview_xml_builder.pl -sequence sample_input/R_denitrificans.gbk -genes sample_input/R_denitrificans.cogs -output sample_output/${size}_complex.xml -reading_frames T -orfs T -combined_orfs T -gc_content T -gc_skew T -at_content T -at_skew T -size $size -title 'Roseobacter denitrificans' -draw_divider_rings T

    java -jar -Xmx2000m $cgview -i sample_output/${size}_complex.xml -o sample_output/${size}_complex.png -f png
done


#create an x-large with feature labels
size=x-large
perl cgview_xml_builder.pl -sequence sample_input/R_denitrificans.gbk -genes sample_input/R_denitrificans.cogs -output sample_output/${size}_complex_labels.xml -reading_frames T -orfs T -combined_orfs T -gc_content T -gc_skew T -at_content T -at_skew T -size $size -title 'Roseobacter denitrificans' -feature_label T -draw_divider_rings T

java -jar -Xmx2000m $cgview -i sample_output/${size}_complex_labels.xml -o sample_output/${size}_complex_labels.png -f png 

#create zoomed with starts and stops
size=large
perl cgview_xml_builder.pl -sequence sample_input/R_denitrificans.gbk -genes sample_input/R_denitrificans.cogs -output sample_output/${size}_no_labels.xml -reading_frames T -combined_orfs T -gc_content F -gc_skew F -at_content F -at_skew F -size $size -title 'Roseobacter denitrificans' -draw_divider_rings T

java -jar -Xmx1000m $cgview -i sample_output/${size}_no_labels.xml -o sample_output/${size}_no_labels_zoomed.png -f png -z 50 -c 10000

#test ability to handle multiple 'genes' files
size=medium
perl cgview_xml_builder.pl -sequence sample_input/R_denitrificans.gbk -genes sample_input/R_denitrificans.cogs sample_input/R_denitrificans.cogs sample_input/R_denitrificans.cogs -output sample_output/${size}_multiple_genes_files.xml -reading_frames T -combined_orfs T -gc_content F -gc_skew F -at_content F -at_skew F -size $size -title 'Roseobacter denitrificans' -draw_divider_rings T

java -jar -Xmx1000m $cgview -i sample_output/${size}_multiple_genes_files.xml -o sample_output/${size}_multiple_genes_files_zoomed.png -f png -z 50 -c 10000


