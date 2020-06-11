/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package lfl.centralbank;

import java.io.Serializable;

/**
 *
 * @author Luisito
 */
public class Service implements Serializable{

    private String serviceName;
    private String serviceIP;
    private int servicePort;
    
    public Service(){
        
    }

    public Service(String serviceName){
        this.serviceName = serviceName;
    }

    public Service(String serviceName, String serviceIP, int servicePort){
        this.serviceName = serviceName;
        this.serviceIP = serviceIP;
        this.servicePort = servicePort;
    }
    
    public void setServiceName(String serviceName){
        this.serviceName = serviceName;
    }

    public void setServiceIP(String serviceIP){
        this.serviceIP = serviceIP;
    }

    public void setServicePort(int servicePort){
        this.servicePort = servicePort;
    }

    public String getServiceName(){
        return serviceName;
    }

    public String getServiceIP(){
        return serviceIP;
    }

    public int getServicePort(){
        return servicePort;
    }

    @Override
    public String toString(){
        return serviceName;
    }
}
