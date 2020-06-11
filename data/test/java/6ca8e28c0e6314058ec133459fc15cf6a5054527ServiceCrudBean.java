package com.ffsoft.kyro.faces.bean.crud;

import com.ffsoft.kyro.bo.ServiceBo;
import com.ffsoft.kyro.model.products.Service;

import java.util.List;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;

@ManagedBean
@RequestScoped
public class ServiceCrudBean extends CrudBean {

    private Service service = new Service();
    private static ServiceBo serviceBo;

    public ServiceCrudBean() {
        crudName = "service";
    }

    /**
     * Add Service
     */
    public void add() {
        ServiceCrudBean.serviceBo.createNewService(this.service);
        this.setAddState();
    }

    /**
     * Edit Service
     */
    public void edit() {
        ServiceCrudBean.serviceBo.modifyService(this.service);
        this.setAddState();
    }

    /**
     * Prepare view to edit
     */
    public void prepareEdit(Service service) {
        this.service = service;
        this.setCurrentState(EDIT_STATE);
    }

    /**
     * List of users
     */
    public List<Service> list() {
        return serviceBo.getServicesList();
    }


    /**
     * Remove Service
     */
    public void delete(Service service) {
        ServiceCrudBean.serviceBo.deleteService(service);
        this.setAddState();
    }

    /**
     * Clear attributes
     */
    @Override
    protected void clear() {
        this.service = new Service();
        super.clear();
    }

    // Gets & Sets
    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public ServiceBo getServiceBo() {
        return serviceBo;
    }

    public void setServiceBo(ServiceBo serviceBo) {
        ServiceCrudBean.serviceBo = serviceBo;
    }
}
