#include <InternationalModel.h>

/****************************************************/
CInternationalModel::CInternationalModel() : CWorld3DModel(6378388.0, 6356911.9)
/****************************************************/
{
}

/****************************************************/
CInternationalModel::~CInternationalModel()
/****************************************************/
{
}

/****************************************************/
WORLD_MODEL_TYPE CInternationalModel::WhichWorldModelAmI() const
/****************************************************/
{
	return (INTERNATIONAL);
}
