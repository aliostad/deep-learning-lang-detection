#include "MyDelegate.h"

#include <QSpinBox>

#include "MyModel.h"


MyDelegate::MyDelegate(QObject *parent /*= 0*/)
    : QStyledItemDelegate(parent)
{

}

void MyDelegate::setEditorData(QWidget *editor, const QModelIndex &index) const
{
    const MyModel* model = static_cast<const MyModel*>(index.model());

    model->SetEditorData(editor, index);
}

void MyDelegate::setModelData(QWidget *editor, QAbstractItemModel *model, const QModelIndex &index) const
{
    MyModel* myModel = static_cast<MyModel*>(model);

    myModel->SetDataFromEditor(editor, index);
}
