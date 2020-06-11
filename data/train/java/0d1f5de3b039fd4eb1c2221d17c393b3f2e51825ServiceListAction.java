package com.bmw.sale.action;

import java.util.List;
import com.bmw.sale.business.ServiceImpl;
import com.bmw.sale.value.Client;
import com.bmw.sale.value.Service;
import com.opensymphony.xwork2.ActionSupport;

public class ServiceListAction extends ActionSupport{
	
	private static final long serialVersionUID = 1L;
	private Service serviceinfo=new Service();
	private Client clientinfo=new Client();
	private List<Service> service;
	private ServiceImpl<Service> serviceImpl;
	
	public ServiceImpl<Service> getServiceImpl() {
		return serviceImpl;
	}
	public void setServiceImpl(ServiceImpl<Service> serviceImpl) {
		this.serviceImpl = serviceImpl;
	}
	public Service getServiceinfo() {
		return serviceinfo;
	}
	public void setServiceinfo(Service serviceinfo) {
		this.serviceinfo = serviceinfo;
	}
	public Client getClientinfo() {
		return clientinfo;
	}
	public void setClientinfo(Client clientinfo) {
		this.clientinfo = clientinfo;
	}
	public List<Service> getService() {
		return service;
	}
	public void setService(List<Service> service) {
		this.service = service;
	}
	
	public String list() throws Exception{
		service=serviceImpl.listService(Service.class);
		return SUCCESS;
	}
}
