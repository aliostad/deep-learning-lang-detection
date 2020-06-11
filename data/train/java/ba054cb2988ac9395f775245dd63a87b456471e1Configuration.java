package com.telluriumsource.config;

import com.telluriumsource.service.RecommendService;
import com.telluriumsource.service.ServiceCheckService;

import java.util.concurrent.atomic.AtomicLong;

public class Configuration {

    private static Configuration configuration = new Configuration();

    private AtomicLong sequence = new AtomicLong(1);

    private Environment environment;

    private ServiceCheckService serviceCheckService;

    private RecommendService recommendService;

    private Configuration(){

    }

    public static Configuration getInstance(){
        return configuration;
    }

    public Environment getEnvironment() {
        return environment;
    }

    public void setEnvironment(Environment environment) {
        this.environment = environment;
    }

    public long next(){
        return sequence.getAndIncrement();
    }

    public long total(){
        return sequence.get();
    }

    public ServiceCheckService getServiceCheckService() {
        return serviceCheckService;
    }

    public void setServiceCheckService(ServiceCheckService serviceCheckService) {
        this.serviceCheckService = serviceCheckService;
    }

    public RecommendService getRecommendService() {
        return recommendService;
    }

    public void setRecommendService(RecommendService recommendService) {
        this.recommendService = recommendService;
    }
}
