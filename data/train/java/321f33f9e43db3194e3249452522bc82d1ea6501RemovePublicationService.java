package nl.idgis.publisher.service.provisioning.messages;

import nl.idgis.publisher.service.provisioning.ServiceInfo;

public class RemovePublicationService extends UpdateServiceInfo {	

	private static final long serialVersionUID = -7679035797669470004L;
	
	private final ServiceInfo serviceInfo;

	public RemovePublicationService(ServiceInfo serviceInfo) {
		this.serviceInfo = serviceInfo;
	}

	public ServiceInfo getServiceInfo() {
		return serviceInfo;
	}

	@Override
	public String toString() {
		return "RemovePublicationService [serviceInfo=" + serviceInfo + "]";
	}
}
