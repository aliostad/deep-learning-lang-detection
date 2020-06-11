#include "abortablecontacthandler.h"

namespace CUSP {

AbortableContactHandler::AbortableContactHandler(EndPoint::ContactHandler& handler)
	: handler(&handler)
{
}

void AbortableContactHandler::abort()
{
	handler = NULL;
}

// EndPoint::ContactHandler implementation

void AbortableContactHandler::onContact(Host& host, OutStream& os)
{
	if (handler)
		handler->onContact(host, os);
	delete this;
}

void AbortableContactHandler::onContactFail()
{
	if (handler)
		handler->onContactFail();
	delete this;
}

} // namespace CUSP
