package structural_patterns.service_locator.src;

import java.util.HashMap;
import java.util.Map;

public class ServiceCache {

	private Map<String, ServiceA> serviceCache;

	public ServiceCache() {
		this.serviceCache = new HashMap<String, ServiceA>();
	}

	public ServiceA getService(String serviceName) {
		ServiceA serviceA = null;
		for (String serviceJndiName : this.serviceCache.keySet()) {
			if (serviceJndiName.equals(serviceName)) {
				serviceA = this.serviceCache.get(serviceJndiName);
				System.out.println("(cache call) Fetched service " + serviceA.getName() + "(" + serviceA.getId() + ") from cache... !");
			}
		}
		return serviceA;
	}

	public void putService(ServiceA newService) {
		this.serviceCache.put(newService.getName(), newService);
	}
}
