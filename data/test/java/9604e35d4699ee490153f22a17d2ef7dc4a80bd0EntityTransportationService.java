/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package CRM;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/**
 *
 * @author yuna
 */
@Entity
public class EntityTransportationService extends AbstractService {
    private String serviceOrigin;
    private String serviceDestination;
    private String serviceEstimatedDuration;
    private String serviceTool;
    private double serviceMinUnit;
    private double serviceMaxUnit;
    private double servicePerUnitCost;
    private double servicePerUnitPrice;

    public EntityTransportationService() {
    }

    public EntityTransportationService(Long serviceID, String serviceName, String serviceType, String serviceDescription, String serviceRemark,String serviceOrigin, String serviceDestination, String serviceEstimatedDuration, String serviceTool, double serviceMinUnit, double serviceMaxUnit, double servicePerUnitCost, double servicePerUnitPrice) {
        this.setServiceID (serviceID);
        this.setServiceName (serviceName);
        this.setServiceType (serviceType);
        this.setServiceDescription (serviceDescription);
        this.setServiceRemark (serviceRemark);
        this.serviceOrigin = serviceOrigin;
        this.serviceDestination = serviceDestination;
        this.serviceEstimatedDuration = serviceEstimatedDuration;
        this.serviceTool = serviceTool;
        this.serviceMinUnit = serviceMinUnit;
        this.serviceMaxUnit = serviceMaxUnit;
        this.servicePerUnitCost = servicePerUnitCost;
        this.servicePerUnitPrice = servicePerUnitPrice;
    }

    public String getServiceOrigin() {
        return serviceOrigin;
    }

    public void setServiceOrigin(String serviceOrigin) {
        this.serviceOrigin = serviceOrigin;
    }

    public String getServiceDestination() {
        return serviceDestination;
    }

    public void setServiceDestination(String serviceDestination) {
        this.serviceDestination = serviceDestination;
    }

    public String getServiceEstimatedDuration() {
        return serviceEstimatedDuration;
    }

    public void setServiceEstimatedDuration(String serviceEstimatedDuration) {
        this.serviceEstimatedDuration = serviceEstimatedDuration;
    }

    public String getServiceTool() {
        return serviceTool;
    }

    public void setServiceTool(String serviceTool) {
        this.serviceTool = serviceTool;
    }

    public double getServiceMinUnit() {
        return serviceMinUnit;
    }

    public void setServiceMinUnit(double serviceMinUnit) {
        this.serviceMinUnit = serviceMinUnit;
    }

    public double getServiceMaxUnit() {
        return serviceMaxUnit;
    }

    public void setServiceMaxUnit(double serviceMaxUnit) {
        this.serviceMaxUnit = serviceMaxUnit;
    }

    public double getServicePerUnitCost() {
        return servicePerUnitCost;
    }

    public void setServicePerUnitCost(double servicePerUnitCost) {
        this.servicePerUnitCost = servicePerUnitCost;
    }

    public double getServicePerUnitPrice() {
        return servicePerUnitPrice;
    }

    public void setServicePerUnitPrice(double servicePerUnitPrice) {
        this.servicePerUnitPrice = servicePerUnitPrice;
    }
    
    
    
    
           
    
}
