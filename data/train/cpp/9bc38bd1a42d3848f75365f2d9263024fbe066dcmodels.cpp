/*
 * models.cpp
 *
 * Created on: Mar 18, 2013
 * @author schurade
 */

#include "models.h"

#include "datastore.h"
#include "globalpropertymodel.h"
#include "roimodel.h"

QAbstractItemModel* Models::m_dataModel = 0;
QAbstractItemModel* Models::m_globalModel = 0;
QAbstractItemModel* Models::m_roiModel = 0;

void Models::init()
{
    m_globalModel = new GlobalPropertyModel();
    m_dataModel = new DataStore();
    m_roiModel = new ROIModel();
}

QAbstractItemModel* Models::globalModel()
{
    return m_globalModel;
}

QAbstractItemModel* Models::dataModel()
{
    return m_dataModel;
}

QAbstractItemModel* Models::RoiModel()
{
    return m_roiModel;
}

QAbstractItemModel* Models::g()
{
    return m_globalModel;
}

QAbstractItemModel* Models::d()
{
    return m_dataModel;
}

QAbstractItemModel* Models::r()
{
    return m_roiModel;
}

