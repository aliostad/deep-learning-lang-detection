// license-header java merge-point
/**
 * This is only generated once! It will never be overwritten.
 * You can (and have to!) safely modify it by hand.
 * TEMPLATE:    SpringServiceImpl.vsl in andromda-spring cartridge
 * MODEL CLASS: AndroMDAModel::JR Appointment Service::com.systemsjr.jrappointment::service::service::ServiceService
 * STEREOTYPE:  Service
 */
package com.systemsjr.jrenterprise.service.service;

import java.util.Collection;

import com.systemsjr.jrenterprise.service.Service;
import com.systemsjr.jrenterprise.service.ServiceDao;
import com.systemsjr.jrenterprise.service.vo.ServiceSearchCriteria;
import com.systemsjr.jrenterprise.service.vo.ServiceVO;

/**
 * @see com.systemsjr.jrappointment.service.service.ServiceService
 */
public class ServiceServiceImpl
    extends ServiceServiceBase
{

    /**
     * @see com.systemsjr.jrappointment.service.service.ServiceService#delete(ServiceVO)
     */
    protected  void handleDelete(ServiceVO serviceVO)
        throws Exception
    {
    	if(serviceVO.getId() != null){
    		getServiceDao().remove(serviceVO.getId());
    	}
    }

    /**
     * @see com.systemsjr.jrappointment.service.service.ServiceService#save(ServiceVO)
     */
    protected  ServiceVO handleSave(ServiceVO serviceVO)
        throws Exception
    {
    	Service service = getServiceDao().serviceVOToEntity(serviceVO);
    	
    	if(serviceVO.getId() == null){
    		service = getServiceDao().create(service);
    	} else{
    		getServiceDao().update(service);
    	}
    	
    	return getServiceDao().toServiceVO(service);
    }

    /**
     * @see com.systemsjr.jrappointment.service.service.ServiceService#loadAll()
     */
    protected  Collection<ServiceVO> handleLoadAll()
        throws Exception
    {
    	return (Collection<ServiceVO>) getServiceDao().loadAll(ServiceDao.TRANSFORM_SERVICEVO);
    }

    /**
     * @see com.systemsjr.jrappointment.service.service.ServiceService#search(ServiceSearchCriteria)
     */
    protected  Collection<ServiceVO> handleSearch(ServiceSearchCriteria searchCriteria)
        throws Exception
    {
    	return getServiceDao().toServiceVOCollection(getServiceDao().findByCriteria(searchCriteria));
    }

}