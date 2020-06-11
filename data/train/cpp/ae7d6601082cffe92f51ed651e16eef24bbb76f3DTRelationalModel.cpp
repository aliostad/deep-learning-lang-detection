#include "DTRelationalModel.h"

DTRelationalModel::DTRelationalModel(QObject *parent, QAbstractItemModel *model, int colIndex, int colDisplay) :
    QObject(parent)
{
    setModel(model);
    setColumns(colIndex, colDisplay);
}

void DTRelationalModel::setModel(QAbstractItemModel *model)
{
    mModel = model;
}

QAbstractItemModel * DTRelationalModel::model() const
{
    return mModel;
}

void DTRelationalModel::setColumns(int colIndex, int colDisplay)
{
    mIndexColumn = colIndex;
    mDisplayColumn = colDisplay;
}

int DTRelationalModel::getIndexColumn()
{
    return mIndexColumn;
}

int DTRelationalModel::getDisplayColumn()
{
    return mDisplayColumn;
}
