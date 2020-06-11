///////////////////////////////////////////////////////////
//  ConformLoad.h
//  Implementation of the Class ConformLoad
//  Created on:      07-fev-2014 11:43:34
///////////////////////////////////////////////////////////

#if !defined(EA_825CC3D7_A8D1_4755_93DC_42270477B60A__INCLUDED_)
#define EA_825CC3D7_A8D1_4755_93DC_42270477B60A__INCLUDED_

#include "EnergyConsumer.h"

/**
 * ConformLoad represent loads that follow a daily load change pattern where the
 * pattern can be used to scale the load with a system load.
 */
class ConformLoad : public EnergyConsumer
{

public:
	ConformLoad();
	virtual ~ConformLoad();

};
#endif // !defined(EA_825CC3D7_A8D1_4755_93DC_42270477B60A__INCLUDED_)
