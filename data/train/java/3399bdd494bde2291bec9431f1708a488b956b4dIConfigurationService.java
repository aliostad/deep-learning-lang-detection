package com.ymarq.eu.common;

/**
 * Created by eu on 12/13/2014.
 */
public interface IConfigurationService {
    /// <summary>
    /// Initialized configuration
    /// </summary>
    void Initialize();

    /// <summary>
    /// Authentication service
    /// </summary>
    IAuthenticationService AuthenticationService = null;
    /// <summary>
    /// Product service
    /// </summary>
    IProductService ProductionService = null;
    /// <summary>
    /// Messaging service
    /// </summary>
    IMessagingService MessagingService = null;

    public IAuthenticationService getAuthenticationService();

    public IProductService getProductionService();

    public IMessagingService getMessagingService();

    public void setAuthenticationService(IAuthenticationService iAuthenticationService);

    public void setProductionService(IProductService iIProductService);

    public void setMessagingService(IMessagingService iMessagingService);
}

