 #!/bin/sh

#plot all 18 spw for fiy 1

src/./gracey.py data/singles/spw/single_spw_set*_fc_1.txt lw=1.0 t="\2 Color Correction Factor Calculations for all of the 18 Models in Suleimanov et al [5]"  ts=1.0 xl="\4  Relative Luminosity (L/L\sEdd\N)" yl="\4  Color Correction Factor (f\sc\N) "  xls=1.0 yls=1.0  sc=re PNG leg=["Model-1",'Model-2','Model-3','Model-4','Model-5','Model-6','Model-7','Model-8','Model-9','Model-10','Model-11','Model-12','Model-13','Model-14','Model-15','Model-16','Model-17','Model-18']
