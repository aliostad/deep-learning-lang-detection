#include "view.h"

#include "View/analyze_csv.h"
#include "View/load_csv.h"
#include "View/mainwindow.h"
#include "View/verify_csv.h"
#include "CSV-Data/csvtype.h"

using namespace std;

View::View()
{
    m = new MainWindow();

    this->setGeometry(10,30,1060,700);

    this->insertWidget(0, m);
    this->show();

    load = new LoadCSV();
    this->insertWidget(1, load);

    verify = new VerifyCSV();
    this->insertWidget(2, verify);

    analyze = new AnalyzeCSV();
    this->insertWidget(3, analyze);


    connect(m, SIGNAL(gotoLoad(std::string)), this, SLOT(mainToLoad(std::string)));
    connect(load, SIGNAL(gotoVerify(CSVType)), this, SLOT(gotoVerify(CSVType)));
    connect(load, SIGNAL(gotoAnalyze(CSVType)), this, SLOT(gotoAnalyze(CSVType)));
    connect(load, SIGNAL(gotoAnalyze()), this, SLOT(gotoAnalyze()));
    connect(verify, SIGNAL(gotoLoad(ErrorType,CSVType)), this, SLOT(verToLoad(ErrorType,CSVType)));
    connect(verify, SIGNAL(gotoAnalyze(CSVType)), this, SLOT(gotoAnalyze(CSVType)));
    connect(analyze, SIGNAL(gotoLoad()), this, SLOT(gotoLoad()));
}

View::~View(){
    if(m != 0) delete m;
    if(load != 0) delete load;
    if(analyze != 0) delete analyze;
    if(verify != 0) delete verify;
}

void View::gotoAnalyze(){
    this->setCurrentIndex(3);
    analyze->doneloading();
}

void View::gotoAnalyze(CSVType t){
    this->setCurrentIndex(3);
    analyze->loadTab(t);
    analyze->doneloading();
}

void View::gotoLoad(ErrorType t){
    this->setCurrentIndex(1);
    load->setError(t);
    load->setDefaultBtnTxt();
}

void View::verToLoad(ErrorType t, CSVType ct){
    analyze->loadTab(ct);
    gotoLoad(t);
}

void View::gotoVerify(CSVType t){
    this->setCurrentIndex(2);
    verify->updateTable(t);
}

void View::mainToLoad(string){
    gotoLoad(NONE);
}

void View::gotoLoad(){
    gotoLoad(NONE);
}
