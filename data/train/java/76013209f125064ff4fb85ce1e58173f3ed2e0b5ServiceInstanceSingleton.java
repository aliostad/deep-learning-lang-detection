package util;

import com.vmware.vim25.mo.ServiceInstance;

public class ServiceInstanceSingleton {
	
	
	private static ServiceInstanceSingleton serviceInstanceClass;
	
	private static ServiceInstance serviceInstance;
	
	private ServiceInstanceSingleton(){
		
	}
	
	public static ServiceInstanceSingleton getInstance(){
		serviceInstanceClass=new ServiceInstanceSingleton();
		return serviceInstanceClass;
	}

	
	public void setServiceInstance(ServiceInstance si){
		serviceInstance=si;
	}
	
	public ServiceInstance getServiceInstance(){
		return serviceInstance;
	}
	
}
