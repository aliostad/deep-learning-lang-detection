#!/bin/bash -e
#
# Copyright (c) 2016 The Ontario Institute for Cancer Research. All rights reserved.
#
# This program and the accompanying materials are made available under the terms of the GNU Public License v3.0.
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# DCC-959
# Removes clinical data not related to SSM data
# !! must run inside a secured directory !!
# usage: field indices are optional if the submission files follow the order specified in the specifications (most submissions usually do)
# - ./discard.sh data/us__03__097__donor__20130214.txt data/us__03__097__specimen__20130214.txt data/us__03__097__sample__20130214.txt data/ssm__us__03__012__m__3__20130215.txt
# - ./discard.sh data/us__03__097__donor__20130214.txt data/us__03__097__specimen__20130214.txt data/us__03__097__sample__20130214.txt data/ssm__us__03__012__m__3__20130215.txt 1 1 2 2 1 2 3
# output: will output commands to replace the original files once satisfied with the output

# ---------------------------------------------------------------------------

mkdir -p ./tmp
rm ./tmp/* 2>&- || :

# ---------------------------------------------------------------------------
# get files

donor_file=${1?} && shift
specimen_file=${1?} && shift
sample_file=${1?} && shift
ssm_m_file=${1?} && shift

# ---------------------------------------------------------------------------
# get indices

# 1-based
donor_donor_id=$1

specimen_donor_id=$2
specimen_specimen_id=$3

sample_specimen_id=$4
sample_sample_id=$5

ssm_m_analyzed_sample_id=$6
ssm_m_matched_sample_id=$7

# ---------------------------------------------------------------------------
# set defaults

# 1-based; indices as per specs (https://wiki.oicr.on.ca/display/DCCINT/Appendix+A+-+DCC+Data+Element+Specifications)
donor_donor_id=${donor_donor_id:=1}

specimen_donor_id=${specimen_donor_id:=1}
specimen_specimen_id=${specimen_specimen_id:=2}

sample_specimen_id=${sample_specimen_id:=2}
sample_sample_id=${sample_sample_id:=1}

ssm_m_analyzed_sample_id=${ssm_m_analyzed_sample_id:=2}
ssm_m_matched_sample_id=${ssm_m_matched_sample_id:=3}

# ===========================================================================

function build_join_output_format() {
 file=${1?}
 number_of_fields=$(head -n1 ${file?} | tr "\t" "\n" | wc -l | awk '{print $1}')
 output_format=""
 for i in $(seq 1 ${number_of_fields?}); do
  if [ ${i?} -gt 1 ]; then output_format="${output_format?},"; fi
  output_format="${output_format?}1.${i?}"
 done
 echo ${output_format?}
}

# ===========================================================================

# get the sample ids of interest
echo "analyzed sample IDs"
join -t$'\t' -1 ${sample_sample_id?} -2 ${ssm_m_analyzed_sample_id?} -o "1.${sample_sample_id?}" \
 <(sort -t$'\t' -k${sample_sample_id?},${sample_sample_id?} <(tail -n+2 ${sample_file?})) \
 <(sort -t$'\t' -k${ssm_m_analyzed_sample_id?},${ssm_m_analyzed_sample_id?} <(tail -n+2 ${ssm_m_file?})) > ./tmp/analyzed_sample.id

echo "matched sample IDs"
join -t$'\t' -1 ${sample_sample_id?} -2 ${ssm_m_matched_sample_id?} -o "1.${sample_sample_id?}" \
 <(sort -t$'\t' -k${sample_sample_id?},${sample_sample_id?} <(tail -n+2 ${sample_file?})) \
 <(sort -t$'\t' -k${ssm_m_matched_sample_id?},${ssm_m_matched_sample_id?} <(tail -n+2 ${ssm_m_file?})) > ./tmp/matched_sample.id

# combine analyzed and matched sample ids
echo "sample IDs"
cat ./tmp/analyzed_sample.id ./tmp/matched_sample.id | sort -u > ./tmp/sample.id

# get the specimen ids of interest
echo "specimen IDs"
join -t$'\t' -1 ${sample_sample_id?} -2 1 -o "1.${sample_specimen_id?}" \
 <(sort -t$'\t' -k${sample_sample_id?},${sample_sample_id?} <(tail -n+2 ${sample_file?})) \
 <(sort -t$'\t' -k1,1 ./tmp/sample.id) | sort -u > ./tmp/specimen.id

# get the donor ids of interest
echo "donor IDs"
join -t$'\t' -1 ${specimen_specimen_id?} -2 1 -o "1.${specimen_donor_id?}" \
 <(sort -t$'\t' -k${specimen_specimen_id?},${specimen_specimen_id?} <(tail -n+2 ${specimen_file?})) \
 <(sort -t$'\t' -k1,1 ./tmp/specimen.id) | sort -u > ./tmp/donor.id

# ---------------------------------------------------------------------------

# remove all the donors that are not of interest
echo "donor"
head -n1 ${donor_file?} > ./tmp/donor.tsv
donor_join_output_format=$(build_join_output_format ${donor_file?})
join -t$'\t' -1 ${donor_donor_id?} -2 1 -o "${donor_join_output_format?}" \
 <(sort -t$'\t' -k${donor_donor_id?},${donor_donor_id?} <(tail -n+2 ${donor_file?})) \
 <(sort -t$'\t' -k1,1 ./tmp/donor.id) \
 >> ./tmp/donor.tsv

# remove all the specimens that are not of interest
echo "specimen"
head -n1 ${specimen_file?} > ./tmp/specimen.tsv
specimen_join_output_format=$(build_join_output_format ${specimen_file?})
join -t$'\t' -1 ${specimen_specimen_id?} -2 1 -o "${specimen_join_output_format?}" \
 <(sort -t$'\t' -k${specimen_specimen_id?},${specimen_specimen_id?} <(tail -n+2 ${specimen_file?})) \
 <(sort -t$'\t' -k1,1 ./tmp/specimen.id) \
 >> ./tmp/specimen.tsv

# remove all the samples that are not of interest
echo "sample"
head -n1 ${sample_file?} > ./tmp/sample.tsv
sample_join_output_format=$(build_join_output_format ${sample_file?})
join -t$'\t' -1 ${sample_sample_id?} -2 1 -o "${sample_join_output_format?}"\
 <(sort -t$'\t' -k${sample_sample_id?},${sample_sample_id?} <(tail -n+2 ${sample_file?})) \
 <(sort -t$'\t' -k1,1 ./tmp/sample.id) \
 >> ./tmp/sample.tsv

# ---------------------------------------------------------------------------

head -n3 ./tmp/*.id
echo
head -n3 ./tmp/*.tsv
echo
echo

wc -l ./tmp/*.id
echo
wc -l ./tmp/*.tsv
echo
echo

du -sh ./tmp/*.id
echo
du -sh ./tmp/*.tsv
echo
echo

# replace the files
echo "mv ./tmp/donor.tsv ${donor_file?}"
echo "mv ./tmp/specimen.tsv ${specimen_file?}"
echo "mv ./tmp/sample.tsv ${sample_file?}"

wc -l ${donor_file?} ${specimen_file?} ${sample_file?} ${ssm_m_file?}

# ===========================================================================

