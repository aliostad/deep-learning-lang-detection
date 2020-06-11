#include <cassert>

#include <suifkernel/utilities.h>

#include "roccc_utils/warning_utils.h"

#include "cleanup_load_pass.h"

CleanupLoadPass::CleanupLoadPass(SuifEnv* pEnv) :
  PipelinablePass(pEnv, "CleanupLoadPass")
{
  theEnv = pEnv ;
  procDef = NULL ;
}

CleanupLoadPass::~CleanupLoadPass()
{
  ; // Nothing to delete yet
}

void CleanupLoadPass::do_procedure_definition(ProcedureDefinition* p)
{
  procDef = p ;
  assert(procDef != NULL) ;
  OutputInformation("Cleanup load pass begins") ;
  list<LoadExpression*>* allLoads = 
    collect_objects<LoadExpression>(procDef->get_body()) ;
  list<LoadExpression*>::iterator loadIter = allLoads->begin() ;
  while (loadIter != allLoads->end())
  {
    Expression* internal = (*loadIter)->get_source_address() ;
    if (dynamic_cast<LoadVariableExpression*>(internal) != NULL)
    {
      (*loadIter)->set_source_address(NULL) ;
      (*loadIter)->get_parent()->replace((*loadIter), internal) ;
      delete (*loadIter) ;
    }
    ++loadIter ;
  }
  delete allLoads ;
  OutputInformation("Cleanup load pass ends") ;
}
