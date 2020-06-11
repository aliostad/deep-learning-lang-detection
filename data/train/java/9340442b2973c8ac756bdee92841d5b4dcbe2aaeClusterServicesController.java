package org.acc.cluster.service;

/**
 * @author Andy - 14/11/2014.
 */
public interface ClusterServicesController {
    /**
     * Instantiate an instance of the supplied serviceType on the local node and register it using the supplied
     * serviceId. The provided serviceData will be made available to the service instance via the ClusterServiceContext
     * provided to the instance in its constructor.
     *
     * @param serviceType   the type of the service.
     * @param serviceId     the unique id of this service. The key is unique across the cluster.
     * @param serviceData   the instance data of the service. This is managed by the controller for the service.
     * @param <Service>     the type of the service
     * @param <ServiceData> the type of the data the service uses.
     */
    <Service extends ClusterService<ServiceData>, ServiceData>
    void registerService(Class<Service> serviceType, ServiceId serviceId, ServiceData serviceData);

    /**
     * Start the service identified by the supplied details todo(ac): service type should be part of serviceId...
     *
     * @param serviceType   the type of the service.
     * @param serviceId     the unique id of this service. The key is unique across the cluster.
     * @param <Service>     the type of the service
     */
    <Service extends ClusterService<?>> void startService(Class<Service> serviceType, ServiceId serviceId);

    /**
     * Stop the service identified by the supplied details. The call does not wait for the service to stop.
     *
     * @param serviceType   the type of the service.
     * @param serviceId     the unique id of this service. The key is unique across the cluster.
     * @param <Service>     the type of the service
     */
    <Service extends ClusterService<?>> void stopService(Class<Service> serviceType, ServiceId serviceId);

    /**
     * Unregister the service identified by the supplied serviceId. If the service is running the controller will wait
     * for the service to stop.
     *
     * @param serviceId the id of the service to stop & unregister.
     * @param <Service> the type of the service
     */
    <Service extends ClusterService<?>> void unregisterService(Class<Service> serviceType, ServiceId serviceId);
}
