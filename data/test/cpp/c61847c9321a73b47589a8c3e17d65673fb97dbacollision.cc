#include "collision.h"
#include "foca.h"
#include "playerfoca.h"


#include <pyramidworks/collision/collisionlogic.h>
#include <stdio.h>
#include <ugdk/audio/audiomanager.h>
#include <ugdk/audio/sample.h>
#include <ugdk/base/engine.h>

using ugdk::AudioManager;
using ugdk::Sample;
 
 
void Bolo::Handle(void* bolo){
        Foca* foca = static_cast<Foca*>(bolo);
        foca->Die();
        tocaSom();
        
}

void Bolo::tocaSom()
{
    Sample* sample;
    sample = AUDIO_MANAGER()->LoadSample("Bah.wav");
    sample->SetVolume(0.5);
    sample->Play();
}
