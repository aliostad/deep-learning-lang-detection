#include "includes/servicelocator.h"

void LogLocator::initialize()
{
    std::shared_ptr<LogEngine> null_service(new NullLogEngine);
    service_ = null_service;
}

std::shared_ptr<LogEngine> LogLocator::GetLogEngine()
{
    return service_;
}

void LogLocator::provide(std::shared_ptr<LogEngine> service)
{
    if (!service)
    {
        initialize();
    }
    else
    {
        service_ = service;
        service->RecieveNotification();
    }

    if (GetLogEngine()->getLogFile().empty())
    {
        GetLogEngine()->setLogFile("debug.log");
    }
}

LogLocator::~LogLocator()
{
}


///////////////////////////////////////////////////////////////////////////////


std::shared_ptr<LogEngine> Services::GetLogEngine()
{
    return LogLocator::GetLogEngine();
}

void Services::initialize()
{
    if (LogLocator::GetLogEngine())
    {
        LogLocator::GetLogEngine()->RecieveNotification();
    }
}

Services::~Services()
{
}
