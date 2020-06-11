#ifndef __scriptToSound__ProtosSampleAtlas__
#define __scriptToSound__ProtosSampleAtlas__

#include "Sample.h"
#include "SampleAtlas.h"
#include <stdio.h>
#include <map>

class ProtosSampleAtlas : public SampleAtlas {
public:
    ProtosSampleAtlas();
    ~ProtosSampleAtlas();
    Sample* sampleForActionName(std::string actionName);
private:
    std::map<std::string, std::string> sampleFilenames_;
    std::map<std::string, Sample*> samples_;
    
    Sample* sampleWithFilename(std::string);
};

#endif /* defined(__scriptToSound__ProtosSampleAtlas__) */
