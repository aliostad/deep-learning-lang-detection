/*!
@LoadTexture.cpp
*/
#include "LoadTexture.h"

bool LoadTexture::instanceFlag = false;
LoadTexture * LoadTexture::myTexture = NULL;
LoadTexture::LoadTexture()
{
	//! Loads the texture. 
	if (!texture.loadFromFile("./Textures/tiles.png"))
	{
		return;
	}
}
LoadTexture::~LoadTexture()
{
	instanceFlag = false;//!< Sets to false when its destroyed.
}
LoadTexture* LoadTexture::getInstance()
{
	//!Creates a new player then returns player.
	if(!instanceFlag)
	{
		myTexture = new LoadTexture();
		instanceFlag = true;
		return myTexture;
	}
	//! Returns the player if there is already a player.
	else return myTexture;
}

sf::Texture const* LoadTexture::getTexture()const
{
	return &texture;//!< Returns address of the texture.
}