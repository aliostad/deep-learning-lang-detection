/*
 * CmdDumpTraces.cpp
 *
 *  Created on: Jun 28, 2013
 *      Author: wilbert
 */

#include "CmdDumpTraces.h"

#include "Traces.h"
#include "DoubleBuffer.h"

#include <iostream>
#include <list>
#include <string>

CmdDumpTraces::CmdDumpTraces() :
		Command("dumpTraces") {
}

CmdDumpTraces::~CmdDumpTraces() {
}

void CmdDumpTraces::displayHelp(std::ostream& output) {
	output << "Usage: " << getName() << std::endl;
	output << "\tDump traced data." << std::endl;

}
void CmdDumpTraces::execute(std::ostream& output) {
	DoubleBufferLock dbl;
	Traces* traces  = Traces::getInstance();
	traces->dumpTraces(output);
}
