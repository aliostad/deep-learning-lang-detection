#pragma once

#include "Core/EventHandler.h"

namespace TikiEngine
{
	template <class T, typename TArgs>
	class Event
	{
	public:

		Event()
			: eventHandler()
		{	
		}

		virtual ~Event()
		{
			FOREACH_PTR_CALL(eventHandler, handled.Remove(this));
		}

		void RaiseEvent(T* sender, const TArgs& args) const
		{
			UInt32 i = 0;
			while (i < eventHandler.Count())
			{
				eventHandler[i]->Handle(sender, args);
				i++;
			}
		}

		void AddHandler(EventHandler<T, TArgs>* handler)
		{
			eventHandler.Add(handler);
			handler->handled.Add(this);
		}

		void RemoveHandler(EventHandler<T, TArgs>* handler)
		{
			eventHandler.Remove(handler);
		}

	protected:

		List<EventHandler<T, TArgs>*> eventHandler;

	};
}