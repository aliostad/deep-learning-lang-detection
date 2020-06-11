package nl.idgis.publisher.service.provisioning.messages;

import nl.idgis.publisher.service.provisioning.ServiceInfo;

public class RemoveStagingService extends UpdateServiceInfo {

	private static final long serialVersionUID = 7318696449642365205L;
	
	private final ServiceInfo serviceInfo;

	public RemoveStagingService(ServiceInfo serviceInfo) {
		this.serviceInfo = serviceInfo;
	}

	public ServiceInfo getServiceInfo() {
		return serviceInfo;
	}

	@Override
	public String toString() {
		return "RemoveStagingService [serviceInfo=" + serviceInfo + "]";
	}
}
