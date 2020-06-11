#! /bin/sh
#$ -S /bin/sh
#$ -cwd

SAMPLE=$1

# python
export PYTHONHOME=/usr/local/package/python2.7/2.7.8
export PYTHONPATH=~/local/lib/python2.7/site-packages
export PATH=${PYTHONHOME}/bin:${PATH}
# export LD_LIBRARY_PATH=${PYTHONHOME}/lib:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=~/local/lib:${PYTHONHOME}/lib:${LD_LIBRARY_PATH}

echo "python getExSkipDel.py ../result/ATL/annot/${SAMPLE}.junctions.annot.txt ../data/ATL/depth/${SAMPLE}_T.depth.bed.gz ../data/ATL/depth/${SAMPLE}_N.depth.bed.gz > ../result/ATL/del2exsk/${SAMPLE}.tmp.txt"
python getExSkipDel.py ../result/ATL/annot/${SAMPLE}.junctions.annot.txt ../data/ATL/depth/${SAMPLE}_T.depth.bed.gz ../data/ATL/depth/${SAMPLE}_N.depth.bed.gz > ../result/ATL/del2exsk/${SAMPLE}.tmp.txt

echo "R --vanilla --slave --args ../result/ATL/del2exsk/${SAMPLE}.tmp.txt ../result/ATL/del2exsk/${SAMPLE}.deletion2exskip.txt < dbGammaPoissonFilt.R"
R --vanilla --slave --args ../result/ATL/del2exsk/${SAMPLE}.tmp.txt ../result/ATL/del2exsk/${SAMPLE}.deletion2exskip.txt < dbGammaPoissonFilt.R 

