package at.ac.tuwien.dsg.comot.common.model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author Daniel Moldovan
 */
public class ServiceTopology extends AbstractServiceDescriptionEntity {

    private List<ServiceUnit> serviceNodes = new ArrayList<>();

    protected ServiceTopology(String id) {
        super(id);
    }

    public static ServiceTopology ServiceTopology(String id) {
        return new ServiceTopology(id);
    }

    public List<ServiceUnit> getServiceUnits() {
        return serviceNodes;
    }

    public void setServiceUnits(List<ServiceUnit> serviceNodes) {
        this.serviceNodes = serviceNodes;
    }

    public void addServiceUnit(ServiceUnit serviceNode) {
        this.serviceNodes.add(serviceNode);
    }

    public void removeServiceUnit(ServiceUnit serviceNode) {
        this.serviceNodes.remove(serviceNode);
    }

    public ServiceTopology withServiceUnits(ServiceUnit... serviceNodes) {
        this.serviceNodes.addAll(Arrays.asList(serviceNodes));
        return this;
    }

    @Override
    public AbstractServiceDescriptionEntity exposes(Capability... capabilities) {
        return super.exposes(capabilities);
    }

}
