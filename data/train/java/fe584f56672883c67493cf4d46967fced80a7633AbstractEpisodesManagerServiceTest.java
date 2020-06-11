package org.kootox.episodesmanager.services;

import org.junit.Rule;

/**
 * @author jcouteau <couteau@codelutin.com>
 */
public class AbstractEpisodesManagerServiceTest {

    @Rule
    public FakeServiceContext serviceContext = new FakeServiceContext(getClass());

    public ServiceFactory serviceFactory = new ServiceFactory();

    public FixturesService fixtures = newService(FixturesService.class);

    public <E extends EpisodesManagerService> E newService(Class<E> serviceClass) {
        serviceContext.setServiceFactory(serviceFactory);
        E service = serviceFactory.newService(serviceClass, serviceContext);
        return service;
    }
}
