package org.omni.service;

// TODO: Auto-generated Javadoc
/**
 * The Class ServiceCenterManager.
 */
public class ServiceCenterManager implements ServiceCenterManagerMBean{
	
	/** The sc. */
	private ServiceCenter sc;

	/**
	 * Instantiates a new service center manager.
	 */
	public ServiceCenterManager() {
		sc = ServiceCenter.getServiceCenter();
	}

	/* (non-Javadoc)
	 * @see org.omni.service.ServiceCenterManagerMBean#stopService(java.lang.String)
	 */
	public boolean stopService(String serviceName) {
		return sc.stopService(serviceName);
	}

	/* (non-Javadoc)
	 * @see org.omni.service.ServiceCenterManagerMBean#startService(java.lang.String)
	 */
	public boolean startService(String serviceName) {
		return sc.startService(serviceName);
	}

	/* (non-Javadoc)
	 * @see org.omni.service.ServiceCenterManagerMBean#startService(java.lang.String, java.lang.String)
	 */
	public boolean startService(String serviceGroup, String serviceName) {
		return sc.startService(serviceGroup, serviceName);
	}

	/* (non-Javadoc)
	 * @see org.omni.service.ServiceCenterManagerMBean#stopService(java.lang.String, java.lang.String)
	 */
	public boolean stopService(String serviceGroup, String serviceName) {
		return sc.stopService(serviceGroup, serviceName);
	}

	/* (non-Javadoc)
	 * @see org.omni.service.ServiceCenterManagerMBean#stopServiceGroup(java.lang.String)
	 */
	public boolean stopServiceGroup(String groupName) {
		return sc.stopServiceGroup(groupName);
	}

	/* (non-Javadoc)
	 * @see org.omni.service.ServiceCenterManagerMBean#startServiceGroup(java.lang.String)
	 */
	public boolean startServiceGroup(String groupName) {
		return sc.startServiceGroup(groupName);
	}

	/* (non-Javadoc)
	 * @see org.omni.service.ServiceCenterManagerMBean#reportStatus()
	 */
	public String reportStatus() {
		return sc.reportStatus().toString();
	}

}
