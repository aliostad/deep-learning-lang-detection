package servicedesk.core.itil.scm.service;

import org.springframework.beans.factory.annotation.Autowired;

import servicedesk.core.itil.scm.dao.ServiceDao;
import servicedesk.core.itil.scm.domain.Service;

@org.springframework.stereotype.Service
public class ServiceServiceImpl implements ServiceService {

	@Autowired
	private ServiceDao serviceDao;
	
	public void setServiceDao(ServiceDao serviceDao) {
		this.serviceDao = serviceDao;
	}

	@Override
	public Service get(Integer serviceId) {
		return serviceDao.get(serviceId);
	}

}
