#!/bin/bash

BIN_DIR=/phys/groups/tev/scratch3/users/ytchou/monoWZ/CxAODFramework/stack_hists
SAMPLE_DIR=/phys/groups/tev/scratch3/users/ytchou/monoWZ/CxAODFramework/Workdir_13TeV 

mkdir stacked_plots
rm stacked_plots/*
cd stacked_plots
#ttbarall nonall, singletop, Wlv(ev/muv/taumu),Zll, Zvv ,gamma, dijet,monoW,monoH
#$SAMPLE_DIR/hist-gamma.root gamma 1 \
#$SAMPLE_DIR/hist-dijet.root dijet 1 \


$BIN_DIR/stack_hists all_samples Sample \
$SAMPLE_DIR/hist-ttbarallhad.root ttbar_allhad 1 \
$SAMPLE_DIR/hist-ttbarnonall.root ttbar_nonall 1 \
$SAMPLE_DIR/hist-singletop.root singletop 1 \
$SAMPLE_DIR/hist-Wev.root Wev 1 \
$SAMPLE_DIR/hist-Wmuv.root Wmu 1 \
$SAMPLE_DIR/hist-Wtauv.root Wtauv 1 \
$SAMPLE_DIR/hist-Zll.root Zll 1 \
$SAMPLE_DIR/hist-Zvv.root Zvv 1 \
$SAMPLE_DIR/hist-gamma.root gamma 1 \
$SAMPLE_DIR/hist-dijet.root dijet 1 \
$SAMPLE_DIR/hist-monoWjjIsrConD5m50.root monoWjjIsrConD5m50 0 \


cd ..
