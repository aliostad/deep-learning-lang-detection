#include "repoedit.h"
#include "ui_repoedit.h"

repoEdit::repoEdit(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::repoEdit) {
    qInfo() << "repoEdit::repoEdit: constructor";
    ui->setupUi(this);
    this->setWindowFlags(this->windowFlags().operator ^=(Qt::WindowContextHelpButtonHint));
}

repoEdit::~repoEdit()
{
    delete ui;
}

// Получение данных из главного окна
// и заполнение виджетов новой информацией
void repoEdit::recieveData(Repository repo, int currentRow, bool newRepo) {
    qInfo() << "repoEdit::recieveData: start";

    // Применение полученной информации
    newR = newRepo;
    Row = currentRow;
    if(newRepo) {
        ui->repoName->setText(tr("Новый репозиторий"));
        ui->repoType->setCurrentIndex(0);
        ui->repoUrl->clear();
    } else {
        ui->repoName->setText(repo.name);
        ui->repoType->setCurrentIndex(repo.type);
        ui->repoUrl->setText(repo.url);
    }
    this->open();
}

// Изменение типа репозитория
void repoEdit::on_repoType_currentIndexChanged(int index) {
    qInfo() << "repoEdit::on_repoType_currentIndexChanged: index " << index;

    if(index == 0)
        ui->label->setText(tr("Url сервера Yoma Addon Sync должен заканчиваться на .7z и начинаться с http:// или ftp://"));
    else
        ui->label->setText(tr("Url сервера ArmA3Sync должен заканчиваться на .a3s/autoconfig и начинаться с http:// или ftp://"));
}

// Отправка измененных данных в главное окно
void repoEdit::on_saveButton_clicked() {
    qInfo() << "repoEdit::on_saveButton_clicked: start";

    QString url = ui->repoUrl->text();
    if(ui->repoType->currentIndex() == 0) {
        if(!(url.startsWith("http://") || url.startsWith("ftp://")) && !url.endsWith(".7z")) {
            QMessageBox::warning(this,tr("Внимание!"), tr("Некорректный Url сервера.\nUrl сервера Yoma Addon Sync должен заканчиваться\nна .7z и начинаться с http:// или ftp://"), QMessageBox::Ok);
            return;
        }
    } else {
        if(!(url.startsWith("http://") || url.startsWith("ftp://")) && !url.endsWith(".a3s/autoconfig")) {
            QMessageBox::warning(this,tr("Внимание!"), tr("Некорректный Url сервера.\nUrl сервера ArmA3Sync должен заканчиваться\nна .a3s/autoconfig и начинаться с http:// или ftp://"), QMessageBox::Ok);
            return;
        }
    }
    qInfo() << "repoEdit::repoEdit: Send start";
    Repository repo;
    repo.name = ui->repoName->text();
    repo.type = ui->repoType->currentIndex();
    repo.url = ui->repoUrl->text();
    emit sendData(repo, Row, newR);
    this->close();
}
