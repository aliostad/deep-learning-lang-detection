#!/bin/bash

function processMetal()
{
	./compose_metal_textures.sh "../../mods/metals/textures/metals_${1}.png" "${1}" ./out "${2}" "${3}" "${4}"
}

cd "$(dirname "$BASH_SOURCE")"

mkdir -p ./out

processMetal adamant		50	5	+tools
processMetal mithril		30	27	+tools
processMetal titan			15	30	+tools
processMetal steel			30	22	+tools
processMetal gold			40	12	notools
processMetal silver			25	20	notools
processMetal zinc			40	12	notools
processMetal aluminium		40	12	notools
processMetal copper			20	20	+tools
processMetal bronze			15	30	+tools
processMetal brass			20	20	+tools
processMetal black_gold		10	35	notools
processMetal green_gold		30	15	notools
processMetal violet_gold	30	15	notools
processMetal rose_gold		33	15	notools
