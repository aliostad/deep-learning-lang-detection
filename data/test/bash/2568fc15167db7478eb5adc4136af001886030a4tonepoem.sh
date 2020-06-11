#!/usr/bin/env zsh


(for theme in "$@" ; do
	wn $theme -hypo{n,v} -hype{n,v} -coor{n,v} -holon 
done ) | 
	egrep -v '^(Sens|[0-9]|Holony|Hypern|Hypon|Synon)' | 
	sed 's/[=-]>//;s/,/\n/g;s/^[ \t]*//g;s/MEMBER OF: //;s/HAS INSTANCE //;s/Coordinate terms (sisters) of verb //' | grep . | 
	sort | uniq | 
	sort -R | head -n 50 | 
	awk '
		{ 
			chunk=chunk " " $0 ; 
			x=rand()*10;
			if (rand()*2 <= 1) {
				for (i=0; i<x; i++) { 
					chunk=chunk " " ;
				}
			} 
			if (rand()*5 <= 1) { 
				print chunk ; 
				chunk="" ; 
			} 
		} END { 
			print chunk ;
		}'
