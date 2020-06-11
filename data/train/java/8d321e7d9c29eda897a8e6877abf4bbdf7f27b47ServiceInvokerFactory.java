package evymind.vapor.server.invoker;

import evymind.vapor.core.utils.component.Lifecycle;

public interface ServiceInvokerFactory extends Lifecycle {
	
	<T> void addService(Class<T> serviceInterface, T serviceInstance);
	
	<T> void addService(Class<T> serviceInterface, Class<? extends T> serviceImplementation);
	
	<T> void addService(Class<T> serviceInterface, Class<? extends T> serviceImplementation, ServiceScope scope);

    ServiceDefinition[] getServices();

	void setServices(ServiceDefinition[] serviceDefinitions);

	ServiceInvoker getServiceInvoker(Class<?> serviceInterface);
	
	ServiceInvoker getServiceInvoker(String serviceName);

}
