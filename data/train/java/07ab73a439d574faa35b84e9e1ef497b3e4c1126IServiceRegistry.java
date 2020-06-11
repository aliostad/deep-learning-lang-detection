package ist.smartoffice.osgi.registries;

/**
 * The Interface IServiceRegistry.
 * 
 * @author Pedro Domingues (pedro.domingues@ist.utl.pt)
 * 
 * @param <T>
 *            the generic type
 */
public interface IServiceRegistry<T> {

	/**
	 * Adds the service listener.
	 * 
	 * @param listener
	 *            the listener
	 */
	public abstract void addServiceListener(ServiceRegistryListener listener);

	/**
	 * Removes the service listener.
	 * 
	 * @param listener
	 *            the listener
	 */
	public abstract void removeServiceListener(ServiceRegistryListener listener);

	/**
	 * Modify service.
	 * 
	 * @param serviceName
	 *            the service name
	 * @param service
	 *            the service
	 */
	public abstract void modifyService(String serviceName, T service);

	/**
	 * Removes the service.
	 * 
	 * @param serviceName
	 *            the service name
	 */
	public abstract void removeService(String serviceName);

	/**
	 * Adds the service.
	 * 
	 * @param serviceName
	 *            the service name
	 * @param service
	 *            the service
	 */
	public abstract void addService(String serviceName, T service);

	/**
	 * Gets the registered services names.
	 * 
	 * @return the registered services names
	 */
	public abstract String[] getRegisteredServicesNames();

	/**
	 * Gets the service.
	 * 
	 * @param serviceName
	 *            the service name
	 * @return the service
	 */
	public abstract T getService(String serviceName);

	/**
	 * Listener that receives notifications on lumina OSGi service's updates.
	 * 
	 * @see ServiceRegistryEvent
	 */
	public interface ServiceRegistryListener {

		/**
		 * Notifies service added.
		 * 
		 * @param serviceName
		 *            the service name
		 */
		public void serviceAdded(String serviceName);

		/**
		 * Notifies service modified.
		 * 
		 * @param serviceName
		 *            the service name
		 */
		public void serviceModified(String serviceName);

		/**
		 * Notifies service removed.
		 * 
		 * @param serviceName
		 *            the service name
		 */
		public void serviceRemoved(String serviceName);
	}
}