package observers;

import items.ServiceHandler;

public class ServiceObserver {
	private ServiceHandler serviceHandler;


	public ServiceObserver(ServiceHandler serviceHandler) {
		setServiceHandler(serviceHandler);
	}

	public ServiceHandler getServiceHandler() {
		return serviceHandler;
	}

	public void setServiceHandler(ServiceHandler serviceHandler) {
		this.serviceHandler = serviceHandler;
	}

	public void startService(){
		serviceHandler.startService();
	}

	public void stop(){
		serviceHandler.stopService();
	}

}
