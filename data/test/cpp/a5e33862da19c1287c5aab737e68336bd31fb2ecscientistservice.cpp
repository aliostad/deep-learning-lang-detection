#include "scientistservice.h"
#include "scientist.h"

ScientistService::ScientistService()
{
    scientistRepo = ScientistRepository();
}

void ScientistService::add(Scientist c)
{
    scientistRepo.add(c);
}

vector <Scientist> ScientistService::get_allScientists()
{

    return scientistRepo.get_allscientists();
}

list <Scientist> ScientistService::sort_scientists(int col, int mod)
{
    return scientistRepo.sort_function(col, mod);
}


list <Scientist> ScientistService::search_scientists(string s)
{
    return scientistRepo.search_function(s);
}
