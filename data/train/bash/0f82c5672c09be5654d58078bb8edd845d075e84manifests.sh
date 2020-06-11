#!/bin/bash

# log all commands to stderr
set -x

# catch errors
set -e
set -o pipefail

# check all variables are set
set -u

# handle command line args
while getopts "g:h:c:j:4:5:R:" opt; do
    case $opt in
    g)
        GENOME=$OPTARG ;;
    h)
        CHUNK_SIZE=$OPTARG ;;
    c)
        CHUNKS_MANIFEST=$OPTARG ;;
    j)
        CHUNKED_GENOTYPES_DIR=$OPTARG ;;
    4)
        ANNOTATED_VCF_SUFFIX=$OPTARG ;;
    5)
        ANNOTATED_VCF_FOFN=$OPTARG ;;
    R)
        REGIONCHUNKS=$OPTARG ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1 ;;
    :)
        echo "Option -$OPTARG requires an argument" >&2
        exit 1 ;;
    esac
done

echo "starting manifests.sh"

###########################################################################
# 1) create genome chunks manifest
###########################################################################

$REGIONCHUNKS --genome $GENOME \
    --chunk_size $CHUNK_SIZE \
    --chunks_manifest_fn $CHUNKS_MANIFEST \
    --vcf_fn_format "$CHUNKED_GENOTYPES_DIR/%s$ANNOTATED_VCF_SUFFIX" \
    --vcf_fofn $ANNOTATED_VCF_FOFN

echo "finished manifests.sh"
