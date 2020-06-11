package org.safehaus.penrose.management.service;

import org.safehaus.penrose.service.*;
import org.safehaus.penrose.util.FileUtil;
import org.safehaus.penrose.management.BaseService;
import org.safehaus.penrose.management.PenroseJMXService;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;

/**
 * @author Endi Sukma Dewata
 */
public class ServiceManagerService extends BaseService implements ServiceManagerServiceMBean {

    ServiceManager serviceManager;

    public ServiceManagerService(PenroseJMXService jmxService, ServiceManager serviceManager) {

        this.jmxService = jmxService;
        this.serviceManager = serviceManager;
    }

    public Object getObject() {
        return serviceManager;
    }

    public String getObjectName() {
        return ServiceManagerClient.getStringObjectName();
    }


    public Collection<String> getServiceNames() throws Exception {
        Collection<String> list = new ArrayList<String>();
        ServiceConfigManager serviceConfigManager = serviceManager.getServiceConfigManager();
        list.addAll(serviceConfigManager.getAvailableServiceNames());
        return list;
    }

    public ServiceConfig getServiceConfig(String serviceName) throws Exception {
        return serviceManager.getServiceConfig(serviceName);
    }

    public ServiceService getServiceService(String name) throws Exception {

        return new ServiceService(jmxService, serviceManager, name);
    }

    public void startService(String name) throws Exception {

        serviceManager.startService(name);

        ServiceService service = getServiceService(name);
        service.init();
    }

    public void stopService(String name) throws Exception {

        ServiceService service = getServiceService(name);
        service.destroy();

        serviceManager.stopService(name);
    }

    public void createService(ServiceConfig serviceConfig) throws Exception {

        String serviceName = serviceConfig.getName();
        serviceManager.addServiceConfig(serviceConfig);

        File servicesDir = serviceManager.getServicesDir();
        File path = new File(servicesDir, serviceName);

        ServiceWriter serviceWriter = new ServiceWriter();
        serviceWriter.write(path, serviceConfig);
    }

    public void updateService(String serviceName, ServiceConfig serviceConfig) throws Exception {

        serviceManager.unloadService(serviceName);
        serviceManager.addServiceConfig(serviceConfig);

        File servicesDir = serviceManager.getServicesDir();
        File oldDir = new File(servicesDir, serviceName);
        File newDir = new File(servicesDir, serviceConfig.getName());
        oldDir.renameTo(newDir);

        ServiceWriter serviceWriter = new ServiceWriter();
        serviceWriter.write(newDir, serviceConfig);
    }

    public void removeService(String name) throws Exception {

        File servicesDir = serviceManager.getServicesDir();
        File serviceDir = new File(servicesDir, name);

        serviceManager.unloadService(name);

        FileUtil.delete(serviceDir);
    }

    public void init() throws Exception {
        super.init();

        for (String serviceName : getServiceNames()) {
            ServiceService serviceService = getServiceService(serviceName);
            serviceService.init();
        }
    }

    public void destroy() throws Exception {
        for (String serviceName : getServiceNames()) {
            ServiceService serviceService = getServiceService(serviceName);
            serviceService.destroy();
        }

        super.destroy();
    }
}
