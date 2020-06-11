package com.damianfanaro.pattern.behavioral.serviceLocator;

/**
 * TODO: Put a brief comment about what this component do.
 * <p>
 * @author dfanaro
 */
public class ServiceLocatorDemo {

    public static void main(String[] args) {
        Service service = ServiceLocator.getService("ServiceOne");
        service.execute();
        service = ServiceLocator.getService("ServiceTwo");
        service.execute();
        service = ServiceLocator.getService("ServiceOne");
        service.execute();
        service = ServiceLocator.getService("ServiceTwo");
        service.execute();
    }
}
