#include "../logic/Logic.h"


ISoundManager* m_soundManager = NULL;


ISoundManager& ISoundManager::Instance()
{
    if( !m_soundManager ) m_soundManager = NEW( SoundManager, () );

    return *m_soundManager;

}

TError SoundManager::Init()
{
    BASS_Init( -1, 44100, 0, NULL, NULL );

    return OK;
}

void SoundManager::End()
{
    BASS_Free();
    DEL( m_soundManager );
}

void SoundManager::PlaySample( ISample* sample )
{
    if( sample ) sample->PlaySample();
}

void SoundManager::StopSample( ISample* sample )
{
    if( sample ) sample->StopSample();
}

void SoundManager::PauseSample( ISample* sample )
{
    if( sample ) sample->PauseSample();
}

SoundManager::SoundManager()
{
}

SoundManager::~SoundManager()
{
}