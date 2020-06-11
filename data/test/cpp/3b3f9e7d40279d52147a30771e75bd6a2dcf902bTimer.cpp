#include "Timer.h"
#include "ipc.h"

namespace Pave_Libraries_Common
{
	bool Timer::addTimer(void (*timerHandler)(), unsigned long ms)
	{
		TimerHandlerData *handlerData = new TimerHandlerData;
		handlerData->withData = false;
		handlerData->timerHandlerNoData = timerHandler;
		return (IPC_OK == IPC_addPeriodicTimer(ms, &timerCallback, handlerData));
	}

	bool Timer::addTimer(void (*timerHandler)(void *), unsigned long ms, void *data)
	{
		TimerHandlerData *handlerData = new TimerHandlerData;
		handlerData->withData = true;
		handlerData->data = data;
		handlerData->timerHandlerWithData = timerHandler;
		return (IPC_OK == IPC_addPeriodicTimer(ms, &timerCallback, handlerData));
	}

	void Timer::timerCallback(void *data, unsigned long a, unsigned long b)
	{
		TimerHandlerData *handlerData = (TimerHandlerData*)data;
		if(handlerData->withData)
			handlerData->timerHandlerWithData(handlerData->data);
		else
			handlerData->timerHandlerNoData();
	}
}