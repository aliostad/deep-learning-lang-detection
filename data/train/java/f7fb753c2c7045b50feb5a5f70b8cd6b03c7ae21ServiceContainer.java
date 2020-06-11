package com.twocater.diamond.core.server;

import com.twocater.diamond.api.service.Request;
import com.twocater.diamond.api.service.Service;
import com.twocater.diamond.api.service.ServiceConfig;

/**
 * 服务的容器类 <br/>
 * 实现延迟初始化
 *
 * @author cpaladin
 */
public class ServiceContainer implements Service {

    private boolean init = false;
    private Service service;
    private ServiceConfig serviceConfig;

    public ServiceContainer(Service service) {
        this.service = service;
    }

    @Override
    public void init(ServiceConfig serviceConfig) throws Exception {
        this.serviceConfig = serviceConfig;
        if (serviceConfig.getOrder() > 0) {
            service.init(serviceConfig);
            init = true;
        }
    }

    @Override
    public void destroy() {
        service.destroy();
    }

    @Override
    public void service(Request request) throws Exception {
        getService().service(request);
    }

    private Service getService() throws Exception {
        if (init) {
            return service;
        }
        synchronized (this) {
            if (!init) {
                service.init(serviceConfig);
                init = true;
            }
        }
        return service;
    }

}
