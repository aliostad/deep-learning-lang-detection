package com.quantumretail.qi.common;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

public abstract class AbstractCalculationService<T> implements CalculationService {

    protected final Logger logger = LoggerFactory.getLogger(this.getClass().getName());

    @Autowired
    CalculationServiceRegistry calculationServiceRegistry;

    public CalculationServiceRegistry getCalculationServiceRegistry() {
        return calculationServiceRegistry;
    }

    public void setCalculationServiceRegistry(CalculationServiceRegistry calculationServiceRegistry) {
        this.calculationServiceRegistry = calculationServiceRegistry;
    }

    @Override
    public void calculationDone() {
        ServiceState.removeServiceState(getServiceIdentifier());
    }

    @SuppressWarnings("unchecked")
    protected T getServiceState() {
        T serviceState = (T) ServiceState.getServiceState(getServiceIdentifier());
        if (serviceState == null) {
            synchronized (this) {
                serviceState = (T) ServiceState.getServiceState(getServiceIdentifier());
                if (serviceState == null) {
                    serviceState = createServiceState();
                    ServiceState.setServiceState(getServiceIdentifier(), serviceState);
                }
            }
        }
        return serviceState;
    }

    protected abstract T createServiceState();
}
