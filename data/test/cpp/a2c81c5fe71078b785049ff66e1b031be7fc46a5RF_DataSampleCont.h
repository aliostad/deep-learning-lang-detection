/*
 * File:   RF_DataSampleCont.h
 * Author: Martin Simon <martiinsiimon@gmail.com>
 */

#ifndef RF_DATASAMPLECONT_H
#define	RF_DATASAMPLECONT_H

#include <vector>
#include "RF_DataSample.h"

using namespace std;

class RF_DataSampleCont {
public:
    RF_DataSampleCont();
    virtual ~RF_DataSampleCont();

    int samplesCount();
    vector<RF_DataSample*>* getSamples();
    RF_DataSample* getSample(int id);
    void addSample(RF_DataSample* s);
    void generateAllChannels();
    void generateChannel(int);
private:
    vector<RF_DataSample*> _data;
};

#endif	/* RF_DATASAMPLECONT_H */

