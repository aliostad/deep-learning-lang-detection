#!/bin/bash

echo LNuAA_BASE=${CMSSW_BASE}/src/LNuAA_Analysis/Analyzers

timestamp=`date | tr ':' '-' | tr ' ' '_'`

### MC samples that do not need I/FSR photon vetos
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_WAA_ISR process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_WH_ZH_125 process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_WWW process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_WWZ process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_WW_2l2nu process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_WWg process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_WZZ process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_WZ_2l2q process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_WZ_3lnu process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_Wgg_FSR process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ZZZ process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ZZ_2e2mu process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ZZ_2e2tau process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ZZ_2l2nu process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ZZ_2l2q process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ZZ_2mu2tau process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ZZ_2q2nu process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ZZ_4e process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ZZ_4mu process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ZZ_4tau process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_Zg process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_diphoton_box_10to25 process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_diphoton_box_250toInf process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_diphoton_box_25to250 process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ggH_125 process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ggZZ_2l2l process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ggZZ_4l process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_t_s process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_t_t process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_t_tW process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_tbar_s process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_tbar_t process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_tbar_tW process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ttW process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ttZ process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ttg process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ttinclusive process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ttjets_1l process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_PileupReweightedAnalysis.py job_summer12_ttjets_2l process_all_${timestamp}/

### MC samples that need I/FSR photon vetos to remove double counting
process_ntuple ${LNuAA_BASE}/python/LNuAA_AnalysisDoubleIFSRVeto.py job_summer12_Wg process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_AnalysisSingleIFSRVeto.py job_summer12_DYJetsToLL process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_AnalysisSingleIFSRVeto.py job_summer12_Wjets process_all_${timestamp}/

### muon data
process_ntuple ${LNuAA_BASE}/python/LNuAA_BasicSelectionAnalysis.py job_electron_2012a_Jan22rereco process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_BasicSelectionAnalysis.py job_electron_2012b_Jan22rereco process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_BasicSelectionAnalysis.py job_electron_2012c_Jan2012rereco process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_BasicSelectionAnalysis.py job_electron_2012d_Jan22rereco process_all_${timestamp}/

###electron data
process_ntuple ${LNuAA_BASE}/python/LNuAA_BasicSelectionAnalysis.py job_muon_2012a_Jan22rereco process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_BasicSelectionAnalysis.py job_muon_2012b_Jan22rereco process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_BasicSelectionAnalysis.py job_muon_2012c_Jan22rereco process_all_${timestamp}/
process_ntuple ${LNuAA_BASE}/python/LNuAA_BasicSelectionAnalysis.py job_muon_2012d_Jan22rereco process_all_${timestamp}/

