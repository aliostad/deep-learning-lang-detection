package cn.com.zuo.service;

import java.util.List;
import java.util.Map;

public class ServiceMapping {
	private String serviceClass;
	private String serviceMethod;
	private List<Map<String,String>> serviceParameters;

	public String getServiceClass() {
		return serviceClass;
	}

	public void setServiceClass(String serviceClass) {
		this.serviceClass = serviceClass;
	}

	public String getServiceMethod() {
		return serviceMethod;
	}

	public void setServiceMethod(String serviceMethod) {
		this.serviceMethod = serviceMethod;
	}

	public List<Map<String, String>> getServiceParameters() {
		return serviceParameters;
	}

	public void setServiceParameters(List<Map<String, String>> serviceParameters) {
		this.serviceParameters = serviceParameters;
	}

	
}
