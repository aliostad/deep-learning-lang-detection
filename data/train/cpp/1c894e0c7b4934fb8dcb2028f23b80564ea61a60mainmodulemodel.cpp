#include "mainmodulemodel.h"
//#include <datasetmodel.h>
#include <registry.h>

MainModuleModel::MainModuleModel()
{

}

MainModuleModel::~MainModuleModel(){
//    while(!Models.empty()){
//        ModelCollection::Iterator item = Models.begin();
//        delete item.value();
//        Models.erase(item);
//    }
}

//QAbstractItemModel* MainModuleModel::objectModel(const QMetaObject* type){
//    QAbstractItemModel* result = NULL;
//    ModelCollection::Iterator found = Models.find(type);
//    if(found != Models.end()){
//        result = found.value();
////    }else{
////        ObjectCollectionModel* model = new ObjectCollectionModel;
////        model->setSource(Registry::objects(type));
////        result = model;
//    }
//    return result;
//}

//void MainModuleModel::registerModel(const QMetaObject* type, QAbstractItemModel* model){
//    if(!Models.contains(type)){
//        Models.insert(type, model);
//    }
//}
