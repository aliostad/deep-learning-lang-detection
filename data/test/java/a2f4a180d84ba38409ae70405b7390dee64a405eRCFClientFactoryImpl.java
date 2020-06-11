package com.riskcare.forums.client;

import com.riskcare.forums.server.service.AuthenticationService;
import com.riskcare.forums.server.service.StatusService;

public class RCFClientFactoryImpl implements RCFClientFactory {

	private AuthenticationService authenticationService;
	private StatusService statusService;

	public AuthenticationService getAuthenticationService() {
		return authenticationService;
	}

	@Override
	public void setAuthenticationService(
			AuthenticationService authenticationService) {
		this.authenticationService = authenticationService;
	}

	public StatusService getStatusService() {
		return statusService;
	}

	public void setStatusService(StatusService statusService) {
		this.statusService = statusService;
	}
	
}
