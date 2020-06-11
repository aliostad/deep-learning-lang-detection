package com.travelover.traveljournal.service;

import android.content.Context;


public class ServiceDelegate {

	private static CouchbaseService couchbaseService;
	private static GpsService gpsService;
	
	public static void init( Context context){
		
		couchbaseService = new CouchbaseService();
		couchbaseService.init(context);
		
		gpsService = new GpsService();
		gpsService.init(context);
	}

	public static CouchbaseService getCouchbaseService() {
		return couchbaseService;
	}

	public static void setCouchbaseService(CouchbaseService couchbaseService) {
		ServiceDelegate.couchbaseService = couchbaseService;
	}
	
	
}
