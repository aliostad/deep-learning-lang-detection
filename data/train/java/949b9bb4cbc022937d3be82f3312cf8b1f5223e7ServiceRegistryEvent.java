package eu.fittest.common.core.registry;


import eu.fittest.common.core.service.ILocalService;
import eu.fittest.common.core.service.IService;
import eu.fittest.common.core.service.ServiceEvent;


public class ServiceRegistryEvent extends ServiceEvent {
    
    private IService _service;
    private ServiceRegistryEventKind _kind;

    
    public ServiceRegistryEvent(final ILocalService source, final IService service, ServiceRegistryEventKind kind) {
        super(source);
        _service = service;
        _kind = kind;
    }

    
    public IService getService() {
        return _service;
    }

    public ServiceRegistryEventKind getKind(){
    	return _kind;
    }
}
