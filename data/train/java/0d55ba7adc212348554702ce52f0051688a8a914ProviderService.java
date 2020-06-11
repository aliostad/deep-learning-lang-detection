package com.bluedigm.funnylab.oauth.provider.service;

import java.util.List;

import com.bluedigm.funnylab.oauth.provider.model.Service;
import com.bluedigm.funnylab.oauth.provider.model.ServiceList;

public interface ProviderService{

	List<Service>  getServiceList(ServiceList serviceList);
	int getServiceTotalCnt(ServiceList serviceList);
	Service  getService(Service service);
	List<Service> 	getServiceScopeList(Service service);
	List<Service>  getServiceGrantTypeList(Service service);
	int createService(Service service);
	int modifyService(Service service);
}
