/* 
 * File:   Sample.cpp
 * Author: haikalpribadi
 * 
 * Created on 09 March 2014, 15:00
 */

#include "Sample.h"

Sample::Sample() {
}

Sample::Sample(string sname) {
    name = sname;
}

void Sample::setSample(string filename) {
    sampleFile = filename;
}

void Sample::setCollection(string filename) {
    collectionFile = filename;
}

void Sample::setFeature(string filename) {
    featureFile = filename;
}

void Sample::setFeatureNorm(string filename) {
    featureNormFile = filename;
}

void Sample::addGestureFile(string filename) {
    gestureFiles.push_back(filename);
}