#ifndef _CONCRETE_HANDLER_H_
#define _CONCRETE_HANDLER_H_

#include "handler.h"

#include <iostream>

class ConcreteHandlerA : public Handler
{
private:

public:
    ConcreteHandlerA()
    {}

    virtual ~ConcreteHandlerA()
    {}

    virtual void on_handler()
    {
        std::cout << "ConcreteHandlerA processed" << std::endl;
        if (m_successor) {
            m_successor->on_handler();
        }
    }
};


class ConcreteHandlerB : public Handler
{
private:

public:
    ConcreteHandlerB()
    {}

    virtual ~ConcreteHandlerB()
    {}

    virtual void on_handler()
    {
        std::cout << "ConcreteHandlerB processed" << std::endl;
        if (m_successor) {
            m_successor->on_handler();
        }
    }
};

#endif /* end of include guard: _CONCRETE_HANDLER_H_ */
