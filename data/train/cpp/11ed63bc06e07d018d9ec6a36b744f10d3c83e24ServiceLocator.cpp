#include "stdafx.h"
#include "ServiceLocator.h"

using namespace Base;

IMPLEMENT_SINGLETON(cServiceLocator)

//  ********************************************************************************************************************
cServiceLocator::cServiceLocator()
{
}

//  ********************************************************************************************************************
cServiceLocator::~cServiceLocator()
{
  for (auto iter = m_RegisteredTypes.begin(); iter != m_RegisteredTypes.end(); iter++)
  {
    iter->second.reset();
  }
  m_RegisteredTypes.clear();
}
