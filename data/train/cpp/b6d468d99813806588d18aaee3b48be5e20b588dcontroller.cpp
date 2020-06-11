#include "controller.h"

bool lessThan(Dvd* one, Dvd* two){
    return one->getTitle() < two->getTitle();
}

Controller::Controller(DvdRepository *dvdRepo, LoanRepository *loanRepo)
{
    this->dvdRepo = dvdRepo;
    this->loanRepo = loanRepo;
}

QList<Dvd*> Controller::getAllDvds(){
    return this->dvdRepo->getAllDvds();
}

QList<Dvd*> Controller::getAllSortedDvds(){
    QList<Dvd*> allDvds = this->dvdRepo->getAllDvds();
    qSort(allDvds.begin(), allDvds.end(), lessThan);
    return allDvds;
}

QList<Loan*> Controller::getAllLoans(){
    return this->loanRepo->getAll();
}

void Controller::addLoan(int id, QString name){
    Loan* loan = new Loan(name, id);
    this->loanRepo->addLoan(loan);
}

void Controller::removeLoan(int id){
    this->loanRepo->removeLoan(id);
}
