#include "IPhysicModel.h"
#include "PhysicModelSimple.h"
#include "PhysicModelGeneric.h"
#include "PhysicModelCharacter.h"

//-----------------------------------------------------------------------------
//  Factory
//-----------------------------------------------------------------------------
IPhysicModel*   IPhysicModel::Factory (EType eType)
{
    IPhysicModel*   pResult = NULL;

    switch (eType)
    {
        case MODEL_SIMPLE:      pResult = new CPhysicModelSimple();     break;
        case MODEL_GENERIC:     pResult = new CPhysicModelGeneric();    break;
		case MODEL_CHARACTER:   pResult = new CPhysicModelCharacter();  break;
        default:
        {
            assert(!"Invalid switch!!");
        }
    }

    return pResult;
}
