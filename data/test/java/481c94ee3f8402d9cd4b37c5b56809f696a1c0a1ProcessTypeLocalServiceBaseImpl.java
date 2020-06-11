package com.ext.portlet.processtype.service.base;

import com.ext.portlet.processtype.model.ProcessType;
import com.ext.portlet.processtype.service.ProcessTypeLocalService;
import com.ext.portlet.processtype.service.ProcessTypeService;
import com.ext.portlet.processtype.service.persistence.ProcessTypeFinder;
import com.ext.portlet.processtype.service.persistence.ProcessTypePersistence;

import com.liferay.counter.service.CounterLocalService;
import com.liferay.counter.service.CounterService;

import com.liferay.portal.PortalException;
import com.liferay.portal.SystemException;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;

import java.util.List;


public abstract class ProcessTypeLocalServiceBaseImpl
    implements ProcessTypeLocalService {
    @javax.annotation.Resource(name = "com.ext.portlet.processtype.service.ProcessTypeLocalService.impl")
    protected ProcessTypeLocalService processTypeLocalService;
    @javax.annotation.Resource(name = "com.ext.portlet.processtype.service.ProcessTypeService.impl")
    protected ProcessTypeService processTypeService;
    @javax.annotation.Resource(name = "com.ext.portlet.processtype.service.persistence.ProcessTypePersistence.impl")
    protected ProcessTypePersistence processTypePersistence;
    @javax.annotation.Resource(name = "com.ext.portlet.processtype.service.persistence.ProcessTypeFinder.impl")
    protected ProcessTypeFinder processTypeFinder;
    @javax.annotation.Resource(name = "com.liferay.counter.service.CounterLocalService.impl")
    protected CounterLocalService counterLocalService;
    @javax.annotation.Resource(name = "com.liferay.counter.service.CounterService.impl")
    protected CounterService counterService;

    public ProcessType addProcessType(ProcessType processType)
        throws SystemException {
        processType.setNew(true);

        return processTypePersistence.update(processType, false);
    }

    public ProcessType createProcessType(long processTypeId) {
        return processTypePersistence.create(processTypeId);
    }

    public void deleteProcessType(long processTypeId)
        throws PortalException, SystemException {
        processTypePersistence.remove(processTypeId);
    }

    public void deleteProcessType(ProcessType processType)
        throws SystemException {
        processTypePersistence.remove(processType);
    }

    public List<Object> dynamicQuery(DynamicQuery dynamicQuery)
        throws SystemException {
        return processTypePersistence.findWithDynamicQuery(dynamicQuery);
    }

    public List<Object> dynamicQuery(DynamicQuery dynamicQuery, int start,
        int end) throws SystemException {
        return processTypePersistence.findWithDynamicQuery(dynamicQuery, start,
            end);
    }

    public ProcessType getProcessType(long processTypeId)
        throws PortalException, SystemException {
        return processTypePersistence.findByPrimaryKey(processTypeId);
    }

    public List<ProcessType> getProcessTypes(int start, int end)
        throws SystemException {
        return processTypePersistence.findAll(start, end);
    }

    public int getProcessTypesCount() throws SystemException {
        return processTypePersistence.countAll();
    }

    public ProcessType updateProcessType(ProcessType processType)
        throws SystemException {
        processType.setNew(false);

        return processTypePersistence.update(processType, true);
    }

    public ProcessTypeLocalService getProcessTypeLocalService() {
        return processTypeLocalService;
    }

    public void setProcessTypeLocalService(
        ProcessTypeLocalService processTypeLocalService) {
        this.processTypeLocalService = processTypeLocalService;
    }

    public ProcessTypeService getProcessTypeService() {
        return processTypeService;
    }

    public void setProcessTypeService(ProcessTypeService processTypeService) {
        this.processTypeService = processTypeService;
    }

    public ProcessTypePersistence getProcessTypePersistence() {
        return processTypePersistence;
    }

    public void setProcessTypePersistence(
        ProcessTypePersistence processTypePersistence) {
        this.processTypePersistence = processTypePersistence;
    }

    public ProcessTypeFinder getProcessTypeFinder() {
        return processTypeFinder;
    }

    public void setProcessTypeFinder(ProcessTypeFinder processTypeFinder) {
        this.processTypeFinder = processTypeFinder;
    }

    public CounterLocalService getCounterLocalService() {
        return counterLocalService;
    }

    public void setCounterLocalService(CounterLocalService counterLocalService) {
        this.counterLocalService = counterLocalService;
    }

    public CounterService getCounterService() {
        return counterService;
    }

    public void setCounterService(CounterService counterService) {
        this.counterService = counterService;
    }
}
