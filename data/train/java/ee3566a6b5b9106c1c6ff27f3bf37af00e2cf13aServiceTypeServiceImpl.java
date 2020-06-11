package com.infoklinik.rsvp.server.service;

import java.util.List;

import com.infoklinik.rsvp.client.rpc.ServiceTypeService;
import com.infoklinik.rsvp.server.dao.ServiceTypeDAO;
import com.infoklinik.rsvp.shared.ServiceTypeBean;
import com.infoklinik.rsvp.shared.ServiceTypeSearchBean;

@SuppressWarnings("serial")
public class ServiceTypeServiceImpl extends BaseServiceServlet implements ServiceTypeService {
	
	public List<ServiceTypeBean> getServiceTypes(ServiceTypeSearchBean serviceTypeSearchBean) {
		
		ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
		List<ServiceTypeBean> serviceTypes = serviceTypeDAO.getServiceTypes(serviceTypeSearchBean);
		
		return serviceTypes;
	}
	
	public ServiceTypeBean addServiceType(ServiceTypeBean serviceTypeBean) {
		
		ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
		ServiceTypeBean serviceType = serviceTypeDAO.addServiceType(serviceTypeBean);
		
		return serviceType;
	}
	
	public ServiceTypeBean updateServiceType(ServiceTypeBean serviceTypeBean) {
		
		ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
		ServiceTypeBean serviceType = serviceTypeDAO.updateServiceType(serviceTypeBean);
		
		return serviceType;
	}
	
	public ServiceTypeBean deleteServiceType(ServiceTypeBean serviceTypeBean) {
		
		ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
		ServiceTypeBean serviceType = serviceTypeDAO.deleteServiceType(serviceTypeBean);
		
		return serviceType;
	}
}
