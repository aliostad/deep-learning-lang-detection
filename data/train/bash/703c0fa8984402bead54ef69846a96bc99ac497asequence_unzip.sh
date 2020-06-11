#concatenate gzipped archives
cat run_405/Project_saltiel/Sample_12849/*.gz > bridges/ikk_aso/Sample_12849.fa.gz
cat run_405/Project_saltiel/Sample_12850/*.gz > bridges/ikk_aso/Sample_12850.fa.gz    
cat run_405/Project_saltiel/Sample_12851/*.gz > bridges/ikk_aso/Sample_12851.fa.gz
cat run_405/Project_saltiel/Sample_12852/*.gz > bridges/ikk_aso/Sample_12852.fa.gz
cat run_405/Project_saltiel/Sample_12853/*.gz > bridges/ikk_aso/Sample_12853.fa.gz
cat run_405/Project_saltiel/Sample_12854/*.gz > bridges/ikk_aso/Sample_12854.fa.gz
cat run_405/Project_saltiel/Sample_12855/*.gz > bridges/ikk_aso/Sample_12855.fa.gz
cat run_405/Project_saltiel/Sample_12856/*.gz > bridges/ikk_aso/Sample_12856.fa.gz
cat run_405/Project_saltiel/Sample_12857/*.gz > bridges/ikk_aso/Sample_12857.fa.gz
cat run_405/Project_saltiel/Sample_12858/*.gz > bridges/ikk_aso/Sample_12858.fa.gz    
#unzip all files and remove originals
gunzip -v *.gz