#ifndef SAMPLE_INFOINPUT_H
#define SAMPLE_INFOINPUT_H

#include <QDialog>
#include <QString>
#include "ui_sample_infoinput.h"
struct Info_Sample
{
    QString Sample_Num;
    QString Sample_Name;
    QString Sample_From;
    QString Sample_Unit;
    QString Test_Name;
    QString Test_Unit;
};

namespace Ui {
    class sample_infoinput;
}

class sample_infoinput : public QDialog,public Ui::sample_infoinput
{
    Q_OBJECT

public:
    explicit sample_infoinput(QWidget *parent = 0);
    ~sample_infoinput();
public:
   struct Info_Sample SampleInfo;
signals:
   void transStrToDlg(struct Info_Sample);

private slots:
    void on_Btn_Quit_clicked();
    void on_Btn_Save_clicked();
};

#endif // SAMPLE_INFOINPUT_H
