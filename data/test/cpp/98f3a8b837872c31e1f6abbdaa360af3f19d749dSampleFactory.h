#ifndef __HZZWS_SAMPLEFACTORY_H__
#define __HZZWS_SAMPLEFACTORY_H__


#include "Hzzws/SampleBase.h"
#include "Hzzws/SampleHist.h"
#include "Hzzws/SampleKeys.h"
#include "Hzzws/CBGauss.h"
#include "Hzzws/ParametrizedSample.h"
#include "Hzzws/ExpLandau.h"
#include "Hzzws/AnalyticHMBkg.h"
#include "Hzzws/Helper.h"
#include <map>

typedef SampleBase* (*SBConstructor)(strvec&);

namespace SampleFactory{

  // If you wish to add a new sample type, follow the pattern to add it here, and in Root/SampleFactory.cxx
  // Any questions? Please contact graham.cree@cern.ch, xiangyang.Ju@cern.ch


  SampleBase* FactorySampleCount(strvec& args);
  SampleBase* FactorySampleHist(strvec& args);
  SampleBase* FactorySampleKeys(strvec& args);
  SampleBase* FactoryCBGauss(strvec& args);
  SampleBase* FactoryParametrizedSample(strvec& args);
  SampleBase* FactoryExpLandau(strvec& args);
  SampleBase* FactoryAnalyticHMBkg(strvec& args);
  // SampleBase* FactoryYourSampleType(strvec& args);

  SampleBase* CreateSample(std::string& type, strvec& args);



  bool AddKeysSample(SampleBase*, strvec& args);

  strvec& Categories(strvec* in=NULL);
}

#endif
