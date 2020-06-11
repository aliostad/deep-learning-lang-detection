package com.eshop.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.eshop.service.AdminService;
import com.eshop.service.ProductService;
import com.eshop.service.ProductTypeService;
import com.eshop.service.impl.AdminServiceImpl;
import com.eshop.service.impl.ProductServiceImpl;
import com.eshop.service.impl.ProductTypeServiceImpl;

/**
 * Service 配置文件
 */
@Configuration
public class ServiceConfig {

	@Bean
	AdminService adminService() {
		return new AdminServiceImpl();
	}
	
	@Bean
	ProductService productService() {
		return new ProductServiceImpl();
	}
	
	@Bean
	ProductTypeService productTypeService() {
		return new ProductTypeServiceImpl();
	}
}
