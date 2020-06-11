#ifndef JACOBUTILS_SAMPLELIST_H_
#define JACOBUTILS_SAMPLELIST_H_ 1
#include <map>
#include <string>

#include "TNamed.h"

class TFile;

namespace ST {
class SampleList {
 public:
  SampleList(const std::string& path);
  SampleList(TFile* path);

  std::string GetPath(const std::string& name);

  void AddSample(const std::string& sample, const std::string& path);
  void RemoveSample(const std::string& sample);
  void Write(void);
  void Print(void);
  ~SampleList();

 private:
  bool IsPresent(const std::string& name) {
    return ((*sampleMap).find(name) == (*sampleMap).end());
  }

 private:
  TFile* dataset;
  typedef std::map<std::string, std::string> SampleMap;
  SampleMap* sampleMap;
#ifdef __CINT__
  ClassDef(ST::SampleList, 1)
#endif
};
}

#endif