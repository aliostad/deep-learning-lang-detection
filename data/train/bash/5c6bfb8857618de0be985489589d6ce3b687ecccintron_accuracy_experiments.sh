#!/usr/bin/env bash
# Used PyPy 2.4.0 with GCC 4.8.2
gzip -cd collected_introns.tsv.gz | pypy asymptote.py --sample-fraction 0.05 -p 31 >intron_accuracy_sample_fraction_0.05.tsv
gzip -cd collected_introns.tsv.gz | pypy asymptote.py --sample-fraction 0.03 -p 31 >intron_accuracy_sample_fraction_0.03.tsv
gzip -cd collected_introns.tsv.gz | pypy asymptote.py --sample-fraction 0.07 -p 31 >intron_accuracy_sample_fraction_0.07.tsv
gzip -cd collected_introns.tsv.gz | pypy asymptote.py --sample-fraction 0.09 -p 31 >intron_accuracy_sample_fraction_0.09.tsv
gzip -cd collected_introns.tsv.gz | pypy asymptote.py --sample-fraction 0.05 --min-reads 5 -p 31 >intron_accuracy_sample_fraction_0.05_read_min_5.tsv
gzip -cd collected_introns.tsv.gz | pypy asymptote.py --sample-fraction 0.05 --min-reads 10 -p 31 >intron_accuracy_sample_fraction_0.05_read_min_10.tsv
gzip -cd collected_introns.tsv.gz | pypy asymptote.py --sample-fraction 0.05 --min-reads 15 -p 31 >intron_accuracy_sample_fraction_0.05_read_min_15.tsv
gzip -cd collected_introns.tsv.gz | pypy asymptote.py --sample-fraction 0.05 --min-reads 20 -p 31 >intron_accuracy_sample_fraction_0.05_read_min_20.tsv
gzip -cd collected_introns.tsv.gz | pypy asymptote.py --sample-fraction 0.05 --min-reads 25 -p 31 >intron_accuracy_sample_fraction_0.05_read_min_25.tsv