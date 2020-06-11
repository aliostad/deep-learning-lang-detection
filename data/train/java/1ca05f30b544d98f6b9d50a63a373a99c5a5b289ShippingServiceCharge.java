package com.project.locksA2Z.server;

public class ShippingServiceCharge {
	
	public ShippingServiceCharge(String code,String charge,String description){
		this.serviceCharge=charge;
		this.serviceCode=code;
		this.serviceDescription=description;
	}
	
	public String getServiceCode() {
		return serviceCode;
	}
	public void setServiceCode(String serviceCode) {
		this.serviceCode = serviceCode;
	}
	public String getServiceCharge() {
		return serviceCharge;
	}
	public void setServiceCharge(String serviceCharge) {
		this.serviceCharge = serviceCharge;
	}
	public String getServiceDescription() {
		return serviceDescription;
	}
	public void setServiceDescription(String serviceDescription) {
		this.serviceDescription = serviceDescription;
	}
	String serviceCode;
	String serviceCharge;
	String serviceDescription;
	
}
