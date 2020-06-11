
#ifndef EA3D_ModelPayload_hpp
#define EA3D_ModelPayload_hpp
#include <iostream>
#include <unordered_map>
#include <string>
using namespace std;
typedef unordered_map<string, unordered_map<string, string>> uuMapss;

class ModelPayload{ //singleton
private:
    //<file name, file path>
    uuMapss modelFilePaths;
    ModelPayload(){}
    static ModelPayload *modelPayload;
    ModelPayload(ModelPayload const&) = delete;    // disable copy constructor
    void operator=(ModelPayload const&) = delete;  // disable assign 
    
public:
    static ModelPayload *getInstance();
    
    const uuMapss &getModelFiles(){return modelFilePaths;}
    void setModelFiles(const uuMapss model){
        this->modelFilePaths = model;
    }
    
    virtual ~ModelPayload(){}

};

#endif
