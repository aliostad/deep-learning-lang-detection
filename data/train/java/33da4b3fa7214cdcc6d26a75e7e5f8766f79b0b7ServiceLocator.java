package com.mohansrihari.service.locator;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import com.mohansrihari.common.Context;
import com.mohansrihari.facebook.FacebookServiceConfig;
import com.mohansrihari.service.FacebookService;
import com.mohansrihari.service.IBaseService;
import com.mohansrihari.service.impl.FacebookServiceImpl;
import com.mohansrihari.service.impl.HMACSha256SignatureServiceImpl;

public class ServiceLocator {

	public final static String FACEBOOK_SERVICE = "Facebook_Service";

	public final static String SIGNATURE_SERVICE = "SIGNATURE_SERVICE";
	private ServiceLocator() {

	}

	/**
     * <p>
     * This map is used to hold the instances of the services implementation
     * that are looked up, and serves as the cache.
     * </p>
     */
    private Map<String, IBaseService> cache = Collections.synchronizedMap(new HashMap<String, IBaseService>());
    private FacebookServiceConfig serviceConfig=new FacebookServiceConfig(Context.facebookAppId, Context.facebookAppSecret, Context.facebookAppChannelURL);
    /**
     * <p>
     * Stores the singleton instance of the service locator.
     * </p>
     */
    private static ServiceLocator instance = new ServiceLocator();

	public static ServiceLocator getInstance() {

		if(instance == null){
			instance = new ServiceLocator();
		}

		return instance;
	}

	public IBaseService getService(String serviceName) {

		IBaseService service = cache.get(serviceName);
        if (service == null) {
            service = (FacebookService) getIBaseServiceImpl(serviceName);
            cache.put(serviceName, service);
        }

        return service;

	}

	private IBaseService getIBaseServiceImpl(String serviceName){

		IBaseService baseService = null;

		if (serviceName.equalsIgnoreCase(FACEBOOK_SERVICE)) {
			baseService = new FacebookServiceImpl(serviceConfig);
		}else if(serviceName.equalsIgnoreCase(SIGNATURE_SERVICE)){
			baseService = new HMACSha256SignatureServiceImpl();
		}
		return baseService;
	}

}