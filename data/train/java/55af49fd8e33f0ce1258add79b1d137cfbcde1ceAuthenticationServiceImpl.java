package org.motechproject.server.svc.impl;

import org.motechproject.server.omod.AuthenticationService;
import org.motechproject.server.service.ContextService;
import org.openmrs.User;

public class AuthenticationServiceImpl implements AuthenticationService {

    ContextService contextService;

    public AuthenticationServiceImpl(ContextService contextService){
        this.contextService = contextService;
    }
    
    public User getAuthenticatedUser() {
        return contextService.getAuthenticatedUser();
    }
}
