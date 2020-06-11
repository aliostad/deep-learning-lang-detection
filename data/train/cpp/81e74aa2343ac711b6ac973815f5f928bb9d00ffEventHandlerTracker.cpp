#include "stdafx.h"
#include "EventHandlerTracker.h"
#include "EventHandler.hpp"
#include "HandlerRegistration.hpp"

namespace Infrastructure
{
EventHandlerTracker::EventHandlerTracker()
{
}

EventHandlerTracker::~EventHandlerTracker()
{
}

void EventHandlerTracker::RegisterEventHandler(HandlerRegistration * handler)
{
	m_EventRegistrations.push_back(handler);
}

void EventHandlerTracker::UnregisterAllEventsHandlers()
{
	// Unregister Events
	for(HandlerRegistrationItr itr = m_EventRegistrations.begin();
		itr != m_EventRegistrations.end();
		++itr)
	{
		HandlerRegistration * handler = (*itr);
		handler->removeHandler();
		delete handler;
	}
	m_EventRegistrations.clear();
}

}