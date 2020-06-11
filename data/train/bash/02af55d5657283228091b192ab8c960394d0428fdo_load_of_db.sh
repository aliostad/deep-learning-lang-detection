#!/bin/sh

VERSION=$1
ACEDB=$2

load_accession_number.pl ${VERSION} ${ACEDB}
load_alleles.pl ${VERSION} ${ACEDB}
load_anatomy.pl ${VERSION} ${ACEDB}
load_expression_patterns.pl ${VERSION} ${ACEDB}
load_gene_class.pl ${VERSION} ${ACEDB}
load_genes.pl ${VERSION} ${ACEDB}
load_genetic_map.pl ${VERSION} ${ACEDB}
load_gene_regulation.pl ${VERSION} ${ACEDB}
load_go.pl ${VERSION} ${ACEDB}
load_laboratory.pl ${VERSION} ${ACEDB}
load_microarray_experiments.pl ${VERSION} ${ACEDB}
load_models.pl ${VERSION} ${ACEDB}
load_motif.pl ${VERSION} ${ACEDB}
load_operon.pl ${VERSION} ${ACEDB}
#load_papers.pl ${VERSION} ${ACEDB}
load_pcr_product.pl ${VERSION} ${ACEDB}
load_people.pl ${VERSION} ${ACEDB}
load_phenotypes.pl ${VERSION} ${ACEDB}
load_proteins.pl ${VERSION} ${ACEDB}
load_rnai.pl ${VERSION} ${ACEDB}
load_sequence.pl ${VERSION} ${ACEDB}
load_species.pl ${VERSION} ${ACEDB}
load_strains.pl ${VERSION} ${ACEDB}
#load_y2h.pl ${VERSION} ${ACEDB}
