#include <primitives/ModelDatabase.h>

ModelDatabase::ModelDatabase() {
}

ModelDatabase::~ModelDatabase() {
    modelReferences.clear();
    for(unsigned int i = 0; i< models.size();i++){
        delete models.at(i);
    }
    models.clear();
    
}

int ModelDatabase::isKnownModel(string _path){
    
    if(modelReferences.find(_path) == modelReferences.end()){
        return -1;
    }else{
        return modelReferences[_path];
    }
}

int ModelDatabase::addModel(IndexedModel* _model, string _path){
    
    if (isKnownModel(_path)==-1){
        int ci = models.size();
        models.push_back(_model);
        modelReferences[_path] = ci;
        return ci;
    }else{
        return modelReferences[_path];
    }
    
}

IndexedModel* ModelDatabase::getModel(int _index){
    return models[_index];
}