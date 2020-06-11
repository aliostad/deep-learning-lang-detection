#include "Loader.hpp"
#include <vector>
#include <SFML/Graphics.hpp>

Loader::Loader()
{
    int posX = 0;
    int posY = 0;
    int increment = 20;

    sf::Image spritesheet;
    sf::Texture loadTexture;
    spritesheet.loadFromFile("res/sprite/spritesheet.png");

    sf::SoundBuffer loadSound;

    //Load sprites
    for (int i = 0; i < spritesheet.getSize().y / 20; i++)
    {
        for (int k = 0; k < 10; k++)
        {
            loadTexture.loadFromImage(spritesheet, sf::IntRect(posX, posY, 20, 20));

            texVec.push_back(loadTexture);
            posX += increment;
        }

        posX = 0;
        posY += increment;
    }

    //Load sounds
    loadSound.loadFromFile("res/sound/hit.wav");
    sndVec.push_back(loadSound);
    loadSound.loadFromFile("res/sound/hit2.wav");
    sndVec.push_back(loadSound);
    loadSound.loadFromFile("res/sound/hit3.wav");
    sndVec.push_back(loadSound);
    loadSound.loadFromFile("res/sound/pHit.wav");
    sndVec.push_back(loadSound);
    loadSound.loadFromFile("res/sound/pHit2.wav");
    sndVec.push_back(loadSound);
    loadSound.loadFromFile("res/sound/pHit3.wav");
    sndVec.push_back(loadSound);
    loadSound.loadFromFile("res/sound/powerup.wav");
    sndVec.push_back(loadSound);
}

Loader::~Loader()
{
    //dtor
}

std::vector<sf::SoundBuffer> Loader::getSounds()
{
    return sndVec;
}

std::vector<sf::Texture> Loader::getTextures()
{
    return texVec;
}
