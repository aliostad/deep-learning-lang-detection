#include <iostream>
#include "chainOfResponsiblity.h"

handler::~handler()
{
    delete m_pHandler;
    m_pHandler = NULL;
}

void firstConcreatHandler::handlerRequest()
{
    if (NULL != m_pHandler)
    {
        m_pHandler->handlerRequest();
    }
    else
        std::cout << "handlerRequest by firstConcreatHandler" << std::endl;
}
void secondConcreateHandler::handlerRequest()
{
    if (NULL != m_pHandler)
    {
        m_pHandler->handlerRequest();
    }
    else
        std::cout << "handlerRequest by secondConcreateHandler" << std::endl;
}
