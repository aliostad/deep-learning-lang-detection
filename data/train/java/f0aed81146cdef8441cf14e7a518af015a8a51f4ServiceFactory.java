package de.tu_dresden.crowd_db.remote.crowd_flower.service;

public class ServiceFactory {

	private String secretKey;
	private JobService jobService;
	private DataService dataService;

	public ServiceFactory(String secretKey) {
		this.secretKey = secretKey;
	}
	
	public JobService getJobService() {
		if (null == jobService) {
			jobService = new JobService(secretKey);
		}
		return jobService;
	}
	
	public DataService getDataService() {
		if (null == dataService) {
			dataService = new DataService(secretKey);
		}		
		return dataService;
	}
	
}
