// EPOS-- Handler Utility Declarations

#ifndef __handler_h
#define __handler_h

#include <system/config.h>

__BEGIN_SYS

class Handler
{
public:
    // A handler function
    typedef void (Function)();

public:
    Handler() {}
    virtual ~Handler() {}

    virtual void operator()() = 0;
    void operator delete(void * object) {}
};

class Handler_Function: public Handler
{
public:
    Handler_Function(Function * h): _handler(h) {}
    ~Handler_Function() {}

    void operator()() { _handler(); }
	
private:
    Function * _handler;
};

__END_SYS

#endif
