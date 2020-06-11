package com.opencanarias.mset.internal.repository.benchmark;

import com.opencanarias.mset.repository.benchmark.IModelRepository;
import com.opencanarias.mset.repository.benchmark.IModelRepositoryRegistry;

/**
 * This class servers to inject {@link IModelRepository} instances 
 * (registered using OSGi services) into {@link IModelRepositoryRegistry}
 * <p>
 * The component definition is found on OSGI-INF/modelRepositoryRegistration.xml
 * 
 * @author vroldan
 *
 */
public class ModelRepositoryRegistration {
	
	public void addModelRepository(IModelRepository repository) {
		IModelRepositoryRegistry.INSTANCE.addModelRepository(repository);
	}
	
	public void removeModelRepository(IModelRepository repository) {
		IModelRepositoryRegistry.INSTANCE.removeModelRepository(repository);
	}
	
}
