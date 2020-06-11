/*****************************************************************
 * $Id: sail_modelfactory.cpp 2166 2014-09-25 13:23:18Z rutger $
 * Created: Jul 26, 2012 14:24:25 AM - rutger
 *
 * Copyright (C) 2012 Red-Bag. All rights reserved.
 * This file is part of the Biluna SAIL project.
 *
 * See http://www.red-bag.com for further details.
 *****************************************************************/

#include "sail_modelfactory.h"

#include "sail_objectfactory.h"
#include "db_modelfactory.h"
#include "rb_database.h"

SAIL_ModelFactory* SAIL_ModelFactory::mActiveFactory = NULL;


/**
 * Constructor
 */
SAIL_ModelFactory::SAIL_ModelFactory(RB_MainWindow* mw) : RB_ModelFactory(mw) {
    RB_DEBUG->print("SAIL_ModelFactory::SAIL_ModelFactory()");
    this->setObjectFactory(SAIL_OBJECTFACTORY);
    DB_MODELFACTORY->registerFactory(this);
}

/**
 * Destructor
 */
SAIL_ModelFactory::~SAIL_ModelFactory() {
    DB_MODELFACTORY->unregisterFactory(this);
    mActiveFactory = NULL;
    RB_DEBUG->print("SAIL_ModelFactory::~SAIL_ModelFactory() OK");
}

/**
 * Create instance of factory
 */
SAIL_ModelFactory* SAIL_ModelFactory::getInstance(RB_MainWindow* mw) {
    if (!mActiveFactory) {
        mActiveFactory = new SAIL_ModelFactory(mw);
    }
    return mActiveFactory;
}

/**
 * @param type model type
 * @param shared true if model is to be created as unique/single/shared model
 * @return model manager
 */
RB_MmProxy* SAIL_ModelFactory::getModel(int type, bool shared) {
    RB_MmProxy* model = NULL;

    if (shared) {
        std::map<int, RB_MmProxy*>::iterator iter;
        iter = mModelList.find(type);
        if (iter != mModelList.end()) {
            // shared model 1- exists or 2- has been removed/deleted and set to NULL
            model = (*iter).second;
        }
        // Model already created
        if (model) return model;
    }

    QSqlDatabase db = getDatabase();

    switch (type) {
    case ModelCoordinate:
        model = getTableModel(db, mObjectFactory, type, "SAIL_CoordinateList", shared);
        model->setSourceSortOrder(RB2::SortOrderAscending, "mname");
        break;
    case ModelMap:
        model = getTableModel(db, mObjectFactory, type, "SAIL_MapList", shared);
        model->setSourceSortOrder(RB2::SortOrderAscending, "mname");
        break;
    case ModelProject:
        model = getTableModel(db, mObjectFactory, type, "SAIL_ProjectList", shared);
        model->setSourceSortOrder(RB2::SortOrderDescending, "created");
        break;
    case ModelProjectEdit:
        model = getTableModel(db, mObjectFactory, type, "SAIL_ProjectList", shared);
        model->setSourceSortOrder(RB2::SortOrderDescending, "created");
        break;
    case ModelRoute:
        model = getTableModel(db, mObjectFactory, type, "SAIL_RouteList", shared);
        break;
    case ModelRouteCoordinate:
        model = getTableModel(db, mObjectFactory, type, "SAIL_RouteCoordinateList", shared);
        model->setSourceSortOrder(RB2::SortOrderAscending, "seqno");
        break;
    case ModelSymbol:
        model = getTableModel(db, mObjectFactory, type, "SAIL_SymbolList", shared);
        model->setSourceSortOrder(RB2::SortOrderAscending, "mname");
        break;
    case ModelTrack:
        model = getTableModel(db, mObjectFactory, type, "SAIL_TrackList", shared);
        break;
    default:
        RB_DEBUG->print(RB_Debug::D_ERROR,
                        "SAIL_ModelFactory::getModel()"
                        "non-existing model ERROR");
        break;
    }

    return model;
}

/**
 * Get parent model. Used in child models or models depending on selection of
 * a parent model.
 * @param type child model type
 * @return parent model or NULL if not exists
 */
RB_MmProxy* SAIL_ModelFactory::getParentModel(int type) {
    RB_MmProxy* model = NULL;
    std::map<int, RB_MmProxy*>::iterator iter;

    switch (type) {
    case ModelCoordinate:
        iter = mModelList.find(ModelNone);
        break;
    case ModelMap:
        iter = mModelList.find(ModelNone);
        break;
    case ModelProject:
        iter = mModelList.find(ModelNone);
        break;
    case ModelProjectEdit:
        iter = mModelList.find(ModelNone);
        break;
    case ModelRoute:
        iter = mModelList.find(ModelNone);
        break;
    case ModelRouteCoordinate:
        iter = mModelList.find(ModelRoute);
        break;
    case ModelSymbol:
        iter = mModelList.find(ModelNone);
        break;
    case ModelTrack:
        iter = mModelList.find(ModelNone);
        break;
    default:
        iter = mModelList.find(ModelNone);
        RB_DEBUG->print(RB_Debug::D_ERROR,
                        "SAIL_ModelFactory::getParentModel() "
                        "non-existing (parent) model ERROR");
        break;
    }
    if (iter != mModelList.end()) {
        model = (*iter).second;
    }
    return model;
}

