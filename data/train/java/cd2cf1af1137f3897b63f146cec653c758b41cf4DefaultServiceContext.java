package com.dianping.service.spi.lifecycle;

import com.dianping.service.spi.ServiceBinding;
import com.dianping.service.spi.ServiceProvider;

public class DefaultServiceContext<T> implements ServiceContext<T> {
	private ServiceState m_state;

	private T m_service;

	private ServiceProvider<T> m_serviceProvider;

	private ServiceBinding m_serviceBinding;

	@Override
	public T getService() {
		return m_service;
	}

	@Override
	public ServiceBinding getServiceBinding() {
		return m_serviceBinding;
	}

	@Override
	public ServiceProvider<T> getServiceProvider() {
		return m_serviceProvider;
	}

	@Override
	public ServiceState getState() {
		return m_state;
	}

	@Override
	public void setService(T service) {
		m_service = service;
	}

	@Override
	public void setServiceBinding(ServiceBinding serviceBinding) {
		m_serviceBinding = serviceBinding;
	}

	@Override
	public void setServiceProvider(ServiceProvider<T> provider) {
		m_serviceProvider = provider;
	}

	@Override
	public void setState(ServiceState state) {
		m_state = state;
	}
}
