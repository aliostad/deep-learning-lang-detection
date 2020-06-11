package ro.pub.cs.systems.pdsd.lab09.chatservice.model;

public class NetworkService {
	
	private String serviceName;
	private String serviceHost;
	private int servicePort;
	private int serviceType;
	
	public NetworkService() {
		serviceName = new String();
		serviceHost = null;
		servicePort = -1;
		serviceType = -1;
	}
	
	public NetworkService(
			String serviceName,
			String serviceHost,
			int servicePort,
			int serviceType) {
		this.serviceName = serviceName;
		this.serviceHost = serviceHost;
		if(this.serviceHost != null && this.serviceHost.startsWith("/")) {
			this.serviceHost = this.serviceHost.substring(1);
		}
		this.servicePort = servicePort;
		this.serviceType = serviceType;
	}
	
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
	
	public String getServiceName() {
		return serviceName;
	}
	
	public void setServiceHost(String serviceHost) {
		this.serviceHost = serviceHost;
		if(this.serviceHost.startsWith("/")) {
			this.serviceHost = this.serviceHost.substring(1);
		}
	}
	
	public String getServiceHost() {
		return serviceHost;
	}
	
	public void setServicePort(int servicePort) {
		this.servicePort = servicePort;
	}
	
	public int getServicePort() {
		return servicePort;
	}
	
	public void setServiceType(int serviceType) {
		this.serviceType = serviceType;
	}
	
	public int getServiceType() {
		return serviceType;
	}
	
	@Override
	public boolean equals(Object networkService) {
		if (networkService == null) {
			return false;
		}
		if (serviceName == null) {
			return false;
		}
		return serviceName.equals(((NetworkService)networkService).getServiceName());
	}
	
	@Override
	public String toString() {
		return ((serviceName != null) ? serviceName : "") + " " + serviceHost.toString() + ":" + String.valueOf(servicePort);
	}

}
