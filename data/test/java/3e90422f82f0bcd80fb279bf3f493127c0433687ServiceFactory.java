/*
 * 
 */
package cscie97.asn4.squaredesk.authentication;


/**
 * A factory for creating Service objects.
 */
public final class ServiceFactory {

	/**
	 * Instantiates a new service factory.
	 */
	public ServiceFactory() {
	}
	
	/**
	 * Creates a new Service object.
	 *
	 * @param serviceId the service id
	 * @param serviceName the service name
	 * @param serviceDescription the service description
	 * @return the service
	 */
	public static Service createService( String serviceId, String serviceName,
			String serviceDescription ) {
		Service serviceObj = new Service(serviceId, serviceName, serviceDescription);
		return serviceObj; 
	}

}
