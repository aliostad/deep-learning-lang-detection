#include "Debug.h"
#include "ServiceLocator.h"
#include "EventDispatcher.h"
#include "TracerService.h"
#include "ObjectPool.h"
#include "SimulationConfig.h"

ServiceLocator::ServiceLocator() {}

ServiceLocator& ServiceLocator::instance() {
	static ServiceLocator instance_;
	return instance_;
}

void ServiceLocator::registerDispatcherService(EventDispatcher* svc) {
	dispatcherService = svc;
}

EventDispatcher* ServiceLocator::findDispatcherService() {
	return dispatcherService;
}

void ServiceLocator::registerRandomService(RandomService<int>* svc) {
	randomService = svc;
}

RandomService<int>* ServiceLocator::findRandomService() {
	return randomService;
}

void ServiceLocator::registerTracerService(TracerService* svc) {
	tracerService = svc;
}

TracerService* ServiceLocator::findTracerService() {
	return tracerService;
}