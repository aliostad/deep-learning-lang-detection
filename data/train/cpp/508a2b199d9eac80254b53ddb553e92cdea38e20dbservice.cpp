#include "DbService.h"

DbService::DbService()
{
    scientistRepo = ScientistRepository();
    computerRepo = ComputerRepository();
    connectRepo = ConnectRepository();
}

void DbService::addS(Scientist s)
{
    scientistRepo.add(s);
}

void DbService::addC(Computer c)
{
    computerRepo.add(c);
}

void DbService::addID(int scientist_id, int computer_id)
{
    connectRepo.add(scientist_id, computer_id);
}

list <Scientist> DbService::get_allScientists()
{
    return scientistRepo.get_allscientists();
}

list<Computer> DbService::get_allComputers()
{
    return computerRepo.get_allcomputers();
}

list<Connect> DbService::get_allconnections()
{
    return connectRepo.get_allconnections();
}

list <Scientist> DbService::sort_scientists(int col, int mod)
{
    return scientistRepo.sort_function(col, mod);
}

list<Computer> DbService::sort_computers(int col, int mod)
{
    return computerRepo.sort_function(col,mod);
}

list <Scientist> DbService::search_scientists(string s)
{
    return scientistRepo.search_function(s);
}

list<Computer> DbService::search_computers(string s)
{
    return computerRepo.search_function(s);
}
