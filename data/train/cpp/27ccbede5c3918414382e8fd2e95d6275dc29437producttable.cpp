#include "producttable.h"
#include "ui_producttable.h"

#include "productmodel.h"

ProductTable::ProductTable(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::ProductTable),
    mProductModel(nullptr)
{
    ui->setupUi(this);
}

ProductTable::~ProductTable()
{
    delete ui;
}

void ProductTable::setModel(ProductModel *productModel)
{
    mProductModel = productModel;
    ui->productTableView->setModel(mProductModel);
}

void ProductTable::setSelectionModel(QItemSelectionModel *selectionModel)
{
    ui->productTableView->setSelectionModel(selectionModel);
}
