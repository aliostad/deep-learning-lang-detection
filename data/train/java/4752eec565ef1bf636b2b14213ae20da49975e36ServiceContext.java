package com.dianping.service.spi.lifecycle;

import com.dianping.service.spi.ServiceBinding;
import com.dianping.service.spi.ServiceProvider;

public interface ServiceContext<T> {
	public T getService();

	public ServiceBinding getServiceBinding();

	public ServiceProvider<T> getServiceProvider();

	public ServiceState getState();

	public void setService(T service);

	public void setServiceBinding(ServiceBinding binding);

	public void setServiceProvider(ServiceProvider<T> provider);

	public void setState(ServiceState state);
}