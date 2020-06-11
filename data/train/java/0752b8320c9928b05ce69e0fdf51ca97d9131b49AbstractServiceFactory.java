package org.quadrate.curiosity.raspy.serviceFactory;

import org.quadrate.curiosity.raspy.network.NetworkService;
import org.quadrate.curiosity.raspy.system.SystemService;

public abstract class AbstractServiceFactory implements ServiceFactory {
    private final SystemService systemService;
    private final NetworkService networkService;

    protected AbstractServiceFactory() {
        systemService = createSystemService();
        networkService = createNetworkService();
    }

    @Override
    public SystemService getSystemService() {
        return systemService;
    }

    @Override
    public NetworkService getNetworkService() {
        return networkService;
    }

    protected abstract SystemService createSystemService();

    protected abstract NetworkService createNetworkService();
}
