#include "window.h"

window::window(repository *repo) {
    this->repo = repo;
    this->setFixedSize(550,350);

    QVBoxLayout *mainlayout = new QVBoxLayout(this);

    QVBoxLayout *inputtable = new QVBoxLayout;

    repo->aktie.setFixedWidth(111);
    repo->timerange.setFixedWidth(25);
    QLabel *aktietext = new QLabel;
    aktietext->setText("Aktie:");
    QLabel *texttimerange = new QLabel;         
    texttimerange->setText("Zeitspanne:");  
    repo->timerangeunit.addItem(tr("Tage"));
    repo->timerangeunit.addItem(tr("Monate"));
    repo->timerangeunit.addItem(tr("Jahre"));
    repo->timerangeunit.setFixedWidth(80);
    repo->aktie.setText("^GDAXI");
    repo->timerange.setText("5");
    QPushButton *GoButton = new QPushButton("GO");
    GoButton->setMaximumWidth(112);
    
    this->renew(); 
    
    connect(GoButton,SIGNAL(clicked()),this,SLOT(renew()));


    QHBoxLayout *firstinputline = new QHBoxLayout;
    QHBoxLayout *secondinputline = new QHBoxLayout;
    QHBoxLayout *thirdinputline = new QHBoxLayout;

    //1.line
    inputtable->addLayout(firstinputline, 0);
    firstinputline->addStretch(1);
    firstinputline->addWidget(aktietext, 0);
    firstinputline->addWidget(&repo->aktie, 1);

    
    
    //2.line
    inputtable->addLayout(secondinputline, 1);
    secondinputline->addStretch(1);
    secondinputline->addWidget(texttimerange, 0);
    secondinputline->addWidget(&repo->timerange, 1);
    secondinputline->addWidget(&repo->timerangeunit,2);

   
    //3.line
    inputtable->addLayout(thirdinputline, 2);
    thirdinputline->addStretch(2);
    thirdinputline->addWidget(GoButton, 2);


    mainlayout->addLayout(inputtable, 0);
    mainlayout->addStretch(0);
    mainlayout->addWidget(&repo->view, 1); //diagram


};

char window::timerangeletter(){
    
    if(repo->timerangeunit.currentText()=="Monate")return 'm';
    else if(repo->timerangeunit.currentText()=="Jahre")return 'y';
    else if(repo->timerangeunit.currentText()=="Tage")return 'd';
    return 'd';
};

QString window::url(){
    return ("http://ichart.finance.yahoo.com/instrument/1.0/"+repo->aktie.text()+"/chart;range="+repo->timerange.text()+timerangeletter()+"/image;size=260x115");
};

void window::renew(){
    
    repo->htmlcode="<img src=\""+url()+"\" width=520>";
    
    repo->view.setHtml(repo->htmlcode);
};