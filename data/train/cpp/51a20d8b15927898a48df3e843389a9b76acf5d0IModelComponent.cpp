#include "IModelComponent.h"

IModel::IModel(ModelType t):modelType(t), modelFileName(NULL){}
IModel::~IModel(){
//		delete[] modelFileName;
}

void IModel::setModelFile(const char * fileName){
	modelFileName = new char[strlen(fileName)+1];
	strcpy(modelFileName, fileName);
}

void IModel::saveModel(){
	if(modelFileName==NULL) return ;
	FILE *fp = fopen(modelFileName, "wb+");
	if(fp==NULL){
		printf("can not opne file : %s\n", modelFileName);
		exit(1);
	}
	saveModel(fp);
	
	fclose(fp);
}

SuperviseModel::SuperviseModel():IModel(Supervise){}
UnsuperviseModel::UnsuperviseModel():IModel(Unsupervise){}

LayerWiseModel::LayerWiseModel():IModel(Unsupervise){}
