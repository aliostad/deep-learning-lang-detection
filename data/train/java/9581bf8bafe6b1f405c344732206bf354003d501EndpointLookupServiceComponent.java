package org.wso2.carbon.registry.samples.services;
  
import org.wso2.carbon.registry.core.service.RegistryService;
  
/**
 * @scr.component name="org.wso2.carbon.registry.samples.endpoint.lookup" immediate="true"
 * @scr.reference name="registry.service" interface="org.wso2.carbon.registry.core.service.RegistryService"
 * cardinality="1..1" policy="dynamic" bind="setRegistryService" unbind="unsetRegistryService"
 */
public class EndpointLookupServiceComponent {
  
    private static RegistryService registryService;
  
    protected void setRegistryService(RegistryService registryService) {
        EndpointLookupServiceComponent.registryService = registryService;
    }
  
    protected void unsetRegistryService(RegistryService registryService) {
        EndpointLookupServiceComponent.registryService = null;
    }
  
    public static RegistryService getRegistryService() {
        return registryService;
    }
}