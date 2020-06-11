/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cosmos.acacia.service;

/**
 *
 * @author Miro
 */
public class LocalServiceException extends ServiceException {

    private ServiceDescriptor serviceDescriptor;

    public LocalServiceException(Throwable cause, ServiceDescriptor serviceDescriptor) {
        super(cause);
        this.serviceDescriptor = serviceDescriptor;
    }

    public ServiceDescriptor getServiceDescriptor() {
        return serviceDescriptor;
    }
}
