#include "loadscientistsfromfiledialog.h"
#include "ui_loadscientistsfromfiledialog.h"

using namespace std;

LoadScientistsFromFileDialog::LoadScientistsFromFileDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::LoadScientistsFromFileDialog)
{
    ui->setupUi(this);
    load = false;
}

LoadScientistsFromFileDialog::~LoadScientistsFromFileDialog()
{
    delete ui;
}

//Loads the file and closes the dialog
void LoadScientistsFromFileDialog::on_ButtonLoad_clicked()
{
    file = ui->InputForTextFileName->text().toStdString();
    load = true;
    this->close();
}

//Load cancelled and dialog closed
void LoadScientistsFromFileDialog::on_ButtonCancel_clicked()
{
    this->close();
}

bool LoadScientistsFromFileDialog::getLoad()
{
    return load;
}

string LoadScientistsFromFileDialog::getFile()
{
    return file;
}

//If enter is pressed the file will be loaded
void LoadScientistsFromFileDialog::on_InputForTextFileName_returnPressed()
{
    on_ButtonLoad_clicked();
}
