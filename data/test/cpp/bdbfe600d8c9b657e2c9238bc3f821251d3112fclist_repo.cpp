#include "list_repo.h"
#include "ui_list_repo.h"

#include <QStringList>
#include <QDir>
#include <QDebug>
#include <QDirModel>


List_repo::List_repo(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::List_repo)
{
    ui->setupUi(this);
    model = new QFileSystemModel;
    QStringList filters;
    filters << "*.xml";
    QDirModel *repModele = new QDirModel;
    model->setNameFilters(filters);
    model->setRootPath(QDir::currentPath());
    ui->treeView->setModel(model);
    ui->treeView->setRootIndex(model->index("/"));
    ui->treeView->setCurrentIndex(model->index(QDir::currentPath()));
    ui->treeView->setColumnWidth(0,400);
}

List_repo::~List_repo()
{
    delete ui;
}

void List_repo::on_pushButton_clicked()
{
    qDebug()<<"clic sur ouvrir = "<< *file;
    close();
}

void List_repo::on_treeView_clicked(const QModelIndex &index)
{
      *file = model->filePath(index);
}

void List_repo::on_pushButton_2_clicked()
{
    *file = "";
    close();
}
