#ifndef ASM_H
#define ASM_H

#include <QString>
#include "asmmodel.h"


namespace StatModel {
class FaceLocator {
public:
    FaceLocator(const char* modelFile,const char* classifierFile);
    FaceLocator(const StatModel::ASMModel& model,const cv::CascadeClassifier &classifier);
    FaceLocator(const FaceLocator& locator);
    std::vector<StatModel::ASMFitResult> fitAll(const cv::Mat &image,int verboseLevel=0);
private:
    StatModel::ASMModel model;
    cv::CascadeClassifier classifier;
};


}

#endif // ASM_H
