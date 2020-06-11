#!/bin/sh

#
# Script to create one script per model to download these variables:
#

# Cloud and state info: Amon
# clwvi
# clivi
# clt
# snc
# tas
# tasmin
# tasmax

vartype="historical_sfc_tempII"
variables="variable=ts"
#
#for model in GFDL-CM3 BCC-CSM1.1 MRI-CGCM3 MPI-ESM-LR CNRM-CM5 IPSL-CM5B-LR IPSL-CM5A-LR IPSL-CM5A-MR MIROC5 CanAM4 HadGEM2-A

for model in HadGEM2-ES

do
 mkdir -p ${model}/${vartype}
 curl -o ${model}/${vartype}/wget_${model}_${vartype}.sh "http://pcmdi9.llnl.gov/esg-search/wget/?${variables}&model=${model}&project=CMIP5&experiment=historical&cmor_table=Amon&cmor_table=LImon&ensemble=r5i1p1&distrib=true"
 chmod a+rx ${model}/${vartype}/wget_${model}_${vartype}.sh


done
