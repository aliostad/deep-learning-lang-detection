/*
 * Created On:  16-Aug-07 8:55:15 AM
 */
package com.thinkparity.ophelia.model.util.service;

import java.lang.reflect.Proxy;

import com.thinkparity.service.*;
import com.thinkparity.service.client.ClientServiceFactory;

/**
 * <b>Title:</b>thinkParity Ophelia Model Service Client<br>
 * <b>Description:</b>A service client for the ophelia model. Uses a facade
 * pattern to hide retry complexity from the client.<br>
 * 
 * @author raymond@thinkparity.com
 * @version 1.1.2.1
 */
public final class ServiceFactory implements
        com.thinkparity.service.ServiceFactory {

    /** A service factory. */
    private final com.thinkparity.service.ServiceFactory factory;

    /** A service client retry handler. */
    private ServiceRetryHandler retryHandler;

    /**
     * Create ServiceFactory.
     *
     */
    public ServiceFactory() {
        super();
        this.factory = ClientServiceFactory.getInstance();
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getArtifactService()
     *
     */
    @Override
    public ArtifactService getArtifactService() {
        return (ArtifactService) newProxyInstance(ArtifactService.class,
                factory.getArtifactService());
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getBackupService()
     *
     */
    @Override
    public BackupService getBackupService() {
        return (BackupService) newProxyInstance(BackupService.class,
                factory.getBackupService());
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getContactService()
     *
     */
    @Override
    public ContactService getContactService() {
        return (ContactService) newProxyInstance(ContactService.class,
                factory.getContactService());
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getContainerService()
     *
     */
    @Override
    public ContainerService getContainerService() {
        return (ContainerService) newProxyInstance(ContainerService.class,
                factory.getContainerService());
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getCryptoService()
     *
     */
    @Override
    public CryptoService getCryptoService() {
        return (CryptoService) newProxyInstance(CryptoService.class,
                factory.getCryptoService());
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getMigratorService()
     *
     */
    @Override
    public MigratorService getMigratorService() {
        return (MigratorService) newProxyInstance(MigratorService.class,
                factory.getMigratorService());
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getProfileService()
     *
     */
    @Override
    public ProfileService getProfileService() {
        return (ProfileService) newProxyInstance(ProfileService.class,
                factory.getProfileService());
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getQueueService()
     *
     */
    @Override
    public QueueService getQueueService() {
        return (QueueService) newProxyInstance(QueueService.class,
                factory.getQueueService());
    }

    /**
     * Obtain retryHandler.
     *
     * @return A ServiceRetryHandler.
     */
    public ServiceRetryHandler getRetryHandler() {
        return retryHandler;
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getRuleService()
     *
     */
    @Override
    public RuleService getRuleService() {
        return (RuleService) newProxyInstance(RuleService.class,
                factory.getRuleService());
    }

    /**
     * Obtain a session service.
     * 
     * @return An instance of <code>SessionService</code>.
     */
    public SessionService getSessionService() {
        return (SessionService) newProxyInstance(SessionService.class,
                factory.getSessionService());
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getStreamService()
     *
     */
    @Override
    public StreamService getStreamService() {
        return (StreamService) newProxyInstance(StreamService.class,
                factory.getStreamService());
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getSystemService()
     *
     */
    @Override
    public SystemService getSystemService() {
        return (SystemService) newProxyInstance(SystemService.class,
                factory.getSystemService());
    }

    /**
     * @see com.thinkparity.service.ServiceFactory#getUserService()
     *
     */
    @Override
    public UserService getUserService() {
        return (UserService) newProxyInstance(UserService.class,
                factory.getUserService());
    }

    /**
     * Set retryHandler.
     *
     * @param retryHandler
     *		A <code>ServiceRetryHandler</code>.
     */
    public void setRetryHandler(final ServiceRetryHandler retryHandler) {
        this.retryHandler = retryHandler;
    }

    /**
     * Obtain the current thread's context class loader.
     * 
     * @return A <code>ClassLoader</code>.
     */
    private ClassLoader getLoader() {
        return Thread.currentThread().getContextClassLoader();
    }

    /**
     * Create the service client proxy implementation.
     * 
     * @param serviceClass
     *            A service <code>Class</code>.
     * @param impl
     *            A service implementation <code>Object</code>.
     * @return A service proxy implementation.
     */
    private Object newProxyInstance(final Class<?> serviceClass,
            final Object serviceImpl) {
        return Proxy.newProxyInstance(getLoader(),
                new Class<?>[] { serviceClass },
                new ServiceProxy(retryHandler, serviceImpl));
    }
}
