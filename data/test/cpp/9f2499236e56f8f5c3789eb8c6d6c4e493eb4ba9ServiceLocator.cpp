
#include "ServiceLocator.h"

#include <thread>
#include <cassert>

__thread ServiceLocator* ServiceLocator::defaultLocator;

ServiceLocator::ServiceLocator() {
    messages = NULL;
    defaultLocator = NULL;
    eventQueue = NULL;
}

ServiceLocator::~ServiceLocator() {
    if(messages != NULL) {
        delete messages;
    }
    
    if(eventQueue != NULL) {
        delete eventQueue;
    }
}

void ServiceLocator::createMessageService() {
    messages = new MessageService();
}

void ServiceLocator::createEventQueue() {
    eventQueue = new EventQueue();
}

MessageService* ServiceLocator::locateMessageService() {
    if(messages == NULL) {
        ServiceLocator::createMessageService();
    }
    
    return messages;
}

EventQueue* ServiceLocator::locateEventService() {
    if(eventQueue == NULL) {
        ServiceLocator::createEventQueue();
    }
    
    return eventQueue;
}

Timer* ServiceLocator::locateTimerService() {
    return Timer::getTimer();
}

ServiceLocator* ServiceLocator::getDefaultLocator() {
    if(defaultLocator == NULL) {
        defaultLocator = new ServiceLocator();
    }
    
    return defaultLocator;
}

void testThread(int n, ServiceLocator* aDifferentThreadsLocator) {
    ServiceLocator* loc = ServiceLocator::getDefaultLocator();  
    ServiceLocator* loc2 = ServiceLocator::getDefaultLocator();
    Timer* timer1 = loc->locateTimerService();
    Timer* timer2 = loc2->locateTimerService();
    
    MessageService* mes1 = loc->locateMessageService();
    MessageService* mes2 = loc2->locateMessageService();

    assert(mes1 == mes2);
    mes1->publish("someMessage", StringMap());
    
    MessageService* mes3 = aDifferentThreadsLocator->locateMessageService();
    mes3->publish("aMessage", StringMap());
    
    EventQueue* eq = loc->locateEventService();
    eq->pushTimerEvent(loc->locateTimerService()->getTimeStamp());
    
    assert(loc == loc2);
    assert(loc != aDifferentThreadsLocator);
    assert(loc != NULL);
    assert(aDifferentThreadsLocator != NULL);
    
    assert(timer1 == timer2);
    
    assert(mes1 != NULL);
    assert(mes3 != NULL);
    assert(mes1 != mes3);
}

bool ServiceLocator::test() {
    bool result = true;
    
    int n = 0;
    
    ServiceLocator* loc = ServiceLocator::getDefaultLocator();
    
    std::thread thread1(testThread, ++n, loc);
    std::thread thread2(testThread, ++n, loc);
    
    thread1.join();
    thread2.join();
    
    return result;
}


