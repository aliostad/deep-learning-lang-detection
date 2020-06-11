package com.gaohui.rpc.server;

/**
 * 服务器端服务代理工厂
 * User: Administrator
 * Date: 11-1-16 Time: 下午3:05
 *
 * @author Basten Gao
 */
public class DefaultServerServiceProxyFactory implements ServerServiceProxyFactory {
    private ServiceProvider serviceProvider;


    public DefaultServerServiceProxyFactory(ServiceProvider serviceProvider) {
        this.serviceProvider = serviceProvider;
    }

    @Override
    public boolean hasService(String serviceName) {
        return serviceProvider.hasService(serviceName);
    }

    @Override
    public ServerServiceProxy createProxy(String serviceName) {
        Object service = serviceProvider.getService(serviceName);
        if (service == null) {
            throw new IllegalStateException("the service is unavailable. service: " + serviceName);
        }
        return new DefaultServerServiceProxy(service, serviceName);
    }

}
