/**
 * ccinterviewer.com Inc.
 * Copyright (c) 2014-2014 All Rights Reserved.
 */
package com.ccconsult.web.view;

import com.ccconsult.base.ToString;
import com.ccconsult.pojo.Service;
import com.ccconsult.pojo.ServiceConfig;

/**
 * 服务配置对象
 * 
 * @author jingyudan
 * @version $Id: ServiceCofigVO.java, v 0.1 2014-7-6 上午10:48:40 jingyudan Exp $
 */
public class ServiceConfigVO extends ToString {

    /**  */
    private static final long serialVersionUID = 1L;

    private Service           service;

    private ServiceConfig     serviceConfig;

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public ServiceConfig getServiceConfig() {
        return serviceConfig;
    }

    public void setServiceConfig(ServiceConfig serviceConfig) {
        this.serviceConfig = serviceConfig;
    }

}
