#include "Services/dbservice.h"

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

list<Connect> DbService::get_allConnections()
{
    return connectRepo.get_allconnections();
}

list <Scientist> DbService::sort_scientists(int col, int mod)
{
    return scientistRepo.sort_function(col, mod);
}

list<Computer> DbService::sort_computers(int col, int mod)
{
    return computerRepo.sort_function(col, mod);
}

list<Connect> DbService::sort_connections(int col, int mod)
{
    return connectRepo.sort_function(col, mod);
}

list <Scientist> DbService::search_scientists(string s)
{
    return scientistRepo.search_function(s);
}

list<Computer> DbService::search_computers(string s)
{
    return computerRepo.search_function(s);
}

list<Connect> DbService::search_connections(string s)
{
    return connectRepo.search_function(s);
}

list <Scientist> DbService::sort_and_search_scientists(int col, int mod, string s)
{
    return scientistRepo.sort_and_search_function(col, mod, s);
}

list<Computer> DbService::sort_and_search_computers(int col, int mod, string s)
{
    return computerRepo.sort_and_search_function(col, mod, s);
}

list <Connect> DbService::sort_and_search_connections(int col, int mod, string s)
{
    return connectRepo.sort_and_search_function(col, mod, s);
}

list<Scientist> DbService::edit_scientists_imagePath(Scientist scientist, string newPath)
{
    return scientistRepo.edit_function_imagePath(scientist, newPath);
}

list<Computer> DbService::edit_computers_imagePath(Computer computer, string newPath)
{
    return computerRepo.edit_function_imagePath(computer, newPath);
}

list<Scientist> DbService::edit_scientists_about(Scientist scientist, string about)
{
    return scientistRepo.edit_function_about(scientist, about);
}

list<Computer> DbService::edit_computers_about(Computer computer, string about)
{
    return computerRepo.edit_function_about(computer, about);
}
