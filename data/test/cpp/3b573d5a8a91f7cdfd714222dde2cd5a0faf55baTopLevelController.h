#ifndef TOPLEVELCONTROLLER_H
#define TOPLEVELCONTROLLER_H

#include <QObject>

#include "AppModelPtr.h"
#include "ImageListModelPtr.h"
#include "ImageListFilterModelPtr.h"
#include "ProjectPtr.h"

class TopLevelController
{
public:
    void setAppModel(AppModelPtr appModel);

protected:
    AppModelPtr appModel() const;
    ProjectPtr currentProject() const;
    ImageListModelPtr projectModel() const;
    ImageListFilterModelPtr filteredProjectModel() const;

private:
    AppModelPtr appModelPrivate;
};

#endif // TOPLEVELCONTROLLER_H
