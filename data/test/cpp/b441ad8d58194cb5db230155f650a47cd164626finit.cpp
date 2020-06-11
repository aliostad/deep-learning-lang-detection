#ifndef GRAPHOX_INIT_CPP
#define GRAPHOX_INIT_CPP

#include "graphox/extern.h"
#include "graphox_inrernal.h"

#ifndef GRAPHOX_DISABLE_SVN	
//	#include "graphox/repo.h"
#endif

//#include "graphox/graphox.h"

//#include "script_engine_v8.h"

extern void conoutf(const char *, ...);
namespace graphox
{
	void init()
	{
		conoutf("adding default repos");
		addpackagedir("repo/ref");
		//addpackagedir("repo/justice");
		addpackagedir("repo/graphox");
	}
	
	void init_done()
	{
	
	}
	
	void main(int time)
	{
	
	}
}



#endif
