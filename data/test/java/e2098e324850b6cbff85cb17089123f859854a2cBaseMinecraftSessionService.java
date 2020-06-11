package com.eitetu.minecraft.server.util.authlib.minecraft;

import com.eitetu.minecraft.server.util.authlib.AuthenticationService;

public abstract class BaseMinecraftSessionService implements MinecraftSessionService {
	private final AuthenticationService authenticationService;

	protected BaseMinecraftSessionService(AuthenticationService authenticationService) {
		this.authenticationService = authenticationService;
	}

	public AuthenticationService getAuthenticationService() {
		return this.authenticationService;
	}

}
