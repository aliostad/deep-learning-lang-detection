/**
 *  @file PreLoad.cpp
 *
 *  @date 2012-2-27
 *  @Author: Bonly
 */

#include "PreLoad.h"
#include "../ResPool.h"
#include "../Configure.h"

//namespace NBird {
#ifdef _WIN32
#pragma warning(disable:4002)
#endif

/*
Page* PreLoad::create()
{
   return new PreLoad();
}
*/
PreLoad::PreLoad()
{
}

int PreLoad::init()
{
  CHKIMG(loading);
  return 0;
}

PreLoad::~PreLoad()
{
  //SafeDelete(background);
}

void PreLoad::onPaint()
{
  JImage* vl = GETIMG(ID_loading);
  gpDC->drawImage(vl, CONF.X/2 - (vl->getWidth()/2), CONF.Y/2 - (vl->getHeight()/2), 20);
}

//} /* namespace NBird */
