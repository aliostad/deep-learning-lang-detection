#!/bin/sh
config_spec=$1
model=$2
label=$3

if [ -z "$config_spec" -o -z "$model" -o -z "$label" ]; then
    echo "usage: create_cs.sh <config_spec> <model> <label>"
    echo "       where: "
    echo "             config_spec = input config spec with appropriate model tags"
    echo "             model       = model to generate output config spec"
    echo "             label       = label name for config spec"
    echo ""
    echo "       e.g.  create_cs.sh ~/XIPCOMBINED.cs XIP913 BRC1"
    echo ""
    echo "       output ->  XIP913_BRC1.cs"
    exit
fi

sed 's/\#>'$2'\#> //' ${config_spec} > ${model}_${label}.cs
sed -i '/#>/d' ${model}_${label}.cs
sed -i '/## XIPDEV/d' ${model}_${label}.cs
sed -i '/## RIGEL/d' ${model}_${label}.cs
sed -i '/## Sanitize/d' ${model}_${label}.cs
