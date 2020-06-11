
#pragma once

#include "ComponentPools.h"

class ComponentPoolHolder {
public:

    ComponentPoolHolder()
    { 
		Locator<CRenderPool>::set(&renderpool);
		Locator<CTransformPool>::set(&transformpool);
		Locator<CRelativeTransformPool>::set(&relativetransformpool);
		Locator<CPlayerPool>::set(&playerpool);
		Locator<CPhysicPool>::set(&physicpool);
		Locator<CHealthPool>::set(&healthpool);
		Locator<CInputPool>::set(&inputpool);
        Locator<EntityPool>::set(&entitypool);
    }

private: 
	CRenderPool renderpool;
	CTransformPool transformpool;
	CRelativeTransformPool relativetransformpool;
	CPlayerPool playerpool;
	CPhysicPool physicpool;
	CHealthPool healthpool;
	CInputPool inputpool;
    EntityPool entitypool;

};