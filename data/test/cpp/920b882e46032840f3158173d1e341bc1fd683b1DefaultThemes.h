#ifndef _DEFAULTTHEMES_H_
#define	_DEFAULTTHEMES_H_
#include "Theme.h"

const int num_thm = 2;
Theme mainthm[num_thm];

void loadPremadeThm(){
	mainthm[0].setName("Zima").loadBackground(182, 252, 234).loadWalls(15, 9, 27).loadFloor(0, 36, 20, 62).loadFloor(1, 74, 41, 128).loadFloor(2, 107, 59, 186).loadFloor(3, 143, 104, 207).loadFloor(4, 175, 147, 221).loadFloor(5, 206, 189, 234).setTheme(Theme::WINTER).isDefault = true;;	
	mainthm[1].setName("Las").loadBackground(134, 130, 95).loadWalls(107, 52, 30).loadFloor(0, 48, 89, 37).loadFloor(1,85, 127, 20).loadFloor(2, 191, 183, 19).loadFloor(3, 207, 97, 54).loadFloor(4, 184, 45, 40).loadFloor(5, 196, 47, 65).setTheme(Theme::FOREST).isDefault = true;;	
}


#endif
