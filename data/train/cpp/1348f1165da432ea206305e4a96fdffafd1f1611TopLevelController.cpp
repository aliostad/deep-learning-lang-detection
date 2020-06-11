#include "TopLevelController.h"

#include "AppModel.h"

void TopLevelController::setAppModel(AppModelPtr appModel)
{
    appModelPrivate = appModel;
}

AppModelPtr TopLevelController::appModel() const
{
    return appModelPrivate;
}

ProjectPtr TopLevelController::currentProject() const
{
    return appModel()->getCurrentProject();
}

ImageListModelPtr TopLevelController::projectModel() const
{
    return appModel()->getProjectModel();
}

ImageListFilterModelPtr TopLevelController::filteredProjectModel() const
{
    return appModel()->getFilteredProjectModel();
}
