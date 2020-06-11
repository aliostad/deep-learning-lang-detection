package com.bluedigm.funnylab.oauth.provider.dao;

import java.util.List;

import com.bluedigm.funnylab.oauth.provider.model.Service;
import com.bluedigm.funnylab.oauth.provider.model.ServiceList;

public interface ProviderDao {

	List<Service> selectServiceList(ServiceList serviceList);
	int selectServiceTotalCnt(ServiceList serviceList);
	Service selectService(Service service);
	List<Service> selectScopeList(Service service);
	List<Service> selectGrantTypeList(Service service);
	int insertService(Service service);
	int updateService(Service service);
	int insertScope(Service service);
	int deleteScope(Service service);
	int insertGrantType(Service service);
	int deleteGrantType(Service service);
}
