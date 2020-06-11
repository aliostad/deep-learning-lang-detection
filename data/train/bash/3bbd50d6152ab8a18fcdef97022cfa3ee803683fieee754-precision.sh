#! /bin/sh

# $Id: ieee754-precision.sh,v 1.2 2007/08/26 14:02:04 fredette Exp $

# ic/ieee754/ieee754-precision.sh - emits information about IEEE 754 types
# in a form usable by scripts that automatically generate code:

#
# Copyright (c) 2004 Matt Fredette
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#      This product includes software developed by Matt Fredette.
# 4. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

# get the precision's SoftFloat name, its integral type, its size
# in bytes, any member name for its sign+exponent word, the
# exponent mask for the sign+exponent word, the number of fraction
# bits, and the member names and masks for its fraction chunks:
#
precision=$1
prefix=$2
case $1 in
single) 
    cat <<EOF
${prefix}precision_sf=float32 ;
${prefix}integral=tme_uint32_t ;
${prefix}constant=tme_uint32_t ;
${prefix}size=4 ;
${prefix}sexp= ;
${prefix}mask_exp=0x7f800000 ;
${prefix}fracbits=23 ;
${prefix}implicit=true ;
${prefix}chunk_member_0= ; chunk_mask_0=0x007f0000 ;
${prefix}chunk_member_1= ; chunk_mask_1=0x0000ffff ;
${prefix}chunk_member_2=x ;
EOF
    ;;
double)
    cat <<EOF
${prefix}precision_sf=float64 ;
${prefix}integral='union tme_value64' ;
${prefix}constant='struct tme_ieee754_double_constant' ;
${prefix}size=8 ;
${prefix}sexp=.tme_value64_uint32_hi ;
${prefix}mask_exp=0x7ff00000 ;
${prefix}fracbits=52 ;
${prefix}implicit=true ;
${prefix}chunk_member_0=.tme_value64_uint32_hi ; chunk_mask_0=0x000f0000 ;
${prefix}chunk_member_1=.tme_value64_uint32_hi ; chunk_mask_1=0x0000ffff ;
${prefix}chunk_member_2=.tme_value64_uint32_lo ; chunk_mask_2=0xffff0000 ;
${prefix}chunk_member_3=.tme_value64_uint32_lo ; chunk_mask_3=0x0000ffff ;
${prefix}chunk_member_4=x ;
EOF
    ;;
extended80)
    cat <<EOF
${prefix}precision_sf=floatx80 ;
${prefix}integral='struct tme_float_ieee754_extended80' ;
${prefix}constant='struct tme_ieee754_extended80_constant' ;
${prefix}size=12 ;
${prefix}sexp=.tme_float_ieee754_extended80_sexp ;
${prefix}mask_exp=0x7fff ;
${prefix}fracbits=63 ;
${prefix}implicit=false ;
${prefix}chunk_member_0=.tme_float_ieee754_extended80_significand.tme_value64_uint32_hi ; chunk_mask_0=0xffff0000 ;
${prefix}chunk_member_1=.tme_float_ieee754_extended80_significand.tme_value64_uint32_hi ; chunk_mask_1=0x0000ffff ;
${prefix}chunk_member_2=.tme_float_ieee754_extended80_significand.tme_value64_uint32_lo ; chunk_mask_2=0xffff0000 ;
${prefix}chunk_member_3=.tme_float_ieee754_extended80_significand.tme_value64_uint32_lo ; chunk_mask_3=0x0000ffff ;
${prefix}chunk_member_4=x ;
EOF
    ;;
quad)
    cat <<EOF
${prefix}precision_sf=float128 ;
${prefix}integral='struct tme_float_ieee754_quad' ;
${prefix}constant='struct tme_ieee754_quad_constant' ;
${prefix}size=16 ;
${prefix}sexp=.tme_float_ieee754_quad_hi.tme_value64_uint32_hi ;
${prefix}mask_exp=0x7fff0000 ;
${prefix}fracbits=112 ;
${prefix}implicit=true ;
${prefix}chunk_member_0=.tme_float_ieee754_quad_hi.tme_value64_uint32_hi ; chunk_mask_0=0x0000ffff ;
${prefix}chunk_member_1=.tme_float_ieee754_quad_hi.tme_value64_uint32_lo ; chunk_mask_1=0xffff0000 ;
${prefix}chunk_member_2=.tme_float_ieee754_quad_hi.tme_value64_uint32_lo ; chunk_mask_2=0x0000ffff ;
${prefix}chunk_member_3=.tme_float_ieee754_quad_lo.tme_value64_uint32_hi ; chunk_mask_3=0xffff0000 ;
${prefix}chunk_member_4=.tme_float_ieee754_quad_lo.tme_value64_uint32_hi ; chunk_mask_4=0x0000ffff ;
${prefix}chunk_member_5=.tme_float_ieee754_quad_lo.tme_value64_uint32_lo ; chunk_mask_5=0xffff0000 ;
${prefix}chunk_member_6=.tme_float_ieee754_quad_lo.tme_value64_uint32_lo ; chunk_mask_6=0x0000ffff ;
${prefix}chunk_member_7=x ;
EOF
    ;;
esac

# to avoid integer overflow warnings, make sure that the exponent
# mask is always unsigned:
#
echo ${prefix}'mask_exp="((tme_uint32_t) ${'${prefix}'mask_exp})" ;'

# a mask for the sign bit can be derived from the exponent mask:
#
echo ${prefix}'mask_sign="(${'${prefix}'mask_exp} + _TME_FIELD_MASK_FACTOR(${'${prefix}'mask_exp}))" ; '

# the maximum biased exponent can be derived from the exponent mask:
#
echo ${prefix}'exp_biased_max="(${'${prefix}'mask_exp} / _TME_FIELD_MASK_FACTOR(${'${prefix}'mask_exp}))" ; '

# the exponent bias can be derived from the maximum biased exponent:
#
echo ${prefix}'exp_bias="(${'${prefix}'exp_biased_max} >> 1)" ; '

# make a capitalized version of the precision name:
#
echo ${prefix}'capprecision=`echo ${precision} | tr a-z A-Z` ; '

# done:
#
exit 0;
