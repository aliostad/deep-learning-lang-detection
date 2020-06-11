package com.servicefloor.core.service.domain;

import java.math.BigDecimal;

public class Service {
	private String serviceId;
	private String serviceName;
	private ServicePrice servicePrice;
	private String serviceCenterRateCardCategoryId;

	private Service() {

	}

	static Service create(String serviceId, String serviceName,
			String serviceCenterRateCardCategoryId, BigDecimal originalPrice,
			BigDecimal discountedPrice) {
		Service service = new Service();
		ServicePrice servicePrice = ServicePrice.create(originalPrice,
				discountedPrice);
		service.serviceId = serviceId;
		service.serviceName = serviceName;
		service.servicePrice = servicePrice;
		service.serviceCenterRateCardCategoryId = serviceCenterRateCardCategoryId;
		return service;
	}

	public String getServiceId() {
		return serviceId;
	}

	public String getServiceName() {
		return serviceName;
	}

	public ServicePrice getServicePrice() {
		return servicePrice;
	}

	public String getServiceCenterRateCardCategoryId() {
		return serviceCenterRateCardCategoryId;
	}
}
