// EPOS Handler Utility Declarations

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

class Function_Handler: public Handler
{
public:
    Function_Handler(Function * h): _handler(h) {}
    ~Function_Handler() {}

    void operator()() { _handler(); }
	
private:
    Function * _handler;
};

__END_SYS

#endif
