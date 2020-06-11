package org.ourgrid.peer.business.controller.ds;

import org.ourgrid.common.interfaces.DiscoveryService;

import br.edu.ufcg.lsd.commune.identification.ServiceID;


public class DiscoveryServiceData {

	private final ServiceID serviceID;
	
	private final DiscoveryService discoveryService;

	public DiscoveryServiceData( ServiceID serviceID, DiscoveryService discoveryService ) {
		this.serviceID = serviceID;
		this.discoveryService = discoveryService;
	}

	/**
	 * @return the serviceID
	 */
	public ServiceID getServiceID() {

		return serviceID;
	}

	/**
	 * @return the discoveryService
	 */
	public DiscoveryService getDiscoveryService() {

		return discoveryService;
	}
	
}
