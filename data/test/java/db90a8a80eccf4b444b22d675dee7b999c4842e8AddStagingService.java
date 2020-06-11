package nl.idgis.publisher.service.provisioning.messages;

import nl.idgis.publisher.service.provisioning.ServiceInfo;

public class AddStagingService extends UpdateServiceInfo {	

	private static final long serialVersionUID = 4008542255037214299L;
	
	private final ServiceInfo serviceInfo;

	public AddStagingService(ServiceInfo serviceInfo) {
		this.serviceInfo = serviceInfo;
	}

	public ServiceInfo getServiceInfo() {
		return serviceInfo;
	}

	@Override
	public String toString() {
		return "AddStagingService [serviceInfo=" + serviceInfo + "]";
	}
}
