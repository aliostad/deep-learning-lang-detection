package com.servicefloor.core.service.domain;

public class ServiceSubCategory {
	String serviceSubCategoryId;
	String serviceSubCategoryName;

	private ServiceSubCategory() {

	}

	static ServiceSubCategory Create(String serviceSubCategoryId,
			String serviceSubCategoryName) {
		ServiceSubCategory serviceSubCategory = new ServiceSubCategory();
		serviceSubCategory.serviceSubCategoryId = serviceSubCategoryId;
		serviceSubCategory.serviceSubCategoryName = serviceSubCategoryName;
		return serviceSubCategory;
	}
}
