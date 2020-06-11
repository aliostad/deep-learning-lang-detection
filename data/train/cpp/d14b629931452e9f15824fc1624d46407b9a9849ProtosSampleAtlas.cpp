#include "ProtosSampleAtlas.h"
#include <iostream>

// ------------------------------------------ our inharited interface
Sample* ProtosSampleAtlas::sampleForActionName(std::string actionName) {
    auto filename = sampleFilenames_[actionName];
    return sampleWithFilename(filename);
}

ProtosSampleAtlas::ProtosSampleAtlas() {
    sampleFilenames_["Ping"] = "samples/ping.wav";
    sampleFilenames_["Warp in"] = "samples/warp_in.wav";
    sampleFilenames_["Probe"] = "samples/probe.wav";
}

Sample* ProtosSampleAtlas::sampleWithFilename(std::string fileName) {
    if (samples_.count(fileName) == 0) {
        samples_[fileName] = nullptr;
    }
    return samples_[fileName];
}

ProtosSampleAtlas::~ProtosSampleAtlas() {

}
