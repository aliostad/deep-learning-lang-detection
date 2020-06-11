#include "ServiceLocator.h"
#include "../Types.h"

IEntityManager* ServiceLocator::entity_manager_ = NULL;
nullEntityManager ServiceLocator::null_entity_manager_;

void ServiceLocator::Initialize() {
  entity_manager_ = &null_entity_manager_;
}

IEntityManager* ServiceLocator::GetEntityManager() {
  return entity_manager_;
}

void ServiceLocator::ProvideEntityManager(IEntityManager* manager) {
  //if we provide a NULL system, we assign a null entity manager instance. otherwise, we set the correct one.
  if( manager == NULL ) {
    entity_manager_ = &null_entity_manager_;
  }
  else {
    entity_manager_ = manager;
  }
}