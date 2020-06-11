package com.msm.integration.pool.data.service.impl;

import com.msm.integration.pool.data.model.ServiceEntity;
import com.msm.integration.pool.data.repository.ServiceEntityRepository;
import com.msm.integration.pool.data.service.ServiceEntityService;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.util.List;

/**
 * @author riste.jovanoski
 * @since 6/20/2017
 */
@ApplicationScoped
public class ServiceEntityServiceImpl implements ServiceEntityService {

    @Inject
    private ServiceEntityRepository serviceEntityRepository;

    @Override
    public ServiceEntity findById(Long id) {
        return serviceEntityRepository.findById(id);
    }

    @Override
    public ServiceEntity findByServiceId(String serviceId) {
        return serviceEntityRepository.findByServiceId(serviceId);
    }

    @Override
    public List<ServiceEntity> findAll() {
        return serviceEntityRepository.list();
    }

    @Override
    public void save(String serviceId, String serviceHost, String secondaryServiceHost, String healthCheck) {
        serviceEntityRepository.save(new ServiceEntity(serviceId, serviceHost, secondaryServiceHost, healthCheck));
    }

    @Override
    public void update(Long id, String serviceId, String serviceHost, String secondaryServiceHost, String healthCheck) {
        ServiceEntity serviceEntity = serviceEntityRepository.findById(id);
        serviceEntity.setServiceId(serviceId);
        serviceEntity.setServiceHost(serviceHost);
        serviceEntity.setHealthCheck(healthCheck);
        serviceEntityRepository.update(serviceEntity);
    }

    @Override
    public void delete(Long id) {
        serviceEntityRepository.delete(serviceEntityRepository.findById(id));
    }

    @Override
    public void notifyForRegistration(String... parameters) {
        String serviceId = parameters[0];
        if (!checkIfServiceWithServiceIdExists(serviceId)) {
            serviceEntityRepository.save(new ServiceEntity(serviceId, parameters[1], parameters[3], parameters[2]));
        }
    }

    @Override
    public void notifyForDeregistration(String... parameters) {
        serviceEntityRepository.delete(serviceEntityRepository.findByServiceId(parameters[0]));
    }

    private boolean checkIfServiceWithServiceIdExists(String serviceId) {
        ServiceEntity serviceEntity = serviceEntityRepository.findByServiceId(serviceId);
        return serviceEntity != null;
    }

}
