package org.socialsignin.provider.strategy.connectionrepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.social.connect.ConnectionRepository;


public class SpecifiedConnectionRepositoryStrategy implements
		ConnectionRepositoryStrategy {

	@Autowired
	private ConnectionRepository connectionRepository;
	

	public SpecifiedConnectionRepositoryStrategy()
	{
		
	}
	
	public void setConnectionRepository(ConnectionRepository connectionRepository) {
		this.connectionRepository = connectionRepository;
	}

	public SpecifiedConnectionRepositoryStrategy(ConnectionRepository connectionRepository)
	{
		this.connectionRepository  = connectionRepository;
	}
	
	@Override
	public ConnectionRepository getAuthenticatedConnectionRepository() {
		return connectionRepository;
	}

	

}
