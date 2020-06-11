package service.framework.route;

import java.util.List;

import service.framework.provide.entity.RequestEntity;
import servicecenter.service.ServiceInformation;

public class DefaultRoute implements Route {
	private List<ServiceInformation> serviceList;
	
	

	public List<ServiceInformation> getServiceList() {
		return serviceList;
	}



	public void setServiceList(List<ServiceInformation> serviceList) {
		this.serviceList = serviceList;
	}



	@Override
	public ServiceInformation chooseRoute(String serviceName) {
		// TODO Auto-generated method stub
		return this.serviceList.get(0);
	}

}
