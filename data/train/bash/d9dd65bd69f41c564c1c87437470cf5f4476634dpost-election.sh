#!/bin/bash
# 
# This material is subject to the VoteHere Source Code Evaluation
# License Agreement ("Agreement").  Possession and/or use of this
# material indicates your acceptance of this Agreement in its entirety.
# Copies of the Agreement may be found at www.votehere.net.
# 
# Copyright 2004 VoteHere, Inc.  All Rights Reserved
# 
# You may not download this Software if you are located in any country
# (or are a national of a country) subject to a general U.S. or
# U.N. embargo or are deemed to be a terrorist country (i.e., Cuba,
# Iran, Iraq, Libya, North Korea, Sudan and Syria) by the United States
# (each a "Prohibited Country") or are otherwise denied export
# privileges from the United States or Canada ("Denied Person").
# Further, you may not transfer or re-export the Software to any such
# country or Denied Person without a license or authorization from the
# U.S. government.  By downloading the Software, you represent and
# warrant that you are not a Denied Person, are not located in or a
# national of a Prohibited Country, and will not export or re-export to
# any Prohibited Country or Denied Party.
set -e

# Set-up environment
. ./env.sh

###################
# POST-ELECTION TASKS FOR LEO AND TRUSTEES
###################

# Usage
if test $# -lt 0 ; then
   echo "Usage: post-election.sh [JUST_CLEAN]"
   echo "   JUST_CLEAN = 1 delete old election data and quit"
   exit 2
fi
clean=$1
if test -z $clean ; then
   clean=0
fi

echo -e  "\n"
echo     "====================================================================="
echo     "=============== POST-ELECTION ======================================="
echo     "====================================================================="
echo -e  "\n"


echo     "=============== CLEANING UP OLD TABULATION DATA ====================="
rm -f -r ./transcript/precinct_$VHTI_ELECTION_SAMPLE_EID-$VHTI_ELECTION_SAMPLE_PID/ballotbox*
rm -f -r ./transcript/precinct_$VHTI_ELECTION_SAMPLE_EID-$VHTI_ELECTION_SAMPLE_PID/tabulation*
echo -e  "=============== CLEANING UP OF OLD TABULATION DATA COMPLETE =========\n"
if test $clean -eq 1 ; then
   exit
fi


echo -e  "=============== LEO COMPILE BALLOT BOX =============================="
cd leo
./leo_check_election_config.sh $VHTI_ELECTION_SAMPLE_N
./leo_compile_ballot_box.sh $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
cd ..
echo -e  "=============== LEO COMPILE BALLOT BOX COMPLETE =====================\n"


echo     "=============== TRUSTEE TABULATION PASS 1 ==========================="
cd trustee_1
../trustee/trustee_gen_verification_stmts_1.sh 1 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
../trustee/trustee_shuffle.sh 1 0 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
cd ..
echo ""

cd trustee_2
../trustee/trustee_gen_verification_stmts_1.sh 2 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
../trustee/trustee_shuffle.sh 2 1 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
cd ..
echo ""

cd trustee_3
../trustee/trustee_gen_verification_stmts_1.sh 3 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID

# Since $VHTI_ELECTION_SAMPLE_T = 2, this trustee doesn't have to shuffle or decrypt
#../trustee/trustee_shuffle.sh 3 2 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
cd ..
echo -e  "=============== TRUSTEE TABULATION PASS 1 COMPLETE ==================\n"


echo     "=============== TRUSTEE TABULATION PASS 2 ==========================="
cd trustee_1
../trustee/trustee_gen_verification_stmts_2.sh 1 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
../trustee/trustee_decrypt.sh 1 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
cd ..
echo ""

cd trustee_2
../trustee/trustee_gen_verification_stmts_2.sh 2 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
../trustee/trustee_decrypt.sh 2 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
cd ..
echo ""

cd trustee_3
../trustee/trustee_gen_verification_stmts_2.sh 3 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID

# Since $VHTI_ELECTION_SAMPLE_T = 2, this trustee doesn't have to shuffle or decrypt
#../trustee/trustee_decrypt.sh 3 $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
cd ..
echo -e  "=============== TRUSTEE TABULATION PASS 2 COMPLETE ==================\n"


echo     "=============== LEO TABULATION ======================================"
cd leo
./leo_gen_verification_stmts.sh $VHTI_ELECTION_SAMPLE_VCBITS $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
./leo_gen_revealed_codebooks.sh $VHTI_ELECTION_SAMPLE_N $VHTI_ELECTION_SAMPLE_VCBITS $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
./leo_tabulate.sh $VHTI_ELECTION_SAMPLE_EID $VHTI_ELECTION_SAMPLE_PID
cd ..
echo -e  "=============== LEO TABULATION COMPLETE =============================\n"


echo     "====================================================================="
echo     "=============== POST-ELECTION COMPLETE! ============================="
echo     "====================================================================="
