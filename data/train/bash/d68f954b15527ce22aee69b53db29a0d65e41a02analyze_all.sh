#!/bin/bash

python process_site_species.py "CPN" "SCOC"
python process_site_species.py "JAM" "SCOC"
python process_site_species.py "JAM" "ASHY"
python process_site_species.py "LOM" "SCOC"
python process_site_species.py "LOM" "ASHY"
python process_site_species.py "SYR" "SCOC"
python process_site_species.py "TP" "SCOC"
python process_site_species.py "TP" "ASHY"

rm ../results/partial_r.txt
rm ../results/partial_p.txt
rm ../results/mantel_r.txt
rm ../results/mantel_p.txt

grep 'Significance' ../results/*/*/*_partial > ../results/partial_p.txt
grep 'statistic r' ../results/*/*/*_partial > ../results/partial_r.txt
grep 'Significance' ../results/*/*/*_mantel > ../results/mantel_p.txt
grep 'statistic r' ../results/*/*/*_mantel > ../results/mantel_r.txt
