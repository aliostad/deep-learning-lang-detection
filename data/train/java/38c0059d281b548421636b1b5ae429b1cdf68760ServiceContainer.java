package com.dianping.service;

import org.unidal.lookup.annotation.Inject;

import com.dianping.service.spi.ServiceManager;

public class ServiceContainer {
	@Inject
	private ServiceManager m_serviceManager;

	public <T> T lookup(Class<T> serviceType) throws ServiceNotAvailableException {
		return lookup(serviceType, null);
	}

	public <T> T lookup(Class<T> serviceType, String alias) throws ServiceNotAvailableException {
		try {
			T service = m_serviceManager.getService(serviceType, alias);

			return service;
		} catch (Throwable e) {
			if (alias == null) {
				throw new ServiceNotAvailableException(String.format("Unable to get an avaliable service(%s)!",
				      serviceType.getName()), e);
			} else {
				throw new ServiceNotAvailableException(String.format("Unable to get an avaliable service(%s, %s)!",
				      serviceType.getName(), alias), e);
			}
		}
	}
}
