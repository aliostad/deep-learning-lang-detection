#!/bin/bash

BOOST_STAGE_LIB=/Users/gabrielsynnaeve/labs/boost_1_45_0/stage/lib
BOOST_INCLUDE=/Users/gabrielsynnaeve/labs/boost_1_45_0

all: load_cec.cpp load_gmm.cpp
	g++ -arch i386 -I$(BOOST_INCLUDE) load_cec.cpp -L$(BOOST_STAGE_LIB) -lboost_serialization -o load_cec
	g++ -arch i386 -I$(BOOST_INCLUDE) load_gmm.cpp -L$(BOOST_STAGE_LIB) -lboost_serialization -o load_gmm

run: all
	for fn in `ls *.cec`; do DYLD_LIBRARY_PATH=$(BOOST_STAGE_LIB):$(DYLD_LIBRARY_PATH) ./load_cec $$fn; done
	for fn in `ls *.gmm`; do DYLD_LIBRARY_PATH=$(BOOST_STAGE_LIB):$(DYLD_LIBRARY_PATH) ./load_gmm $$fn; done

clean:
	rm -rf ./-* ./:*\
		*.dSYM \
	 	load_cec load_gmm\


