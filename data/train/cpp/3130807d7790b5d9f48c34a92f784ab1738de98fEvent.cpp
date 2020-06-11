#include "../include/XPG/Event.hpp"

namespace XPG
{
    Event::Event()
    {
        _firstHandler = 0;
    }

    Event::~Event()
    {
        while (_firstHandler)
        {
            Handler* deadHandler = _firstHandler;
            _firstHandler = _firstHandler->nextHandler;
            delete deadHandler;
        }
    }

    void Event::AddListener(Listener listener, void* userData)
    {
        Handler* handler = new Handler;
        handler->listener = listener;
        handler->userData = userData;
        handler->nextHandler = _firstHandler;
        _firstHandler = handler;
    }

    void Event::RemoveListener(Listener listener, void* userData)
    {
        Handler* handler = _firstHandler;

        if (handler)
        {
            if (handler->listener == listener
                && handler->userData == userData)
            {
                _firstHandler = _firstHandler->nextHandler;
                delete handler;
            }
            else
            {
                Handler* next = handler->nextHandler;

                while (next)
                {
                    if (next->listener == listener
                        && next->userData == userData)
                    {
                        handler->nextHandler = next->nextHandler;
                        delete next;
                        break;
                    }

                    handler = next;
                    next = handler->nextHandler;
                }
            }
        }
    }

    void Event::Fire()
    {
        for (Handler* i = _firstHandler; i; i = i->nextHandler)
        {
            i->listener(i->userData);
        }
    }
}
