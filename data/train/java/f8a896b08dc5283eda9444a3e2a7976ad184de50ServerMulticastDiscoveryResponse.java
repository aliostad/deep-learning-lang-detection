package fr.ekinci.distributedpool.multicast.discovery;

/**
 * Message for sending Corba Server's Location to client
 * Immutable class
 * 
 * @author Gokan EKINCI
 */
public class ServerMulticastDiscoveryResponse {   
    private String serviceName;
    private String serviceHost;
    private int servicePort;

    
    public ServerMulticastDiscoveryResponse(String serviceName, String serviceHost, int servicePort){
        this.serviceName = serviceName;
        this.serviceHost = serviceHost;
        this.servicePort = servicePort;
    }


    @Override
    public String toString() {
        return "ServerMulticastDiscoveryResponse [serviceName=" + serviceName
                + ", serviceHost=" + serviceHost + ", servicePort="
                + servicePort + "]";
    }


    public String getServiceName() {
        return serviceName;
    }


    public String getServiceHost() {
        return serviceHost;
    }


    public int getServicePort() {
        return servicePort;
    }


    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }


    public void setServiceHost(String serviceHost) {
        this.serviceHost = serviceHost;
    }


    public void setServicePort(int servicePort) {
        this.servicePort = servicePort;
    }
    
}
