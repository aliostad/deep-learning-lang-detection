/*
 * Copyright 2010 OpenDropBox
 * http://www.opendropbox.com/
 */
package opendropbox.servicediscovery.monitor;

import opendropbox.servicediscovery.ServiceDescription;

/**
 *
 * @author Walter
 */
public class DemoServiceMonitorCallback implements ServiceMonitorCallback {

    public void serviceJoined(ServiceDescription serviceDescription) {
        System.out.println("Service joined: " + serviceDescription);
    }

    public void serviceDeparted(ServiceDescription serviceDescription) {
        System.out.println("Service departed: " + serviceDescription);
    }
}
