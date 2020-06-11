#include "msg.h"
using namespace msg;

///***  BASIC MESSAGE ***///
BasicMessage::~BasicMessage()
{
}

///*** MESSAGE HANDLER DISPATCHERS ***///
void LogMessage::Handle(MessageHandler& handler)
{
	handler.HandleLogMessage(*this);
}

void DebugMessage::Handle(MessageHandler& handler)
{
	handler.HandleDebugMessage(*this);
}

void InternalCommand::Handle(MessageHandler& handler)
{
	handler.HandleInternalCommand(*this);
}

void HeartBeat::Handle(MessageHandler& handler)
{
	handler.HandleHeartBeat(*this);
}

void ThreadDie::Handle(MessageHandler& handler) 
{
	handler.HandleThreadDie(*this);
}

void ThreadDead::Handle(MessageHandler& handler) 
{
	handler.HandleThreadDead(*this);
}

void GroupProgress::Handle(MessageHandler& handler) 
{
	handler.HandleGroupProgressReport(*this);
}

void ChannelProgress::Handle(MessageHandler& handler) 
{
	handler.HandleChannelProgressReport(*this);
}

void RequestProgress::Handle(MessageHandler& handler) 
{
	handler.HandleRequestProgress(*this);
}

void TogglePause::Handle(MessageHandler& handler)
{
	handler.HandleTogglePause(*this);
}

void AutoPaused::Handle(MessageHandler& handler) 
{
	handler.HandleAutoPaused(*this);
}

void SetPauseState::Handle(MessageHandler& handler)
{
	handler.HandleSetPauseState(*this);
}

void Restart::Handle(MessageHandler& handler)
{
	handler.HandleRestart(*this);
}

void Restarted::Handle(MessageHandler& handler)
{
	handler.HandleRestarted(*this);
}

void Paused::Handle(MessageHandler& handler)
{
	handler.HandlePaused(*this);
}

void Resumed::Handle(MessageHandler& handler)
{
	handler.HandleResumed(*this);
}
