#!/bin/bash

# first part of regex: \([0-9]\{7\}\) matches 7 digits --> aliquot_id (1175051)
# comma as delimiter
# second part of regex: \([0-9]\{5\}[a-z]\{2\}_[0-9]\{1,2\}\) 
# matches 5 digits, 2 letters, underscore, 1 or 2 digits --> chromatogram_name (14047if_9) 

#echo "BEGIN;"
cat $1 | sed "s/\([0-9]\{7\}\),\([0-9]\{5\}[a-z]\{2\}_[0-9]\{1,2\}\)/WITH result_table AS\n(SELECT DISTINCT tf.SampleInfo.FK_Sample AS FK_Sample, '\1' AS value, 'Aliquot_ID' AS attribute\n FROM GC_Chromatogram\n INNER JOIN Vial ON GC_Chromatogram.id = Vial.FK_chromatogram\n INNER JOIN Sample ON Vial.FK_sample = Sample.id\n INNER JOIN tf.SampleInfo ON Sample.id = tf.SampleInfo.FK_Sample\n WHERE (GC_Chromatogram.Name = '\2'))\n INSERT INTO [tf].[SampleInfo]\n ([FK_Sample]\n ,[value]\n ,[attribute])\n SELECT * FROM result_table; \n/g"
#echo "COMMIT;"