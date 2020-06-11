#ifndef MODELPOOL_H
#define MODELPOOL_H

#include <vector>
#include <string>

using namespace std;

class ModelAbstraction;

/// provides storage and access of world objects
class ModelPool
{
 private:
  vector< ModelAbstraction * > *            pvpModels;
 public:
                                            ModelPool();
  ModelAbstraction *                        GetModel( string name );
  bool                                      AddModel( ModelAbstraction * model );
  bool                                      RemoveModel( ModelAbstraction * model );
  bool                                      RemoveModel( string name );
  void                                      SetModelPool( vector< ModelAbstraction * > * );   ///copies model pool from another source
  vector< ModelAbstraction * > *            GetModelPool();
};
#endif
