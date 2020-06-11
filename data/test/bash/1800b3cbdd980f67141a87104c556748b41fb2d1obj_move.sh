#!/bin/bash

[[ "$1" == "" ]] && echo "usage: $0 model.obj <x_delta> <y_delta> <z_delta> new_model.obj" && exit 1;
[[ "$2" == "" ]] && echo "usage: $0 model.obj <x_delta> <y_delta> <z_delta> new_model.obj" && exit 1;
[[ "$3" == "" ]] && echo "usage: $0 model.obj <x_delta> <y_delta> <z_delta> new_model.obj" && exit 1;
[[ "$4" == "" ]] && echo "usage: $0 model.obj <x_delta> <y_delta> <z_delta> new_model.obj" && exit 1;

cat $1 | awk -v dx="$2" -v dy="$3" -v dz="$4" '($0 ~ /^v /){printf("v %.6f %.6f %.6f\n", $2+dx, $3+dy, $4+dz);} ($0 !~ /^v /){print $0;}'
