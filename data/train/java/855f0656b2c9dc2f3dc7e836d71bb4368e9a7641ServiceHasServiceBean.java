/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.ufjf.pgcc.plscience.controller;

import br.ufjf.pgcc.plscience.dao.ServiceHasServiceDAO;
import br.ufjf.pgcc.plscience.model.ServiceHasService;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.event.ActionEvent;

/**
 *
 * @author phillipe
 */

@ManagedBean(name = "serviceHasServiceBean")
@ViewScoped
public class ServiceHasServiceBean implements Serializable{
    
    private ServiceHasService serviceHasService = new ServiceHasService();
    private List ServiceHasServiceList = new ArrayList();

    public ServiceHasServiceBean() {
        ServiceHasServiceList = new ServiceHasServiceDAO().getAll();
        serviceHasService = new ServiceHasService();
    }
    
    /**
     * record
     * @param actionEvent 
     */
    public void record(ActionEvent actionEvent) {
        new ServiceHasServiceDAO().save(getServiceHasService());
        setServiceHasServiceList(new ServiceHasServiceDAO().getAll());
    }     

    /**
     * @return the serviceHasService
     */
    public ServiceHasService getServiceHasService() {
        return serviceHasService;
    }

    /**
     * @param serviceHasService the serviceHasService to set
     */
    public void setServiceHasService(ServiceHasService serviceHasService) {
        this.serviceHasService = serviceHasService;
    }

    /**
     * @return the ServiceHasServiceList
     */
    public List getServiceHasServiceList() {
        return ServiceHasServiceList;
    }

    /**
     * @param ServiceHasServiceList the ServiceHasServiceList to set
     */
    public void setServiceHasServiceList(List ServiceHasServiceList) {
        this.ServiceHasServiceList = ServiceHasServiceList;
    }
  
    
}
