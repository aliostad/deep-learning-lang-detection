#include "DBG.h"

CDBG::CDBG(const char *fileName)
{
	debugDump.open(fileName, std::ios::trunc|std::ios::in);
}

CDBG::~CDBG()
{
	debugDump.close();
}

void CDBG::confirm()
{
	if (debugDump.good())
	{
		debugDump.write("***********************************************\n",48);
		debugDump.write("Harvest Engine 7.5 Debug Dump\n", 30);
		debugDump.write("***********************************************\n\n",49);
	}
	else
		delete this;
}

void CDBG::writeString(std::string text)
{
	debugDump.write(text.c_str(), text.length());
}

