#include "ModelDB_CharmLocal.h"


ModelDB_CharmLocal::ModelDB_CharmLocal(SingletonDBBackendEnum dbType)
{
	//Just spawn a SharedDB
	this->dbRef = new ModelDB_SharedDB(dbType);

}

void ModelDB_CharmLocal::insert(uint128_t & model_key, krigalg::InterpolationModelPtr krigingModel, krigcpl::ResponsePoint * point)
{
	dbRef->insert(model_key, krigingModel, point);
}

krigalg::InterpolationModelPtr ModelDB_CharmLocal::extract(uint128_t & model_key, krigalg::InterpolationModelFactoryPointer  * newFact)
{
	return dbRef->extract(model_key, newFact);
}

void ModelDB_CharmLocal::erase(uint128_t & model_key)
{
	//dbRef->erase(model_key);
}


