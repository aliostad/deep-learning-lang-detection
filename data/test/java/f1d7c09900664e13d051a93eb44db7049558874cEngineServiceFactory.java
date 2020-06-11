package org.eclipsetrader.core.internal.ats.engines;

import org.eclipsetrader.core.ats.engines.IEngineService;
import org.osgi.framework.Bundle;
import org.osgi.framework.ServiceFactory;
import org.osgi.framework.ServiceRegistration;

public class EngineServiceFactory implements ServiceFactory<IEngineService> {

	IEngineService serviceInstance = null;
	
	@Override
	public IEngineService getService(Bundle bundle,
			ServiceRegistration<IEngineService> registration) {
		if( serviceInstance == null ) {
			serviceInstance = new EngineService();
			serviceInstance.startUp();
		}
		return serviceInstance;
	}

	@Override
	public void ungetService(Bundle bundle,
			ServiceRegistration<IEngineService> registration,
			IEngineService service) {
		// TODO Auto-generated method stub
		
	}
	
	public void dispose(){
		if( serviceInstance != null ){
			serviceInstance.shutDown();
			serviceInstance = null;
		}
	}

}
