package com.epam.service.factory;

import com.epam.service.CatalogService;
import com.epam.service.ClientService;
import com.epam.service.impl.CatalogServiceImpl;
import com.epam.service.impl.ClientServiceImpl;

public final class ServiceFactory {
    private static final ServiceFactory instance = new ServiceFactory();

    private final ClientService clientService = new ClientServiceImpl();
    private final CatalogService catalogService = new CatalogServiceImpl();

    private ServiceFactory(){}

    public static ServiceFactory getInstance(){
        return instance;
    }

    public ClientService getClientService(){
        return clientService;
    }
    
    public CatalogService getCatalogService(){
        return catalogService;
    }
}