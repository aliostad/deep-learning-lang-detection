if [ $# -ne 1 ];then
  echo "You need to provide just one argument : the complete path to UATree/UADataFormat/src"
  echo "Example : source createBuildLibDico.sh /user/toto/CMSSW_0_0_0/src/UATree/UADataFormat/src"
  return
fi

if [ ! -d $1 ];then
  echo "$1 doesn't exist. Please provide a real directory !"
  return
fi

if [ -f BuildLibDico.cc ];then
  rm BuildLibDico.cc
fi


echo "{" > BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyPart.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyBaseJet.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyJet.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyTracks.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyVertex.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyBeamSpot.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyCaloJet.cc+\");"		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyCastorDigi.cc+\");" 	>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyCastorJet.cc+\");" 	>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyCastorRecHit.cc+\");" 	>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyDiJet.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyElectron.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyEvtId.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyFwdGap.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyGenKin.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyGenMet.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyGenPart.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyGenJet.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyHLTrig.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyL1Trig.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyL1TrigOld.cc+\");" 	>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyMITEvtSel.cc+\");" 	>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyMet.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyMuon.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyPFCand.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyPFJet.cc+\");" 		>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MyPUSumInfo.cc+\");" 	>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/MySimVertex.cc+\");" 	>> BuildLibDico.cc
echo "  gROOT->ProcessLine(\".L $1/LinkDef.cc+\");" 		>> BuildLibDico.cc
echo "}" >> BuildLibDico.cc
