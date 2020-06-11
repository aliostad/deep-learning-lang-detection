package ar.edu.unicen.ringo.agent;

import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceReference;
import org.osgi.util.tracker.ServiceTrackerCustomizer;

import ar.edu.unicen.ringo.agent.api.AgentService;
import ar.edu.unicen.ringo.persistence.PersistenceService;

/**
 * A {@link ServiceTrackerCustomizer} that tracks the registration of the
 * persistence service.
 * @author ps
 */
public class PersistenceServiceTracker implements
		ServiceTrackerCustomizer<PersistenceService, PersistenceService> {

	private final AgentService service;

	private final BundleContext bc;

	public PersistenceServiceTracker(BundleContext context, AgentService service) {
		this.service = service;
		this.bc = context;
	}

	@Override
	public PersistenceService addingService(
			ServiceReference<PersistenceService> reference) {
		PersistenceService service = bc.getService(reference);
		this.service.setPersistenceService(service);
		return service;
	}

	@Override
	public void modifiedService(ServiceReference<PersistenceService> reference,
			PersistenceService service) {
	}

	@Override
	public void removedService(ServiceReference<PersistenceService> reference,
			PersistenceService service) {
		this.service.setPersistenceService(null);
	}

}
