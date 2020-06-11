package edu.mcm.cas757.service;

public class ServiceLocator {
	private IUserService userService;
	private IObsDataService obsDataService;


	public IObsDataService getObsDataService() {
		return obsDataService;
	}

	public void setObsDataService(IObsDataService obsDataService) {
		this.obsDataService = obsDataService;
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}
	
	

}
