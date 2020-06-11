#include "c-gaudi/gaudi.h"

#include "GaudiKernel/ISvcLocator.h"

CGaudi_StatusCode
CGaudi_ISvcLocator_getService(CGaudi_ISvcLocator self,
                              const char *type_name,
                              CGaudi_IService *svc,
                              int createif)
{
  StatusCode sc = ((ISvcLocator*)self)->getService
    (type_name, 
     *(IService**)svc,
     createif == 0 ? false : true);
  return *(CGaudi_StatusCode*)(&sc);
}

int
CGaudi_ISvcLocator_existsService(CGaudi_ISvcLocator self,
                                 const char *name)
{
  return ((ISvcLocator*)self)->existsService(name) ? 1 : 0;
}

