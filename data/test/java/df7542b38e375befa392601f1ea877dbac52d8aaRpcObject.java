package fr.rentaraclette.rpc;

import java.lang.reflect.Method;

import fr.rentaraclette.services.AbstractService;

public class RpcObject {
	private AbstractService service; //The service class
	private Method method; //The method representing the service
	
	public RpcObject(AbstractService service, Method method) {
		this.service = service;
		this.method = method;
	}
	
	public AbstractService getService() {
		return service;
	}
	public void setService(AbstractService service) {
		this.service = service;
	}
	public Method getMethodName() {
		return method;
	}
	public void setMethodName(Method method) {
		this.method = method;
	}
}
