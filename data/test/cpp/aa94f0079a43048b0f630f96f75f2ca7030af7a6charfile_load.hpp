/***********************************************************************
     * File       : charfile_load.hpp
     * Created    : May 07, 2014
     * Copyright  : (C) 2014 Achpile
     * Author     : Fedosov Alexander
     * Email      : achpile@gmail.com

***********************************************************************/
#ifndef __CHARFILE_LOAD
#define __CHARFILE_LOAD


void loadCharMeta(fired::Character *character, FILE *fp);
void loadCharAttr(fired::Character *character, FILE *fp);
void loadCharInv(fired::Character *character, FILE *fp);
void loadCharItem(fired::InventoryItem *item, FILE *fp);

#endif
