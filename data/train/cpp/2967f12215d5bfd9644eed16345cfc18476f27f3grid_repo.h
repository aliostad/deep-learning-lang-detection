#ifndef INCLUDED_MAP_GRID_REPO_H
#define INCLUDED_MAP_GRID_REPO_H

#include "platform/repository.h"
#include "platform/singleton.h"
#include "i_grid.h"

namespace map {

class DefaultGrid: public IGrid
{
public:
    DefaultGrid();
    virtual void Update( double DeltaTime );
};

class GridRepo : public platform::Repository<IGrid>, public platform::Singleton<GridRepo>
{
    friend class platform::Singleton<GridRepo>;
    static DefaultGrid const mDefault;
    GridRepo();
};

} // namespace map

#endif//INCLUDED_MAP_GRID_REPO_H

//command:  "classgenerator.exe" -g "repository" -c "grid_repo" -n "map" -t "i_grid"
