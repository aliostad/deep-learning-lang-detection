#include "chart.h"
#include "ui_chart.h"

chart::chart(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::chart)
{
    this->initializeModel(&model);
    ui->setupUi(this);
    ui->thetablething->setModel(&model);
}

chart::~chart()
{
    delete ui;
}

void chart::initializeModel(QSqlRelationalTableModel *model)
{
    model->setTable("transactions");
    model->setEditStrategy(QSqlRelationalTableModel::OnRowChange);
    if (!model->select())
    {
        qDebug() << "Selecting splits..." << model->lastError();
    }

    int numRows = model->rowCount();
    model->removeColumn(0);
    model->setHeaderData(0, Qt::Horizontal, "Currency");
    model->setRelation(0,QSqlRelation("currency","guid","fullname"));
    model->insertRows(numRows,1);
}
