//
//  LoadAssets.cpp
//  HybridGems
//
//  Created by sid on 16/11/13.
//
//

#include "LoadAssets.h"
#include <string>
#include <iostream>

using namespace std;

static string tiles[5] = { "Red.png", "Blue.png", "Green.png", "Purple.png", "Yellow.png" };

LoadAssets* LoadAssets::pinstance = 0;

LoadAssets* LoadAssets::Instance()
{
    if (pinstance == 0)
    {
        pinstance = new LoadAssets;
    }
    
    return pinstance;
}

LoadAssets::~LoadAssets()
{
    
}

LoadAssets::LoadAssets()
{
    background = LoadImage("BackGround.jpg");
    redTile = LoadImage(tiles[0]);
    blueTile = LoadImage(tiles[1]);
    greenTile = LoadImage(tiles[2]);
    purpleTile = LoadImage(tiles[3]);
    yellowTile = LoadImage(tiles[4]);
    
    tilesTextures[0] = redTile;
    tilesTextures[1] = blueTile;
    tilesTextures[2] = greenTile;
    tilesTextures[3] = purpleTile;
    tilesTextures[4] = yellowTile;
}

void LoadAssets::CleanUp()
{
    SDL_FreeSurface(background);
    SDL_FreeSurface(redTile);
    SDL_FreeSurface(blueTile);
    SDL_FreeSurface(greenTile);
    SDL_FreeSurface(purpleTile);
    SDL_FreeSurface(yellowTile);
    
    tilesTextures[0] = NULL;
    tilesTextures[1] = NULL;
    tilesTextures[2] = NULL;
    tilesTextures[3] = NULL;
    tilesTextures[4] = NULL;
}
