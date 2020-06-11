/****************************************************************************
 *                                                                          *
 *  Author : lukasz.iwaszkiewicz@gmail.com                                  *
 *  ~~~~~~~~                                                                *
 *  License : see COPYING file for details.                                 *
 *  ~~~~~~~~~                                                               *
 ****************************************************************************/

#include "AbstractModelManager.h"
#include "util/Scene.h"

namespace Model {

/****************************************************************************/

void AbstractModelManager::callOnManagerUnloadModel (Util::Scene *scene)
{
        scene->onManagerUnloadModel ();
}

/****************************************************************************/

void AbstractModelManager::callOnManagerLoadModel (Util::Scene *scene)
{
        scene->onManagerLoadModel ();
}

} /* namespace Model */
