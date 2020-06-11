package core.service.util;

import core.service.annotation.Service;
import core.service.exception.ServiceException;

public class ServiceUtil
{

	/**
	 * Determine service name for the given service interface.
	 * 
	 * <code>ServiceException</code> will be thrown if interface is not annotated
	 * 
	 * @param serviceInterface
	 * @return
	 */
	public String getServiceName(Class serviceInterface) {
		Service serviceAnnotation = (Service) serviceInterface.getAnnotation(Service.class);
		if (serviceAnnotation == null) {
			throw new ServiceException("Interface is not a service (class="
					+ serviceInterface.getName()
					+ ")");
		}
		return serviceAnnotation.name().length() < 1 ? serviceInterface.getName() : serviceAnnotation.name();
	}
}
