/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pfe.web;

import com.pfe.facade.ServiceService;
import com.pfe.model.Service;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.PostConstruct;
import javax.faces.bean.SessionScoped;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 *
 * @author abdelmouhgit
 */

@Component("serviceControler")
@SessionScoped
public class ServiceControler {
     
    private Service service=new Service();
    private List<Service> services=new ArrayList<Service>();
    @Autowired
    private ServiceService serviceService;
    
    public Service cloneService(){
    Service clonedService=new Service();
    clonedService.setIdService(serviceService.generateIdServ().get(0));
        System.out.println("********id dial Service jdiid"+serviceService.generateIdServ().get(0));
    clonedService.setLibelleService(service.getLibelleService());
    return clonedService;
    }
    
    public void save(){
    serviceService.save(service);
    services.add(cloneService());
    //return "serviceAdded";
    }
    
    @PostConstruct
    public void init(){
    services=serviceService.findAll();
    }
    
    public Service findById(int id){
    return serviceService.find(id);
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public List<Service> getServices() {
        return services;
    }

    public void setServices(List<Service> services) {
        this.services = services;
    }

    public ServiceService getServiceService() {
        return serviceService;
    }

    public void setServiceService(ServiceService serviceService) {
        this.serviceService = serviceService;
    }
    
    
    
    public ServiceControler() {
    }
    
}
