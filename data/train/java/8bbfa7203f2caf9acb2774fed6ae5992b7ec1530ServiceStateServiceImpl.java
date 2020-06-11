package com.msm.integration.pool.service.state.check.services.impl;

import com.msm.integration.pool.data.model.ServiceEntity;
import com.msm.integration.pool.data.service.ServiceEntityService;
import com.msm.integration.pool.service.state.check.services.HealthCheckService;
import com.msm.integration.pool.service.state.check.services.ServiceStateService;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.util.List;

/**
 * @author riste.jovanoski
 * @since 6/21/2017
 */
@ApplicationScoped
public class ServiceStateServiceImpl implements ServiceStateService {

    @Inject
    private ServiceEntityService serviceEntityService;

    @Inject
    private HealthCheckService healthCheckService;

    @Override
    public void checkServicesState() {
        List<ServiceEntity> registeredServices = serviceEntityService.findAll();
        for (ServiceEntity registeredService : registeredServices) {
            if (!healthCheckService.isServiceActive(registeredService)) {
                removeNotActiveServiceFromDatabase(registeredService);
            }
        }
    }

    private void removeNotActiveServiceFromDatabase(ServiceEntity serviceEntity) {
        serviceEntityService.delete(serviceEntity.getId());
    }
}