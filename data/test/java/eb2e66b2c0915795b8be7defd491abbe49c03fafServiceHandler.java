package items;


import displayArea.ServicesDisplayer;

public class ServiceHandler {
	private ServicesDisplayer serviceDisplayer;

	public void startService(){
		
		serviceDisplayer.getServiceListArea().StartServiceButton();
	}
	
	public void stopService() {
		//stop service - module 1
		serviceDisplayer.getServiceListArea().StopServiceButton();
	}
	
	public ServicesDisplayer getServiceDisplayer() {
		return serviceDisplayer;
	}

	public void setServiceDisplayer(ServicesDisplayer serviceDisplayer) {
		this.serviceDisplayer = serviceDisplayer;
	}



}
