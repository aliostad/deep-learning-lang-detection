package net.es.nsi.topology.translator.model;

import net.es.nsi.topology.translator.jaxb.configuration.ServiceDefinitionType;
import net.es.nsi.topology.translator.jaxb.nml.NmlSwitchingServiceType;

/**
 * Map between a serviceDefinition and switchingService.
 *
 * @author hacksaw
 */
public class ServiceDefinitionMap {
    private NmlSwitchingServiceType switchingService;
    private ServiceDefinitionType serviceDefinition;

    /**
     * Get the NML SwitchingService.
     *
     * @return the switchingService
     */
    public NmlSwitchingServiceType getSwitchingService() {
        return switchingService;
    }

    /**
     * Set the NML SwitchingService.
     *
     * @param switchingService the switchingService to set
     */
    public void setSwitchingService(NmlSwitchingServiceType switchingService) {
        this.switchingService = switchingService;
    }

    /**
     * Get the NSI serviceDefinition.
     *
     * @return the serviceDefinition
     */
    public ServiceDefinitionType getServiceDefinition() {
        return serviceDefinition;
    }

    /**
     * Set the NSI serviceDefinition.
     *
     * @param serviceDefinition the serviceDefinition to set
     */
    public void setServiceDefinition(ServiceDefinitionType serviceDefinition) {
        this.serviceDefinition = serviceDefinition;
    }
}
