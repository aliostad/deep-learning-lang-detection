package com.rawpixil.eclipse.launchpad.internal.core.extended;

import com.rawpixil.eclipse.launchpad.core.IExtendedLaunchConfigurationRepository;

public enum ExtendedLaunchConfigurationRepositoryProvider {

	INSTANCE;

	private IExtendedLaunchConfigurationRepository repository;

	private ExtendedLaunchConfigurationRepositoryProvider() {
		this.repository = new ExtendedLaunchConfigurationRepository();
	}

	public IExtendedLaunchConfigurationRepository get() {
		return this.repository;
	}

}
