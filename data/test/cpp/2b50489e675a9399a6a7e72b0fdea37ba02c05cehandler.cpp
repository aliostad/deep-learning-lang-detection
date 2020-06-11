#include "handler.hpp"
#include "response.hpp"

Handler :: ~Handler()
{
}

//---------------------------------------------------------

TimerHandler :: ~TimerHandler()
{
}

//---------------------------------------------------------

CompletionHandler :: ~CompletionHandler()
{
}

//---------------------------------------------------------

DefaultCompletionHandler :: DefaultCompletionHandler()
{
}

DefaultCompletionHandler :: ~DefaultCompletionHandler()
{
}

void DefaultCompletionHandler :: completionMessage(Message * msg)
{
  delete msg;
}

//---------------------------------------------------------

HandlerFactory :: ~HandlerFactory()
{
}

CompletionHandler * HandlerFactory :: createCompletionHandler() const
{
  return new DefaultCompletionHandler();
}

