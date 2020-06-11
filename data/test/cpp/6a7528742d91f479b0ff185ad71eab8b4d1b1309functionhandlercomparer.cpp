#include "functionhandlercomparer.h"
#include "functionhandler"

/// Constructor
FunctionHandlerComparer::FunctionHandlerComparer(FunctionHandlerBase& baseHandler)
: _baseHandler(baseHandler)
{
    // No implementation required.
}

/// Visit generic handler
void FunctionHandlerComparer::Visit(HandlerBase&)
{
    _equalsResult = false;
}

/// Visit function handler
void FunctionHandlerComparer::Visit(FunctionHandlerBase& handler)
{
    _equalsResult = (_baseHandler.GetFunctionPtr() == handler.GetFunctionPtr());
}

/// Visit method handler
void FunctionHandlerComparer::Visit(MethodHandlerBase&)
{
    _equalsResult = false;
}
