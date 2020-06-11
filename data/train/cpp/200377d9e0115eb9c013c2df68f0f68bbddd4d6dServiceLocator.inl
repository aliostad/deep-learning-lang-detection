#include "ServiceLocator.h"

TextureHolder* ServiceLocator::mTextures = nullptr;
FontHolder*	 ServiceLocator::mFonts = nullptr;
sf::RenderWindow* ServiceLocator::mWindow = nullptr;
SoundPlayer* ServiceLocator::mSoundPlayer = nullptr;

void ServiceLocator::setTextureHolder(TextureHolder& textures)
{
	mTextures = &textures;
}

TextureHolder& ServiceLocator::getTextureHolder()
{
	return *mTextures;
}

void ServiceLocator::setFontHolder(FontHolder& fonts)
{
	mFonts = &fonts;
}

FontHolder& ServiceLocator::getFontHolder()
{
	return *mFonts;
}

void ServiceLocator::setWindow(sf::RenderWindow& window)
{
	mWindow = &window;
}

sf::RenderWindow& ServiceLocator::getWindow()
{
	return *mWindow;
}

void ServiceLocator::setSoundPlayer(SoundPlayer& soundPlayer)
{
	mSoundPlayer = &soundPlayer;
}

SoundPlayer& ServiceLocator::getSoundPlayer()
{
	return *mSoundPlayer;
}