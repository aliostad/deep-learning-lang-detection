package com.thoughtworks.yak;

import com.thoughtworks.yak.injectors.ConstructorInjector;

import java.util.*;

public class CoreServiceContainer implements ServiceContainer {
    private final Set<ServiceModule> serviceModules = new HashSet<ServiceModule>();
    private final Map<ServiceDefinition<?>, ServiceFactory<?>> serviceFactoryMap = new HashMap<ServiceDefinition<?>, ServiceFactory<?>>();

    public CoreServiceContainer(ServiceModule... modules) {
        serviceModules.addAll(Arrays.asList(modules));
        for (ServiceModule module : modules) {
            module.initialize();
        }
    }

    @Override
    public <T> T getService(Class<T> serviceType) {
        return getService(serviceType, null);
    }

    @Override
    public <T> T getService(Class<T> serviceType, Enum key) {
        ServiceDefinition<T> foundDefinition = findService(serviceType, key);

        if (foundDefinition != null) {
            ServiceFactory<T> serviceFactory = getServiceFactory(foundDefinition);
            return serviceFactory.createService(this, foundDefinition);
        }

        return null;
    }

    @Override
    public boolean providesService(Class<?> service) {
        return providesService(service, null);
    }

    @Override
    public boolean providesService(Class<?> service, Enum key) {
        return findService(service, key) != null;
    }

    private <T> ServiceDefinition<T> findService(Class<T> serviceType, Enum key) {
        for (ServiceModule module : serviceModules) {
            ServiceDefinition definition = module.getService(serviceType, key);
            if (definition != null) {
                return definition;
            }
        }

        return null;
    }

    private <T> ServiceFactory<T> getServiceFactory(ServiceDefinition<T> serviceDefinition) {
        if (!serviceFactoryMap.containsKey(serviceDefinition)) {
            ServiceFactory<T> serviceFactory = new ConstructorInjector();
            serviceFactoryMap.put(serviceDefinition, serviceFactory);
        }

        return (ServiceFactory<T>) serviceFactoryMap.get(serviceDefinition);
    }
}
