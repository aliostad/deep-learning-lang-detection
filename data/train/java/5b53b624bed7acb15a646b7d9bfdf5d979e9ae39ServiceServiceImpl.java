package com.thingtrack.konekti.service.impl.internal;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.thingtrack.konekti.dao.api.ServiceDao;
import com.thingtrack.konekti.dao.api.ServiceStatusDao;
import com.thingtrack.konekti.domain.Organization;
import com.thingtrack.konekti.domain.Sequence;
import com.thingtrack.konekti.domain.Service;
import com.thingtrack.konekti.service.api.SequenceService;
import com.thingtrack.konekti.service.api.ServiceService;

/**
 * @author Thingtrack S.L.
 *
 */
public class ServiceServiceImpl implements ServiceService {
	@Autowired
	private ServiceDao serviceDao;
	
	@Autowired
	private ServiceStatusDao serviceStatusDao;
	
	@Autowired
	private SequenceService sequenceService;
	
	@Override
	public List<Service> getAll() throws Exception {
		return this.serviceDao.getAll();
		
	}

	@Override
	public Service get(Integer serviceId) throws Exception {
		return this.serviceDao.get(serviceId);
		
	}

	@Override
	public Service getByCode(String code) throws Exception {
		return this.serviceDao.getByCode(code);
		
	}

	@Override
	public Service save(Service service) throws Exception {
		return this.serviceDao.save(service);
		
	}

	@Override
	public void delete(Service service) throws Exception {
		this.serviceDao.delete(service);
		
	}

	@Override
	public Service createNewService(Organization organization) throws Exception {
		Service service = new Service();
		
		service.setCode(sequenceService.setNextSequence(Sequence.CODE.SERVICE.name()));
		service.setOrganization(organization);
		service.setServiceStatus(serviceStatusDao.getByCode(Service.STATUS.OPENED.name()));
		
		return service;
	}
	
	@Override
	public List<Service> getAll(Organization currentOrganization)
			throws Exception {
		return serviceDao.getAll(currentOrganization);
	}
	
}
