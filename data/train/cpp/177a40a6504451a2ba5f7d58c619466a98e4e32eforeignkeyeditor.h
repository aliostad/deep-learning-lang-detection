#ifndef VIEWFOREIGNKEYEDITOR_H
#define VIEWFOREIGNKEYEDITOR_H

#include "Model/TableModel/modelforeignkey.h"

#include <QComboBox>

namespace View
{
    class ForeignKeyEditor : public QComboBox
    {
        Q_OBJECT
    public:
        explicit ForeignKeyEditor(QWidget *parent = 0);

        void setForeignKey(Model::TableModel::ModelForeignKey foreignKey);
        Model::TableModel::ModelForeignKey getForeignKey();

    private:
        Model::TableModel::ModelForeignKey mForeignKey;

    };
}

#endif // VIEWFOREIGNKEYEDITOR_H
