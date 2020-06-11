#include "testRepository.h"
#include <stdio.h>
void testMRepository(){
	MemRepository repo;
	string errors="";
	Expense e(1, 21, 92, "clothing");
	repo.add(e);
	assert(repo.size()==1);
	Expense e1(2, 23, 440, "telephone");
	repo.add(e1);
	assert(repo.size()==2);
	Expense e2(1, 2, 9, "pizza");
	try{
		repo.add(e2);
	}
	catch(RepositoryException& s)
	{
		errors+=s.getMsg();
	}
	assert(repo.size()==2);
	assert(errors!="");

	repo.update(1,e2);
	vector<Expense*> all=repo.getAll();
	assert(all.at(0)->getDay()==2);
	assert(repo.size()==2);
	Expense e3(3, 44, 29, "others");
	errors="";
	try{
		repo.update(7,e3);
	}
	catch (RepositoryException& s1)
	{
		errors+=s1.getMsg();
	}
	assert(errors!="");

	repo.remove(1);
	assert (repo.size()==1);
	errors="";
	try{
		repo.remove(7);
	}
	catch (RepositoryException& s1)
	{
		errors+=s1.getMsg();
	}
	assert(errors!="");
	assert (repo.size()==1);

	repo.add(e);
	all=repo.filterByDay(23);
	assert(all.size()==1);
	all=repo.filterByAmount(440);
	assert(all.size()==1);

	all=repo.sortByAmountA();
	assert(all.at(0)->getId()==1);
	all=repo.sortByAmountD();
	assert(all.at(0)->getId()==2);
	all=repo.sortByTypeA();
	assert(all.at(0)->getId()==1);
	all=repo.sortByTypeD();
	assert(all.at(0)->getId()==2);
}
