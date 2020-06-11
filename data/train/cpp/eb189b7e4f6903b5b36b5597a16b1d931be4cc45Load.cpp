#include "Load.h"
#include <cstdlib>

using namespace std;

Load::Load()
{
}

Load::Load(int id)
{
    load_id = id;
    random_load_size = rand() % (50 - 30 + 1) + 30;
    finished = false;
}

Load::~Load()
{
    //dtor
}

/** Getters and Setters **/

void Load::set_load_id(int id)
{
    load_id = id;
}

void Load::set_random_load_size(int load_size)
{
    random_load_size = load_size;
}

void Load::set_is_finished(bool finish)
{
    finished = finish;
}

int Load::get_load_id()
{
    return load_id;
}

int Load::get_random_load_size()
{
    return random_load_size;
}

bool Load::is_finished()
{
    return finished;
}
