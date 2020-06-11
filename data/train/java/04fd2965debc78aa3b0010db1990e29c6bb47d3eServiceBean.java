/*
 * ServicesBean.java
 *
 * Created on 14 January 2003, 11:14
 */

package uk.ac.clrc.dataportal.facility;

/**
 *
 * @author  Mark Williams
 */
public class ServiceBean
{
    private String serviceName = null;
    private String serviceDesc = null;
    private String serviceType = null;
    private String serviceEndpoint = null;
    private String serviceWSDL = null;
    
    public ServiceBean(String serviceName, String serviceDesc, String serviceType, String serviceEndpoint, String serviceWSDL)
    {
        this.serviceName = serviceName;
        this.serviceDesc = serviceDesc;
        this.serviceType = serviceType;
        this.serviceEndpoint = serviceEndpoint;
        this.serviceWSDL = serviceWSDL;
    }
    
    public ServiceBean()
    {
    }
    
    public String getServiceName()
    {
        return this.serviceName;
    }
    public void setServiceName(String serviceName)
    {
        this.serviceName = serviceName;
    }
    
    public String getServiceDesc()
    {
        return this.serviceDesc;
    }
    public void setServiceDesc(String serviceDesc)
    {
        this.serviceDesc = serviceDesc;
    }
    
    public String getServiceType()
    {
        return this.serviceType;
    }
    public void setServiceType(String serviceType)
    {
        this.serviceType = serviceType;
    }
    
    public String getServiceEndpoint()
    {
        return this.serviceEndpoint;
    }
    public void setServiceEndpoint(String serviceEndpoint)
    {
        this.serviceEndpoint = serviceEndpoint;
    }
    
    public String getServiceWSDL()
    {
        return this.serviceWSDL;
    }
    public void setServiceWSDL(String serviceWSDL)
    {
        this.serviceWSDL = serviceWSDL;
    }
    
    public String toString()
    {
        return "[" + getServiceName() + ", " + getServiceDesc() + ", " + getServiceType() + ", " + getServiceEndpoint() + ", " + getServiceWSDL() + "]";
    }
    
}
