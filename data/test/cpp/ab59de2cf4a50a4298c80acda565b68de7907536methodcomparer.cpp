#include "methodcomparer.h"
#include "methodhandler"

/// Constructor
MethodHandlerComparer::MethodHandlerComparer(MethodHandlerBase& baseHandler)
: _baseHandler(baseHandler)
{
    // No implementation required.
}

/// Visit generic handler
void MethodHandlerComparer::Visit(HandlerBase&)
{
    _equalsResult = false;
}

/// Visit function handler
void MethodHandlerComparer::Visit(FunctionHandlerBase&)
{
    _equalsResult = false;
}

/// Visit method handler
void MethodHandlerComparer::Visit(MethodHandlerBase& handler)
{
    _equalsResult = (_baseHandler.GetObjectPtr() == handler.GetObjectPtr()) &&
        (_baseHandler.GetMethodPtr() == handler.GetMethodPtr());
}
