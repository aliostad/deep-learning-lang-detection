#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "sampler.h"
#include "synthesiser.h"




MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{


    synthPosition=1;
    ui->setupUi(this);
  //  synthMap = new QSignalMapper;
  //  sampleMap = new QSignalMapper;


}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::changeEvent(QEvent *e)
{
    QMainWindow::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

void MainWindow::on_actionOpen_synthesiser_triggered()
{
    synthPosition++;
    openSynth=synthPosition;
    sy.show();

}

void MainWindow::on_actionOpen_sampler_triggered()
{
    samplePosition++;
    openSample=samplePosition;
    s.show();

}

void MainWindow::onSamplerSave(){
    sampleBlocks[openSample].sampleLocation1.setFileName(s.s.sampleLocation1.fileName());
    sampleBlocks[openSample].sampleLocation2.setFileName(s.s.sampleLocation2.fileName());
    sampleBlocks[openSample].sampleLocation3.setFileName(s.s.sampleLocation3.fileName());
    sampleBlocks[openSample].sampleLocation4.setFileName(s.s.sampleLocation4.fileName());
    sampleBlocks[openSample].sampleLocation5.setFileName(s.s.sampleLocation5.fileName());
    sampleBlocks[openSample].sampleLocation6.setFileName(s.s.sampleLocation6.fileName());
    sampleBlocks[openSample].sampleLocation7.setFileName(s.s.sampleLocation7.fileName());
    sampleBlocks[openSample].sampleLocation8.setFileName(s.s.sampleLocation8.fileName());
    sampleBlocks[openSample].sampleLocation9.setFileName(s.s.sampleLocation9.fileName());
    sampleBlocks[openSample].sampleLocation10.setFileName(s.s.sampleLocation10.fileName());
    sampleBlocks[openSample].sampleLocation11.setFileName(s.s.sampleLocation11.fileName());
    sampleBlocks[openSample].sampleLocation12.setFileName(s.s.sampleLocation12.fileName());
    sampleBlocks[openSample].sampleLocation13.setFileName(s.s.sampleLocation13.fileName());
    sampleBlocks[openSample].sampleLocation14.setFileName(s.s.sampleLocation14.fileName());
    sampleBlocks[openSample].sampleLocation15.setFileName(s.s.sampleLocation15.fileName());
    sampleBlocks[openSample].sampleLocation16.setFileName(s.s.sampleLocation16.fileName());
    for (int x=0; x<17; x++){
        for (int y=0; y<17; y++){
            sampleBlocks[openSample].attributes[x][y]=s.s.attributes[x][y];
        }
    }

}

void::MainWindow::onSynthSave(){
    for (int x=0; x<17; x++){
        for (int y=0; y<17; y++){
            synthBlocks[openSynth].attributes[x][y]=sy.s.attributes[x][y];
        }
    }
}


void::MainWindow::editSampler(int sampleNo){
//open the sampler and set open synth to this one.
    openSample=sampleNo;
    s.show();
}

void::MainWindow::editSynth(int synthNo){
    openSynth=synthNo;
    sy.show();
}

void MainWindow::on_actionEdit_Sampler_Block_triggered()
{
    //d = new editSelect(1);
    d.show();
    connect(d, SIGNAL(selected(int)), this, SLOT(editSampler(int)));
}

void MainWindow::on_actionEdit_Synthesiser_Block_triggered()
{
    //d = new editSelect(0);
    d.show();
    connect(d, SIGNAL(selected(int)), this, SLOT(editSampler(int)));
}
