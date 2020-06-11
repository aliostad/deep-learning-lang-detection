#include "Content.h"

Content::Content()
{
	loadTextures();
	loadSounds();
	loadMusic();
	loadFonts();
}

void Content::loadTextures()
{
	m_rocketTex.loadFromFile("../Textures/Rocket.png");
	m_rocketTex.setSmooth(true);

	m_fuelTex.loadFromFile("../Textures/Fuel.png");
	m_planetTex.loadFromFile("../Textures/HomePlanet.png");
	m_planetTex.setSmooth(true);
}

void Content::loadSounds()
{
	m_takeFuelSound.loadFromFile("../Sounds/takeFuel.wav");
	m_thrustSound.loadFromFile("../Sounds/thrust.wav");
}

void Content::loadMusic()
{
	m_mainTheme.openFromFile("../Music/mainTheme.wav");
}

void Content::loadFonts()
{
	m_standardFont.loadFromFile("../Fonts/SECRCODE.TTF");
}
