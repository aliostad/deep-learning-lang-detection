package com.gome.gmhx.entity.vo;

import java.util.List;

import com.gome.gmhx.entity.HxServiceCustomer;
import com.gome.gmhx.entity.HxServicePartsInfo;
import com.gome.gmhx.entity.HxServiceProduct;
import com.gome.gmhx.entity.HxServiceProgressInfo;
import com.gome.gmhx.entity.HxServiceProject;
import com.gome.gmhx.entity.HxServiceTicket;
import com.gome.gmhx.entity.HxServiceTroubleInfo;

public class HxServiceTicketVO {
	
	private HxServiceCustomer serviceCustomer;
	
	private HxServiceProduct serviceProduct;
	
	private HxServiceTicket serviceTicket; 
	
	private List<HxServiceTroubleInfo> serviceTroubleInfos;
	
	private List<HxServicePartsInfo> servicePartsInfos;
	
	private List<HxServiceProject> serviceProjects;
	
	private List<HxServiceProgressInfo> serviceProgressInfos;

	public HxServiceCustomer getServiceCustomer() {
		return serviceCustomer;
	}

	public HxServiceProduct getServiceProduct() {
		return serviceProduct;
	}

	public HxServiceTicket getServiceTicket() {
		return serviceTicket;
	}

	public List<HxServiceTroubleInfo> getServiceTroubleInfos() {
		return serviceTroubleInfos;
	}

	public List<HxServicePartsInfo> getServicePartsInfos() {
		return servicePartsInfos;
	}

	public List<HxServiceProject> getServiceProjects() {
		return serviceProjects;
	}

	public void setServiceCustomer(HxServiceCustomer serviceCustomer) {
		this.serviceCustomer = serviceCustomer;
	}

	public void setServiceProduct(HxServiceProduct serviceProduct) {
		this.serviceProduct = serviceProduct;
	}

	public void setServiceTicket(HxServiceTicket serviceTicket) {
		this.serviceTicket = serviceTicket;
	}

	public void setServiceTroubleInfos(
			List<HxServiceTroubleInfo> serviceTroubleInfos) {
		this.serviceTroubleInfos = serviceTroubleInfos;
	}

	public void setServicePartsInfos(List<HxServicePartsInfo> servicePartsInfos) {
		this.servicePartsInfos = servicePartsInfos;
	}

	public void setServiceProjects(List<HxServiceProject> serviceProjects) {
		this.serviceProjects = serviceProjects;
	}

	public List<HxServiceProgressInfo> getServiceProgressInfos() {
		return serviceProgressInfos;
	}

	public void setServiceProgressInfos(
			List<HxServiceProgressInfo> serviceProgressInfos) {
		this.serviceProgressInfos = serviceProgressInfos;
	}
	
}
