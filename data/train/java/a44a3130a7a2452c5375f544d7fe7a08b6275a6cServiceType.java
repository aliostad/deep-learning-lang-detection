package com.czbank.queue.entity;

import java.io.Serializable;

public class ServiceType implements Serializable{
	private  int serviceID;
	private  String serviceName;
	private  String serviceState;
	
	public static final String SERVICE_STATE_ON= "1";//正常
	public static final String COUNTER_TYPE_OFF = "0 ";//禁用
	public int getServiceID() {
		return serviceID;
	}
	public void setServiceID(int serviceID) {
		this.serviceID = serviceID;
	}
	public String getServiceName() {
		return serviceName;
	}
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
	public String getServiceState() {
		return serviceState;
	}
	public void setServiceState(String serviceState) {
		this.serviceState = serviceState;
	}
	
	

}
