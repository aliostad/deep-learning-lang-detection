#!/bin/bash
root -l -b << EOF
  TString makeshared(gSystem->GetMakeSharedLib());
  TString dummy = makeshared.ReplaceAll("-W ", "");
  TString dummy = makeshared.ReplaceAll("-Wshadow ", "");
  gSystem->SetMakeSharedLib(makeshared);
  gSystem->Load("libFWCoreFWLite");
  AutoLibraryLoader::enable();
  gSystem->Load("libDataFormatsFWLite.so");
  gSystem->Load("libDataFormatsHepMCCandidate.so");
  gSystem->Load("libDataFormatsCommon.so");
  gSystem->Load("libDataFormatsTrackerRecHit2D.so");
  gSystem->Load("libDataFormatsMETReco.so");
  gSystem->Load("libDataFormatsPatCandidates.so");
  gSystem->Load("libDataFormatsParticleFlowCandidate.so");
  gSystem->Load("libDataFormatsMath.so");
  gSystem->Load("libCMGToolsHtoZZ2l2nu.so");
  .x performanceComparison.C+("ImgDY/H200/", "mumu","H(200)","Z-#gamma^{*}+jets#rightarrow ll", "../../test/plotter.root");
  .x performanceComparison.C+("ImgDY/H300/", "mumu","H(300)","Z-#gamma^{*}+jets#rightarrow ll", "../../test/plotter.root");
EOF                                   
