#ifndef REPOWINDOW_H
#define REPOWINDOW_H

#include <QMainWindow>
#include <QPointer>
#include <QTimer>

class Repository;

namespace Ui {
class RepoWindow;
}

class RepoWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit RepoWindow(Repository *repo, QWidget *parent = 0);
    ~RepoWindow();

public slots:
    void refresh();
    void setNumCopies();

private slots:
    void setGitAnnexAutostarted(bool autostarted);

private:
    static bool isGitAnnexAutostarted();

private:
    Ui::RepoWindow      *ui;
    QPointer<Repository> repo;
    //QTimer               refreshTimer;
    int                  oldNumCopies;
};

#endif // REPOWINDOW_H
