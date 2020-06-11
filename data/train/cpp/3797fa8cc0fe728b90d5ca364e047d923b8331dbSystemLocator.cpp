#pragma once
#include "SystemLocator.h"
CGDIGraphicSystem* CSystemLocator::graph;
CStringManager* CSystemLocator::string;

void CSystemLocator::Locate(CGDIGraphicSystem* object)
{
    CSystemLocator::graph=object;
}

CGDIGraphicSystem* CSystemLocator::GetGraphics()
{
	if (CSystemLocator::graph == NULL)
		throw "No system found";
    return CSystemLocator::graph;
}

void CSystemLocator::Locate(CStringManager* object)
{
	CSystemLocator::string = object;
}

CStringManager* CSystemLocator::GetStrings()
{
	if (CSystemLocator::string == NULL)
		throw "No system found";
	return CSystemLocator::string;
}