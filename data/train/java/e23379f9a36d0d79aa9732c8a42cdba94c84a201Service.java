/*
 * 
 */
package cscie97.asn4.squaredesk.authentication;


/**
 * The Class Service.
 *
 * @author vinodhalaharvi
 */
/**
 * @author vinodhalaharvi
 *
 */
public class Service {
    
    /**
	 * Instantiates a new service.
	 *
	 * @param serviceId
	 *            the service id
	 * @param serviceName
	 *            the service name
	 * @param serviceDescription
	 *            the service description
	 */
    public Service(String serviceId, String serviceName,
			String serviceDescription) {
		super();
		this.serviceId = serviceId;
		this.serviceName = serviceName;
		this.serviceDescription = serviceDescription;
	}
	
	/**
	 * Gets the service id.
	 *
	 * @return the service id
	 */
	public String getServiceId() {
		return serviceId;
	}
	
	/**
	 * Sets the service id.
	 *
	 * @param serviceId
	 *            the new service id
	 */
	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}
	
	/**
	 * Gets the service name.
	 *
	 * @return the service name
	 */
	public String getServiceName() {
		return serviceName;
	}
	
	/**
	 * Sets the service name.
	 *
	 * @param serviceName
	 *            the new service name
	 */
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
	
    /* (non-Javadoc)
     * @see java.lang.Object#equals(java.lang.Object)
     */
    @Override
    public boolean equals(Object obj) {
            Service t = (Service) obj;
            return (
                            (obj != null) &&
                            (obj instanceof User) &&
                            t.getServiceId().equals((getServiceId()))
                            );

    }

    /* (non-Javadoc)
     * @see java.lang.Object#hashCode()
     */
    @Override
    public int hashCode() {
            return getServiceId().hashCode();
    }

	
	/**
	 * Gets the service description.
	 *
	 * @return the service description
	 */
	public String getServiceDescription() {
		return serviceDescription;
	}
	
	/**
	 * Sets the service description.
	 *
	 * @param serviceDescription
	 *            the new service description
	 */
	public void setServiceDescription(String serviceDescription) {
		this.serviceDescription = serviceDescription;
	}
	
	/** The service id. */
	private String serviceId;
    
    /** The service name. */
    private String serviceName;
    
    /** The service description. */
    private String serviceDescription;

    
}

