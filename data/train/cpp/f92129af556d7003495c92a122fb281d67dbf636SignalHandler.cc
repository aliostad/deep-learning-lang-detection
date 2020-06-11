#include <system/SignalHandler.h>

SignalHandler::SignalHandler ()
{
}

SignalHandler& SignalHandler::getInstance ()
{
	return instance;
}

EventHandler* SignalHandler::registrarHandler (int signum, EventHandler *eh)
{
	EventHandler *old_eh = SignalHandler::signal_handlers[signum];
	SignalHandler::signal_handlers[signum] = eh;

	struct sigaction sa;
	sa.sa_handler = SignalHandler::dispatcher;
	sigemptyset (&sa.sa_mask); 
	sa.sa_flags = 0;
	sigaction (signum, &sa, 0);
	return old_eh;
}

void SignalHandler::dispatcher (int signum)
{
	if (SignalHandler::signal_handlers[signum] != NULL)
		SignalHandler::signal_handlers[signum]->handleSignal (signum);
}

int SignalHandler::removerHandler (int signum)
{
	SignalHandler::signal_handlers[signum] = NULL;
	return 0;
}

SignalHandler SignalHandler::instance;
EventHandler *SignalHandler::signal_handlers[NSIG] = { NULL };
