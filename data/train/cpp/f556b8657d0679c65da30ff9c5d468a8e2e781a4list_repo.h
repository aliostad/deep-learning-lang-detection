#ifndef LIST_REPO_H
#define LIST_REPO_H

#include <QDialog>
#include <QFileSystemModel>

namespace Ui {
class List_repo;
}

class List_repo : public QDialog
{
    Q_OBJECT

public:
    explicit List_repo(QWidget *parent = 0);
    ~List_repo();

    void set_file(QString *in)
    {
        file = in;
    }
private slots:
    void on_pushButton_clicked();

    void on_treeView_clicked(const QModelIndex &index);

    void on_pushButton_2_clicked();

private:
    Ui::List_repo *ui;

    QFileSystemModel *model;
    /** absolute path + filename */
    QString * file;
};

#endif // LIST_REPO_H
