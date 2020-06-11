/****************************************************************************
**
** Copyright (C) VCreate Logic Private Limited, Bangalore
**
** Use of this file is limited according to the terms specified by
** VCreate Logic Private Limited, Bangalore. Details of those terms
** are listed in licence.txt included as part of the distribution package
** of this file. This file may not be distributed without including the
** licence.txt file.
**
** Contact info@vcreatelogic.com if any conditions of this licensing are
** not clear to you.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
****************************************************************************/

#include "CVtkLocator.h"
#include "IVtkDataSetIOData.h"

DEFINE_VTK_OBJECT(CVtkLocator, CVtkObject, vtkLocator)
{
    pDesc->setNodeClassCategory("Rendering");
    pDesc->setNodeClassName("vtkLocator");
    pDesc->setCreateFunction(0);

    pDesc->setPropertyInfo("MaxLevel", "SetMaxLevel", "GetMaxLevel", QStringList() << "int", QStringList(), "void", "int");
    pDesc->setPropertyInfo("Automatic", "SetAutomatic", "GetAutomatic", QStringList() << "bool", QStringList(), "void", "bool");
    pDesc->setPropertyInfo("Tolerance", "SetTolerance", "GetTolerance", QStringList() << "double", QStringList(), "void", "double");
    
    // Data Set
    pDesc->addConnectionPath(
        new CVtkObjectConnectionPath("DataSet", IVisSystemNodeConnectionPath::InputPath, "vtkDataSet", 0)
        );

    pDesc->addConnectionPath(
        new CVtkObjectConnectionPath("Locator", IVisSystemNodeConnectionPath::OutputPath, "vtkLocator", 0)
        );

}

CVtkLocator::CVtkLocator() : m_vtkLocator(0)
{
    CVtkLocator::InitializeObjectDesc();
}

CVtkLocator::~CVtkLocator()
{

}

void CVtkLocator::setMaxLevel(int level)
{
    m_vtkLocator->SetMaxLevel(level);
}

int CVtkLocator::maxLevel() const
{
    return m_vtkLocator->GetMaxLevel();
}

int CVtkLocator::level() const
{
    return m_vtkLocator->GetLevel();
}

void CVtkLocator::setAutomatic(bool val)
{
    m_vtkLocator->SetAutomatic(val);
}

bool CVtkLocator::isAutomatic() const
{
    return m_vtkLocator->GetAutomatic();
}

void CVtkLocator::setTolerance(double val)
{
    m_vtkLocator->SetTolerance(val);
}

double CVtkLocator::tolerance() const
{
    return m_vtkLocator->GetTolerance();
}


void CVtkLocator::buildLocator()
{
    if(m_vtkLocator->GetDataSet())
        m_vtkLocator->BuildLocator();
}

void CVtkLocator::command_BuildLocator()
{
    if(m_vtkLocator->GetDataSet())
        m_vtkLocator->BuildLocator();
}

bool CVtkLocator::hasInput(IVisSystemNodeConnectionPath* path)
{
    if(!path)
        return false;

    if(path->pathName() == "DataSet")
    {
        return m_vtkLocator->GetDataSet();
    }

    return false;
}

bool CVtkLocator::setInput(IVisSystemNodeConnectionPath* path, IVisSystemNodeIOData* inputData)
{
    if(!path || !inputData)
        return false;

    if(path->pathName() == "DataSet")
    {
        IVtkDataSetIOData* data = 0;
        bool success = inputData->queryInterface("IVtkDataSetIOData", (void**)&data);
        if(success && data)
        {
            m_vtkLocator->SetDataSet(data->getVtkDataSet());
            return true;
        }
    }

    return false;
}

bool CVtkLocator::removeInput(IVisSystemNodeConnectionPath* path, IVisSystemNodeIOData* inputData)
{
    if(!path || !inputData)
        return false;

    if(path->pathName() == "DataSet")
    {
        IVtkDataSetIOData* data = 0;
        bool success = inputData->queryInterface("IVtkDataSetIOData", (void**)&data);
        if(success && data && data->getVtkDataSet() == m_vtkLocator->GetDataSet())
        {
            m_vtkLocator->SetDataSet(0);
            return true;
        }
    }

    return false;
}

bool CVtkLocator::fetchOutput(IVisSystemNodeConnectionPath* path, IVisSystemNodeIOData** outputData)
{
    if(!path || !outputData)
        return false;

    if(path->pathName() == "Locator")
    {
        m_locatorData.setLocator(m_vtkLocator);
        *outputData = &m_locatorData;
        return true;
    }

    return false;
}

bool CVtkLocator::outputDerefed(IVisSystemNodeConnectionPath* path, IVisSystemNodeIOData* outputData)
{
    if(!path || !outputData)
        return false;

    return true;
}





