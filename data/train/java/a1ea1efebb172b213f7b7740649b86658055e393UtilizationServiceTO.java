package perfsonarserver.database.mongoDB_responseTO;

public class UtilizationServiceTO
{
	/** Service Name */
	private String serviceName;

	public UtilizationServiceTO()
	{
	}

	/**
	 * constructor
	 * 
	 * @param Service Name
	 */
	public UtilizationServiceTO(String serviceName)
	{
		this.serviceName = serviceName;
	}

	/**
	 * @return the Service Name
	 */
	public String getServiceName()
	{
		return serviceName;
	}

	/**
	 * @param Service
	 *            Name the Service Name to set
	 */
	public void setServiceName(String serviceName)
	{
		this.serviceName = serviceName;
	}
}