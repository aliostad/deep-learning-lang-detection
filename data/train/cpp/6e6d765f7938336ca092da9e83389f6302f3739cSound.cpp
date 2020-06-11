/*
Chay Davis
CS 202
Group B

May 3, 2013

*/
#include "Sound.h"
#include "Resources.h"

#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/audio/Output.h"
#include <iostream>

//each of these functions loads a different sound

void Sound::attackSetup1()
{
	currentSound_=audio::load( loadResource( SWORD_CUT_1 ) );
}

void Sound::attackSetup2()
	{
	currentSound_=audio::load( loadResource( SWORD_CUT_2 ) );
}
void Sound::attackSetup3()
	{
	currentSound_=audio::load( loadResource( SWORD_CUT_3 ) );
}
void Sound::attackSetup4()
	{
	currentSound_=audio::load( loadResource( SWORD_CUT_4 ) );
}
void Sound::magicAttackSetup()
	{
	currentSound_=audio::load( loadResource( MAGIC_ATTACK ) );
}
void Sound::screechSetup()
{
	currentSound_=audio::load( loadResource( SWALLOW ) );
}
void Sound::monsterScreechSetup()
{
	currentSound_=audio::load( loadResource( MONSTER_SCREECH ) );
}
void Sound::swallowSetup()
{
	currentSound_=audio::load( loadResource( SWALLOW ) );
}
void Sound::snarlSetup()
{
	currentSound_=audio::load( loadResource( SNARL ) );
}
void Sound::superSnarlSetup()
{
	currentSound_=audio::load( loadResource( SUPER_SNARL ) );
}
void Sound::doorNoiseSetup()
{
	currentSound_=audio::load( loadResource( DOOR_OPEN ) );
}
void Sound::dragonHissSetup()
{
	currentSound_=audio::load( loadResource( DRAGON_HISS ) );
}
void Sound::hissSetup()
{
	currentSound_=audio::load( loadResource( HISS ) );
}
void Sound:: hybridGrowlSetup1()
	{
	currentSound_=audio::load( loadResource( HYBRID_GROWL ) );
}
void Sound:: hybridGrowlSetup2()
{
	currentSound_=audio::load( loadResource( HYBRID_GROWL_2 ) );
}

//I wanted to have just one sound setup function, 
//but it wouldn't pass a sound file properly

void Sound::launch()//plays which ever sound is currently loaded
{
	audio::Output::play( currentSound_ );//FIRE WHEN READY
}

