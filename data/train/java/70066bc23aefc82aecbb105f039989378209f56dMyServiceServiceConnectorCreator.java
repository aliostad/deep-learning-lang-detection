package org.springframework.cloud.connector.dependency;

import org.springframework.cloud.service.AbstractServiceConnectorCreator;
import org.springframework.cloud.service.ServiceConnectorConfig;

public class MyServiceServiceConnectorCreator extends
        AbstractServiceConnectorCreator<MyService, MyServiceServiceInfo> {

    public MyService create(MyServiceServiceInfo serviceInfo,
            ServiceConnectorConfig serviceConnectorConfig) {
        return new MyService(serviceInfo.getStuff());
    }

}
