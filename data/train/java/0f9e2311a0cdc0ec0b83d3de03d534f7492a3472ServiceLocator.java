package com.dngconsulting.demo.client.services;

import com.google.gwt.core.client.GWT;

public class ServiceLocator {
	private static ProductServiceAsync injService = GWT.create(ProductService.class);
	public static ProductServiceAsync	getProductService() {
		return injService;
	}
//	
//	private static UserServiceAsync userService = GWT.create(UserService.class);
//	public static UserServiceAsync	getUserService() {
//		return userService;
//	}
//
//	private static ColisServiceAsync colisService = GWT.create(ColisService.class);
//	public static ColisServiceAsync	getColisService() {
//		return colisService;
//	}
//	private static FactureServiceAsync factureService = GWT.create(FactureService.class);
//	public static FactureServiceAsync	getFactureService() {
//		return factureService;
//	}
}
