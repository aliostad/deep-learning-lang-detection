#include "qtdialog.h"

#include <cassert>

#include "mymodel.h"
#include "ui_qtdialog.h"

QtDialog::QtDialog(QWidget *parent) :
  QDialog(parent),
  ui(new Ui::QtDialog)
{
  ui->setupUi(this);

  MyModel * const model = new MyModel(this);

  assert(model);
  ui->table_left->setModel(model);
  ui->table_right->setModel(model);
  assert(ui->table_left->model());
  assert(ui->table_right->model());
  assert(ui->table_left->model() == model);
  assert(ui->table_right->model() == model);
}

QtDialog::~QtDialog()
{
  delete ui;
}
