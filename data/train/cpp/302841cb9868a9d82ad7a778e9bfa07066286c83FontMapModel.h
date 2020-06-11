/*
  ========================================================================

  FILE:           FontMapModel.h

  SERVICES:       

  PUBLIC CLASSES: IFontMapModel

  DESCRIPTION:    

  ========================================================================
  ========================================================================
    
               Copyright © 1999-2007 QUALCOMM Incorporated 
                     All Rights Reserved.
                   QUALCOMM Proprietary/GTDR
    
  ========================================================================
  ========================================================================
*/

#ifndef __FONTMAPMODEL_H__
#define __FONTMAPMODEL_H__

#include "AEEFontMapModel.h"
#include "bid/AEECLSID_FONTMAPMODEL.bid"

#include "AEEListModel.h"
#include "AEEBase.h"

#include "ModelBase.h"
#include "Vector.h"

typedef struct FontMapModel FontMapModel;

// aeebase for listmodel
typedef struct IFMListModel {
   AEEBASE_INHERIT(IListModel, FontMapModel);
} IFMListModel;

struct FontMapModel {
   ModelBase            base;

   IFMListModel         listModel;
   AEEVTBL(IListModel)  vtListModel;
   Vector               styles;
};

int         FontMapModel_New(IFontMapModel **ppo, IModule *piModule);
void        FontMapModel_Ctor(FontMapModel *me, AEEVTBL(IFontMapModel) *pvt, IModule *piModule);
int         FontMapModel_QueryInterface(IFontMapModel* po, AEECLSID id, void **ppo);
uint32      FontMapModel_Release(IFontMapModel* po);
int         FontMapModel_Size(IFontMapModel* po); 
int         FontMapModel_GetAt(IFontMapModel *po, uint32 nIndex, void **ppoItem); 
uint32      FontMapModel_GetByName(IFontMapModel *po, const AECHAR *pszName, IFont **ppiFont) ;
uint32      FontMapModel_Insert(IFontMapModel *po, const AECHAR *pszName, IFont *piFont);
uint32      FontMapModel_Delete (IFontMapModel *po, const AECHAR *pszName); 
void        FontMapModel_DeleteAll (IFontMapModel *po); 
uint32      FontMapModel_EnsureCapacity (IFontMapModel *po, uint32 nRequired, uint32 nGrowBy, uint32 nMaxNameSize); 

#endif // __FONTMAPMODEL_H__