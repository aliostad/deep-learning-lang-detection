/********************************************************************
**	file: 		ParticlePostLoadCallback.h
**	author:		cpzhang <chengpengzhang@gmail.com>
**	created:	2011-4-25
**	purpose:	
*********************************************************************/
#ifndef __ParticlePostLoadCallback_h__
#define __ParticlePostLoadCallback_h__

#include "MaxParticleCommon.h"

class ParticlePostLoadCallback : public PostLoadCallback 
{
public:
	ParamBlockPLCB *cb;
	
	ParticlePostLoadCallback(ParamBlockPLCB *c) 
	{
		cb = c;
	}

	void proc(ILoad *iload) 
	{
		delete this;
	}
};


#endif // __ParticlePostLoadCallback_h__
