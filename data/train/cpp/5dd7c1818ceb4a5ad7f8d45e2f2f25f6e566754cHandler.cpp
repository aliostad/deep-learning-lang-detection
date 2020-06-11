#include "app/Handler.h"
#include "app/Looper.h"

//----------------------------------------------------------------------------

Handler::~Handler()
{
    if (m_looper != nullptr)
        m_looper->RemoveHandler(this);
}

//----------------------------------------------------------------------------

void Handler::SetNextHandler(Handler* handler)
{
    if (m_looper != nullptr && m_looper == handler->m_looper)
        m_nextHandler = handler;
}

//----------------------------------------------------------------------------

void Handler::MessageReceived(Message* message)
{
    if (m_nextHandler != nullptr)
    {
        if (message->what >= MSG_USER)
            m_nextHandler->MessageReceived(message);
    }
}

//----------------------------------------------------------------------------
