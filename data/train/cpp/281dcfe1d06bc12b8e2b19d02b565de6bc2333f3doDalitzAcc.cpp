// author: Jonas Rademacker (Jonas.Rademacker@bristol.ac.uk)
// status:  Mon 9 Feb 2009 19:18:07 GMT
void doDalitzAcc(Int_t seed = 9){
  //
   gSystem->Load("libPhysics.so");
   gSystem->Load("libRooFit.so");
//
  gROOT->LoadMacro("twoDStyle.C");
  gROOT->LoadMacro("histoUtils.C");
  twoDStyle();

  gROOT->LoadMacro("AbsComplexBrackets.C+");
  gROOT->LoadMacro("AbsComplex.C+");
  gROOT->LoadMacro("AbsComplexPdf.C+");
  gROOT->LoadMacro("dataThrowerAway.C+");
  gROOT->LoadMacro("ComplexProxy.C+");
  gROOT->LoadMacro("ComplexBW.C+");
  gROOT->LoadMacro("DcyAmplitude.C+");
  gROOT->LoadMacro("DcyGSAmplitude.C+");
  gROOT->LoadMacro("DcyNonRes.C+");
  gROOT->LoadMacro("DbleAmplitude.C+");
  gROOT->LoadMacro("Resonance.C+");
  gROOT->LoadMacro("ComplexSum.C+");
  gROOT->LoadMacro("ComplexProd.C+");
  gROOT->LoadMacro("RooAbsPhaseSpace.C+");
  gROOT->LoadMacro("Roo3BodyPhaseSpaceAcc.C+");
  gROOT->LoadMacro("Calculate4BodyProps.h+");
  gROOT->LoadMacro("SpinFactorThreeBody.C+");
  gROOT->LoadMacro("SpinFactor.C+");
  gROOT->LoadMacro("SpinFactors.C+");
  gROOT->LoadMacro("BlattWeisskopf.C+");
  gROOT->LoadMacro("DKsPiPiResonances.C+");
  gROOT->LoadMacro("RooM13.C+");    
  gROOT->LoadMacro("fourMxy.C+");
  gROOT->LoadMacro("Roo4BodyPhaseSpace.C+");
  gROOT->LoadMacro("RooDalitz.C+");
  gROOT->LoadMacro("RooBinomiDalitz.C+");
  gROOT->LoadMacro("mark.C+");
  gROOT->LoadMacro("Grahm.C+");


  gROOT->LoadMacro("simpleDalitzAcc.C+");
  simpleDalitzAcc(seed);
   
  cout << "Hey hey" << endl;
  
  gROOT->Reset();
  

   return;
   
}

