package at.sti2.msee.registration.core.configuration;

import at.sti2.msee.triplestore.ServiceRepositoryConfiguration;

public class ServiceRegistrationConfiguration {
	
	private ServiceRepositoryConfiguration repositoryConfiguration = null;

	public void setRepositoryConfiguration(ServiceRepositoryConfiguration repositoryConfiguration)
	{
		this.repositoryConfiguration = repositoryConfiguration;
	}

	public ServiceRepositoryConfiguration getRepositoryConfiguration()
	{
		return this.repositoryConfiguration;
	}	
}