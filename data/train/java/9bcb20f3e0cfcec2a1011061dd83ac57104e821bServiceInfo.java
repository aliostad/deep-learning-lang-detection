package eu.anmore.hubs.service;

public class ServiceInfo {

    private String serviceName;

    /**
     * @deprecated deserialization only
     */
    @Deprecated
    ServiceInfo() {
    }

    public ServiceInfo(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    @Override
    public String toString() {
        final StringBuffer sb = new StringBuffer("ServiceInfo{");
        sb.append("serviceName='").append(serviceName).append('\'');
        sb.append('}');
        return sb.toString();
    }

}
