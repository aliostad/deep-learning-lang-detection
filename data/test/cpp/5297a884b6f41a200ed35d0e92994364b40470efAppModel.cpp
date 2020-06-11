#include "AppModel.h"

#include "ImageListFilterModel.h"
#include "ImageListModel.h"
#include "Project.h"

AppModel::AppModel()
    : projectModel(ImageListModel::createImageListModel())
    , filteredProjectModel(ImageListFilterModel::createImageListFilterModel(projectModel))
{
    setCurrentProject(Project::createProject());
}

AppModelPtr AppModel::createAppModel()
{
    return AppModelPtr(new AppModel);
}

/*!
 * \brief AppModel::setCurrentProject internal method for setting the current project
 * \param project
 */
void AppModel::setCurrentProject(ProjectPtr project)
{
    if(project != currentProject)
    {
        currentProject = project;
        projectModel->setProject(project);

        emit currentProjectChanged(project);
    }
}

ProjectPtr AppModel::getCurrentProject() const
{
    return currentProject;
}

ImageListModelPtr AppModel::getProjectModel() const
{
    return projectModel;
}

ImageListFilterModelPtr AppModel::getFilteredProjectModel() const
{
    return filteredProjectModel;
}
