package at.sti2.msee.discovery.core.common;

import at.sti2.msee.triplestore.ServiceRepositoryConfiguration;

public class ServiceDiscoveryConfiguration {

	private ServiceRepositoryConfiguration repositoryConfiguration = null;

	public ServiceDiscoveryConfiguration(){}
	
	public ServiceDiscoveryConfiguration(
			ServiceRepositoryConfiguration repositoryConfiguration) {
		this.repositoryConfiguration = repositoryConfiguration;
	}

	public void setRepositoryConfiguration(
			ServiceRepositoryConfiguration repositoryConfiguration) {
		this.repositoryConfiguration = repositoryConfiguration;
	}

	public ServiceRepositoryConfiguration getRepositoryConfiguration() {
		return this.repositoryConfiguration;
	}
}