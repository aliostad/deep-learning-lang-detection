/*
 * SamplePlayer.cpp
 *
 *  Created on: Dec 28, 2013
 *      Author: lukas
 */

#include "SamplePlayer.h"

#include "impl/SamplePlayer_SW.h"

DEFINE_COMPONENTNAME(SamplePlayer, "smplply")

EXPORT_SOUNDCOMPONENT_SW_ONLY(SamplePlayer);

SamplePlayer::SamplePlayer(std::vector<std::string> params) : SoundComponentImpl(params) {

    CREATE_AND_REGISTER_PORT3(SamplePlayer, In, ControlPort, Trigger, 1);

    CREATE_AND_REGISTER_PORT3(SamplePlayer, Out, SoundPort, SoundOut_Left, 1);
    CREATE_AND_REGISTER_PORT3(SamplePlayer, Out, SoundPort, SoundOut_Right, 2);

    m_DoPlayback = 0;
}

SamplePlayer::~SamplePlayer() { }


