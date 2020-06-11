#ifndef GITOPENREPODIALOG_H
#define GITOPENREPODIALOG_H

#include <QDialog>
#include <QFileSystemModel>

class GGraphicsScene;

namespace Ui {
class GitOpenRepoDialog;
}

class GitOpenRepoDialog : public QDialog
{
    Q_OBJECT

public:
    explicit GitOpenRepoDialog(QWidget *parent = 0);
    GGraphicsScene* scene;
    QString *path;
    ~GitOpenRepoDialog();

private slots:
    void on_pushButton_clicked();
    void on_treeView_clicked(const QModelIndex &index);


private:
    Ui::GitOpenRepoDialog* ui;
    QFileSystemModel* treeModel;
};

#endif // GITOPENREPODIALOG_H
