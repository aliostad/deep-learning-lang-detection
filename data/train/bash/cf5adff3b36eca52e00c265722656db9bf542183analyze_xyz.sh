#!/bin/bash


POOL1=5281
POOL2=5282
POOL3=5283
POOL4=5284

while read PORT CHUNK
do

TABLE=object_${CHUNK}_xyz

echo == ANALYZING ${TABLE} on port ${PORT} ==
    

psql -p ${PORT} postgres << EOF

ANALYZE ${TABLE} ;

EOF

TABLE=source_${CHUNK}_xyz

echo == ANALYZING ${TABLE} on port ${PORT} ==

psql -p ${PORT} postgres << EOF

ANALYZE ${TABLE} ;

EOF

done << EOF
   ${POOL3}   001
   ${POOL1}   002
   ${POOL1}   003
   ${POOL4}   004
   ${POOL2}   005
   ${POOL3}   006
   ${POOL2}   007
   ${POOL4}   008
   ${POOL1}   009
   ${POOL2}   010
   ${POOL3}   011
   ${POOL3}   012
   ${POOL3}   013
   ${POOL1}   014
   ${POOL3}   015
   ${POOL4}   016
   ${POOL2}   017
   ${POOL3}   018
EOF




