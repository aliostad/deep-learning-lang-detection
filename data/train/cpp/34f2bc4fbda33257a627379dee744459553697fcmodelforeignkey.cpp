#include "modelforeignkey.h"

#include "modelrow.h"
#include "model.h"

#include <iostream>
using namespace std;

namespace Model
{
    namespace TableModel
    {
        ModelForeignKey::ModelForeignKey(const ModelForeignKey& foreignKey):
            ModelForeignKey(foreignKey.mModel, foreignKey.mId)
        {
        }

        ModelForeignKey::ModelForeignKey():
            ModelForeignKey(NULL, -1)
        {
        }

        ModelForeignKey::ModelForeignKey(Model* model, int id):
            mModel(NULL),
            mId(0)
        {
            init(model, id);
        }

        ModelForeignKey::~ModelForeignKey(){
            deleteReference();
        }

        void ModelForeignKey::init(Model* model, int id){
            deleteReference();
            mModel=model;
            mId=id;

            addReference();
        }

        bool ModelForeignKey::setId(int id){
            if(mModel==NULL){
                return false;
            }
            deleteReference();
            mId=id;
            addReference();
            return true;
        }

        int ModelForeignKey::getId()  const{
            if(mModel==NULL){
                return -1;
            }
            return mId;
        }
        Model* ModelForeignKey::getModel() const{
            return mModel;
        }

        ModelForeignKey& ModelForeignKey::operator=(const ModelForeignKey& source){
            init(source.mModel, source.mId);
            return *this;
        }

        void ModelForeignKey::addReference(){
            if(mModel!=NULL && mId!=0){
                ModelRow* row=mModel->rowFromId(mId);
                if(row!=NULL){
                    row->addReference();
                }
            }
        }

        void ModelForeignKey::deleteReference(){
            if(mModel!=NULL && mId!=0){
                ModelRow* row=mModel->rowFromId(mId);
                if(row!=NULL){
                    row->deleteRefence();
                }
            }
        }
    }
}
