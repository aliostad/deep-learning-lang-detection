# get final protein data from be files as GRanges objects suitable for mapping on css
bsub -M 700000 -R "rusage[mem=700000]" /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R CPSF160
bsub -M 700000 -R "rusage[mem=700000]" /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R Fip1
bsub -M 700000 -R "rusage[mem=700000]" /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R CstF64
bsub -M 700000 -R "rusage[mem=500000]" /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R CstF64tau
bsub -M 700000 -R "rusage[mem=700000]" /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R CPSF100
bsub -M 700000 -R "rusage[mem=700000]" /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R CPSF73
bsub -M 700000 -R "rusage[mem=700000]" /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R CPSF30
bsub -M 700000 -R "rusage[mem=700000]" /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R CFIm68
bsub -M 700000 -R "rusage[mem=700000]" /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R CFIm59
bsub -M 700000 -R "rusage[mem=700000]" /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R CFIm25
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R PTB
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R TIA1
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R TIAL1
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R TDP43
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R U2AF65
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R hnRNPC
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R TIAL1_Hela
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R TDP43_Hela
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R TDP43_SHSY5Y
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R TDP43_ES
bsub /homes/kiselev/R-2.15.2/bin/Rscript process_bed.R HuR_Mukherjee

