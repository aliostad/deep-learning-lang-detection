#include "sound.h"

sound::sound()
{
    this->soundSample[GAME_SOUND_STONED] = load_sample("stoned.wav");
    this->soundSample[GAME_SOUND_DESTROY_LINE] = load_sample("destroy_line.wav");
    this->soundSample[GAME_SOUND_BEGIN] = load_sample("begin.wav");
    this->soundSample[GAME_SOUND_MOVE] = load_sample("move.wav");
    this->soundSample[GAME_SOUND_ROTATE] = load_sample("rotate.wav");
    //this->soundSample[GAME_SOUND_GAME_OVER] = load_sample("game_over.wav");
}

void sound::playSound(int whatSound)
{
    play_sample(this->soundSample[whatSound],GAME_SOUND_VOLUME,GAME_SOUND_PANNING,GAME_SOUND_PITCH,0);
}

sound::~sound()
{
    int destroySound;
    destroySound = GAME_SOUND_NUMBER;
    for(destroySound>0;destroySound--;)
    {
        destroy_sample(this->soundSample[destroySound]);
    }
}
