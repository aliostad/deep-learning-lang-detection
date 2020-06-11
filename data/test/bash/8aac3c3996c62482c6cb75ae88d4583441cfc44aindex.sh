#!/bin/bash

while read PORT CHUNK
do
psql -p ${PORT} postgres << EOF

CREATE INDEX object_${CHUNK}_xyz_idx ON Object_${CHUNK}
USING btree ((cos(radians(ra_PS))*cos(radians(decl_PS))),
             (sin(radians(ra_PS))*cos(radians(decl_PS))),
             (sin(radians(decl_PS))));

CLUSTER Object_${CHUNK} USING object_${CHUNK}_xyz_idx ;

CREATE INDEX source_${CHUNK}_xyz_idx ON Source_${CHUNK}
USING btree ((cos(radians(ra))*cos(radians(decl))),
             (sin(radians(ra))*cos(radians(decl))),
             (sin(radians(decl))));

CLUSTER Source_${CHUNK} USING source_${CHUNK}_xyz_idx ;

EOF
done << EOF
5281  000
5282  001
5283  002
5284  003
EOF
