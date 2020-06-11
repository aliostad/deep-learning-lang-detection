#include "Controller.h"

Controller::Controller(MemRepository* repo){
	this->repo=repo;
}

void Controller::add(const Expense& e) throw (RepositoryException){
	try {
		this->val.validate(e);
		this->repo->add(e);
	} catch (RepositoryException &s){
		throw RepositoryException(s.getMsg());
	}
}

vector<Expense*> Controller::getAll()const{
	return this->repo->getAll();
}

int Controller::size()const{
	return this->repo->size();
}

Controller::~Controller(){
	delete this->repo;
}

void Controller::remove(int id){
	this->repo->remove(id);
}

void Controller::update(const int id,Expense& e) throw (RepositoryException){
	try{
		this->val.validate(e);
		this->repo->update(id,e);
	} catch (RepositoryException &s){
		throw RepositoryException(s.getMsg());
	}
}

vector<Expense*> Controller::sortByAmountA(){
	return this->repo->sortByAmountA();
}

vector<Expense*> Controller::sortByAmountD(){
	return this->repo->sortByAmountD();
}

vector<Expense*> Controller::sortByTypeA(){
	return this->repo->sortByTypeA();
}

vector<Expense*> Controller::sortByTypeD(){
	return this->repo->sortByTypeD();
}

vector<Expense*> Controller::filterByAmount(int amount){
	return this->repo->filterByAmount(amount);
}

vector<Expense*> Controller::filterByDay(int day){
	return this->repo->filterByDay(day);
}
