package no.hal.eclipsky.services.monitoring;

import java.util.ArrayList;
import java.util.Collection;

import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ReferenceCardinality;

public class CompositeServiceLogger implements ServiceLogger {

	private Collection<ServiceLogger> serviceLoggers;
	
	public boolean isEmpty() {
		return serviceLoggers == null || serviceLoggers.isEmpty();
	}
	
	@Reference(
		cardinality = ReferenceCardinality.MULTIPLE,
		unbind="removeServiceLogger"
	)
	public synchronized void addServiceLogger(ServiceLogger serviceLogger) {
		if (serviceLoggers == null) {
			serviceLoggers = new ArrayList<ServiceLogger>();
		}
		serviceLoggers.add(serviceLogger);
	}
	
	public synchronized void removeServiceLogger(ServiceLogger serviceLogger) {
		if (serviceLoggers != null) {
			serviceLoggers.remove(serviceLogger);
		}
	}
	
	//

	@Override
	public void setServiceUri(String serviceUri) {
		if (serviceLoggers != null) {
			for (ServiceLogger serviceLogger : serviceLoggers) {
				serviceLogger.setServiceUri(serviceUri);
			}
		}
	}

	@Override
	public void serviceRequested(Object requestKey, String logKey, long timestamp) {
		if (serviceLoggers != null) {
			for (ServiceLogger serviceLogger : serviceLoggers) {
				serviceLogger.serviceRequested(requestKey, logKey, timestamp);
			}
		}
	}

	@Override
	public void serviceResponded(Object requestKey, String payload, long timestamp) {
		if (serviceLoggers != null) {
			for (ServiceLogger serviceLogger : serviceLoggers) {
				serviceLogger.serviceResponded(requestKey, payload, timestamp);
			}
		}
	}
	
	@Override
	public void serviceException(Object requestKey, Throwable e, long timestamp) {
		if (serviceLoggers != null) {
			for (ServiceLogger serviceLogger : serviceLoggers) {
				serviceLogger.serviceException(requestKey, e, timestamp);
			}
		}
	}
}
