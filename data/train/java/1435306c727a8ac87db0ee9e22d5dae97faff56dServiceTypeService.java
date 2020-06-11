package com.infoklinik.rsvp.client.rpc;

import java.util.List;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;
import com.infoklinik.rsvp.shared.ServiceTypeBean;
import com.infoklinik.rsvp.shared.ServiceTypeSearchBean;

@RemoteServiceRelativePath("serviceTypeService")
public interface ServiceTypeService extends RemoteService {

	List<ServiceTypeBean> getServiceTypes(ServiceTypeSearchBean serviceTypeSearchBean);
	
	ServiceTypeBean addServiceType(ServiceTypeBean serviceTypeBean);

	ServiceTypeBean updateServiceType(ServiceTypeBean serviceTypeBean);
	
	ServiceTypeBean deleteServiceType(ServiceTypeBean serviceTypeBean);	
}
