// -*- C++ -*-
#ifndef SAMPLE_H
#define SAMPLE_H

#include <string>

enum Process { OTHER, TEST, DATA, WW, WZ, ZZ, VV, We, Wm, Wt, DYee, DYmm, DYtt,
	       ttbar, ttMadgraph, tW, singleTop_tChannel, singleTop_sChannel, 
	       LM0, LM1, LM2, LM2mhfeq360, LM3, LM4, LM5, LM6, LM7, LM8, LM9, LM9p, LM9t175, LM10, LM11, LM12, LM13,
	       InclusiveMuPt15, InclusiveMuPt15dilep,
	       QCDBCtoEPt20to30, QCDBCtoEPt30to80, QCDBCtoEPt80to170, QCDBCtoEPt20to170,
	       QCDEMenrichedPt20to30, QCDEMenrichedPt30to80, QCDEMenrichedPt80to170, QCDEMenrichedPt20to170,
	       QCDpt15, QCDpt30, QCDpt80, QCDpt170, QCDpt1400,
	       photonJetPt20to30, photonJetPt30to50, photonJetPt50to80, photonJetPt80to120, photonJetPt120to170, photonJetPt170to300, photonJetPt20to300,
	       singleElectron, singleGamma};

class TChain;
// struct that contains all the necessary information about a sample
class Sample {
public:
     TChain 		*chain;
     enum Process 	process;
     int		histo_color;
     double		kFactor;
     std::string	name;
     bool               sm;
     double             upper_pthat;
};

Sample operator + (const Sample &, const Sample &);

// make a sample from a shell glob (for example, /data/tmp/cms2/*/*.root)
TChain *makeChain (const char *sample_glob, const char *name = "Events");
Sample fFreeForm (const char *sample_glob, enum Process = OTHER, int histo_color = kBlack, 
		  double kFactor = 1, std::string = "other", bool = 1, double = -1);

// helper functions that provide samples from their default locations
// (takes the guesswork out of data access...)
Sample fTest ();

Sample fdata		   ();
Sample fWW	           ();
Sample fWZ	           ();
Sample fZZ	           ();
Sample fVV		   ();
Sample fWe                 ();
Sample fWmu                ();
Sample fWtau               ();
Sample fWeJets	           ();
Sample fWmJets	           ();
Sample fWtJets	           ();
Sample fZee 	           ();
Sample fZmm 	           ();
Sample fZtt 	           ();
Sample fZeejets            ();
Sample fZmmjets            ();
Sample fZttjets            ();
Sample fttbar	           ();
Sample fttMadgraph         ();
Sample ftW	           ();
Sample fSingleTop_tChannel ();
Sample fSingleTop_sChannel ();
Sample fLM0                ();
Sample fLM1                ();
Sample fLM2                ();
Sample fLM2mhfeq360        ();
Sample fLM3                ();
Sample fLM4                ();
Sample fLM5                ();
Sample fLM6                ();
Sample fLM7                ();
Sample fLM8                ();
Sample fLM9                ();
Sample fLM9p               ();
Sample fLM9t175            ();
Sample fLM10               ();
Sample fLM11               ();
Sample fLM12               ();
Sample fLM13               ();
  
// QCD samples
Sample fInclusiveMuPt15	        ();
Sample fInclusiveMuPt15dilep    ();
Sample fQCDBCtoEPt20to30	();
Sample fQCDBCtoEPt30to80	();
Sample fQCDBCtoEPt80to170	();
Sample fQCDBCtoEPt20to170       ();
Sample fQCDEMenrichedPt20to30	();
Sample fQCDEMenrichedPt30to80	();
Sample fQCDEMenrichedPt80to170  ();
Sample fQCDEMenrichedPt20to170  ();
Sample fQCDpt15                 ();
Sample fQCDpt30                 ();
Sample fQCDpt80                 ();
Sample fQCDpt170                ();
Sample fQCDpt1400               ();

// Photon+jet sampls
Sample fphotonJetPt20to30       ();
Sample fphotonJetPt30to50       ();
Sample fphotonJetPt50to80       ();
Sample fphotonJetPt80to120      ();
Sample fphotonJetPt120to170     ();
Sample fphotonJetPt170to300     ();
Sample fphotonJetPt20to300      ();

// Single particle samples
Sample fsingleElectron ();
Sample fsingleGamma    ();

// filter events by process
bool filterByProcess (enum Process sample);

#endif
