#include <cstdio>
#include <string>
#include "core/sample.h"

using namespace std;

namespace meh {

Sample::Sample(string filename) {
    aSample = al_load_sample(filename.c_str());
    if (!aSample) { // TODO use a debug system instead of a printf
        printf("ERR: unable to load the sample %s\n",filename.c_str());
    }

    g = 1.0f;
    p = 0.0f;
    s = 1.0f;
    pMode = ONCE;
}

Sample::~Sample() {
    if (aSample)
        al_destroy_sample(aSample);
}

void Sample::play() {
    if (aSample) {
        al_play_sample(aSample,g,p,s,ALLEGRO_PLAYMODE(pMode),&sampleId);
    }
}

void Sample::stop() {
    al_stop_sample(&sampleId);
}

} // namespace meh
