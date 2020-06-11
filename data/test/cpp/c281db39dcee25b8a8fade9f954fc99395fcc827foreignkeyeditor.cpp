#include "foreignkeyeditor.h"

#include "Model/TableModel/model.h"
#include "Model/factory.h"

namespace View
{
    ForeignKeyEditor::ForeignKeyEditor(QWidget *parent) :
        QComboBox(parent)
    {

    }

    void ForeignKeyEditor::setForeignKey(Model::TableModel::ModelForeignKey foreignKey){
        mForeignKey=foreignKey;

        Model::TableModel::Model* model=mForeignKey.getModel();

        insertItem(0, "choisir ligne", 0);
        for(int i=1;i<model->rowCount()+1;i++){
            int id=model->id(i-1);
            insertItem(i, model->getRowName(id), id);
        }
        setCurrentIndex(model->rowIndexFromId(foreignKey.getId()));
    }

    Model::TableModel::ModelForeignKey ForeignKeyEditor::getForeignKey(){
        mForeignKey.setId(currentData().toInt());
        return mForeignKey;
    }
}
