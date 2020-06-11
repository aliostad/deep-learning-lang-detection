#include <QString>
#include <QtTest>

#include <QStandardItemModel>
#include <QStandardItem>
#include <QList>
#include <QDebug>
#include <modeltest.h>
#include "tst_proxymodel.h"

namespace ProxyModel{

Test::Test()
{
    EmptyModel = new QStandardItemModel;
    EmptyProxy = ProxyModel::Factory::produce(this);
    EmptyProxy->setSourceModel(EmptyModel);
    QStandardItemModel* model = new QStandardItemModel;
    model->setColumnCount(3);
    model->setRowCount(3);
    model->setData(model->index(0,0), 1);
    model->setData(model->index(0,1), 1);
    model->setData(model->index(0,2), "Root 1");
    model->setData(model->index(1,0), 2);
    model->setData(model->index(1,1), 1);
    model->setData(model->index(1,2), "Child");
    model->setData(model->index(2,0), 3);
    model->setData(model->index(2,1), 3);
    model->setData(model->index(2,2), "Root 2");
    PlainModel = model;    
    PlainProxy = ProxyModel::Factory::produce(this);
    PlainProxy->setSourceModel(PlainModel);

    model = new QStandardItemModel;
    model->setColumnCount(3);
    model->setRowCount(1);
    model->setData(model->index(0,0), 1);
    model->setData(model->index(0,1), 1);
    model->setData(model->index(0,2), "Root 1");
    model->item(0,0)->setChild(0, 0, new QStandardItem("2"));
    model->item(0,0)->setChild(0, 1, new QStandardItem("1"));
    model->item(0,0)->setChild(0, 2, new QStandardItem("Child"));

    model->item(0,0)->child(0,0)->setChild(0, 0, new QStandardItem("3"));
    model->item(0,0)->child(0,0)->setChild(0, 1, new QStandardItem("3"));
    model->item(0,0)->child(0,0)->setChild(0, 2, new QStandardItem("Root 2"));

    HierarchyModel = model;
    HierarchyProxy = ProxyModel::Factory::produce(this);
    HierarchyProxy->setSourceModel(HierarchyModel);
}

void Test::nullSource()
{
    ProxyModel::Pointer model = ProxyModel::Factory::produce(this);
    Model::Test::Helper helper(model);
}

void Test::emptySource()
{
    Model::Test::Helper helper(EmptyProxy);
}

void Test::plainSource()
{
    Model::Test::Helper helper(PlainProxy);
}

void Test::hierarchySource()
{
    Model::Test::Helper helper(HierarchyProxy);
}
}
