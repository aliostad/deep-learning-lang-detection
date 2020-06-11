#include "Game.h"
#include "Load.h"

//------------------------------------------------------------------------------
Load::~Load()
{
	
}

//------------------------------------------------------------------------------
Load::Load(std::string name) : Command(name)
{
	
}

//------------------------------------------------------------------------------
int Load::execute(Game &board, std::vector <std::string> &params)
{
	if (params.size() == 3)
	{
		board.loadFile(params[1]);
	}
	else
	{
		std::cout << "[ERR] Wrong parameter count." << std::endl;
	}
	
	return 1;
}
