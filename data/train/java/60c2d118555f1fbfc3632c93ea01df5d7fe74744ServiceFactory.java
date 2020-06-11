/**
 * 
 */
package com.codeminders.yfrog2.android.controller.service;

import java.util.HashMap;

import android.content.Context;

/**
 * @author idemydenko
 *
 */
public class ServiceFactory {
	private static final String ACCOUNT_SERVICE_NAME = "loginService";
	private static final String TWITTER_SERVICE_NAME = "twitterService";
	private static final String UNSENT_MESSAGE_SERVICE_NAME = "unsentMessageService";
	private static final String YFROG_SERVICE_NAME = "yfrogService";
	private static final String GEOLOCATION_SERVICE_NAME = "geolocationService";
	
	private static final HashMap<String, Object> cache = new HashMap<String, Object>();
	
	private ServiceFactory() {
	}
	
	public static AccountService getAccountService() {
		if (!contains(ACCOUNT_SERVICE_NAME)) {
			AccountService service = new AccountService();
			put(ACCOUNT_SERVICE_NAME, service);
			return service;
		} 
		return (AccountService) get(ACCOUNT_SERVICE_NAME);
	}
	
	public static TwitterService getTwitterService() {
		if (!contains(TWITTER_SERVICE_NAME)) {
			TwitterService service = new Twitter4JService();
			put(TWITTER_SERVICE_NAME, service);
			return service;
		} 
		return (TwitterService) get(TWITTER_SERVICE_NAME);
	}

	public static UnsentMessageService getUnsentMessageService() {
		if (!contains(UNSENT_MESSAGE_SERVICE_NAME)) {
			UnsentMessageService service = new UnsentMessageService();
			put(UNSENT_MESSAGE_SERVICE_NAME, service);
			return service;
		}
		return (UnsentMessageService) get(UNSENT_MESSAGE_SERVICE_NAME);
	}

	public static YFrogService getYFrogService() {
		if (!contains(YFROG_SERVICE_NAME)) {
			YFrogService service = new YFrogService();
			put(YFROG_SERVICE_NAME, service);
			return service;
		}
		return (YFrogService) get(YFROG_SERVICE_NAME);
	}

	public static GeoLocationService getGeoLocationService(Context context) {
		if (!contains(GEOLOCATION_SERVICE_NAME)) {
			GeoLocationService service = new GeoLocationService(context);
			put(GEOLOCATION_SERVICE_NAME, service);
			return service;
		}
		return (GeoLocationService) get(GEOLOCATION_SERVICE_NAME);
	}

	public static GeoLocationService getGeoLocationService() {
		return (GeoLocationService) get(GEOLOCATION_SERVICE_NAME);
	}

	private static Object get(String name) {
		return cache.get(name);
	}
	
	private static void put(String name, Object service) {
		cache.put(name, service);
	}
	
	private static boolean contains(String name) {
		return cache.containsKey(name);
	}
}
