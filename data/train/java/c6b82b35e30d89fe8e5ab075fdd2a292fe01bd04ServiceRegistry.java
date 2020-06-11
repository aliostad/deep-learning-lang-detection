package com.dianping.service.spi;

import java.util.List;

import com.dianping.service.spi.lifecycle.ServiceLifecycle;

public interface ServiceRegistry {
	public ServiceBinding getServiceBinding(Class<?> serviceType, String id);

	public List<ServiceBinding> getServiceBindings(Class<?> serviceType);

	public ServiceLifecycle getServiceLifecycle(Class<?> serviceType);

	public <T> ServiceProvider<T> getServiceProvider(Class<T> serviceType);

	public boolean hasServiceBinding(Class<?> serviceType, String id);

	public void setServiceBinding(Class<?> serviceType, String alias, ServiceBinding binding);
}
