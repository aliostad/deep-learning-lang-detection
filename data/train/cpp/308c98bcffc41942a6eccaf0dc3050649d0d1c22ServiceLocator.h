/// Gio Carlo Cielo Borje
/// 41894135

#ifndef SERVICE_LOCATOR_H
#define SERVICE_LOCATOR_H

#include "RandomService.h"

class EventDispatcher;
class TracerService;

class ObjectPool;
struct SimulationConfig;

class ServiceLocator {
public:
	static ServiceLocator& instance();

	void registerDispatcherService(EventDispatcher* svc);
	EventDispatcher* findDispatcherService();

	void registerRandomService(RandomService<int>* svc);
	RandomService<int>* findRandomService();

	void registerTracerService(TracerService* svc);
	TracerService* findTracerService();
private:
	ServiceLocator();
	ServiceLocator(const ServiceLocator&);
	ServiceLocator& operator=(const ServiceLocator&);

	EventDispatcher* dispatcherService;
	RandomService<int>* randomService;
	TracerService* tracerService;
};

#endif