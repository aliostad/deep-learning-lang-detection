package com.google.code.estore.domain.shared;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.google.code.estore.domain.model.customer.CustomerRepository;
import com.google.code.estore.domain.model.product.ProductRepository;
import com.google.code.estore.domain.model.shopping.CartRepository;

@Component
public class RepositoryFactory {
	
	private static ProductRepository productRepository;
	
	private static CustomerRepository customerRepository;
	
	private static CartRepository cartRepository;

	public static ProductRepository getProductRepository() {
		return productRepository;
	}

	@Autowired
	public void setProductRepository(ProductRepository productRepository) {
		RepositoryFactory.productRepository = productRepository;
	}

	public static CustomerRepository getCustomerRepository() {
		return customerRepository;
	}

	@Autowired
	public void setCustomerRepository(CustomerRepository customerRepository) {
		RepositoryFactory.customerRepository = customerRepository;
	}

	public static CartRepository getCartRepository() {
		return cartRepository;
	}

	@Autowired
	public void setCartRepository(CartRepository cartRepository) {
		RepositoryFactory.cartRepository = cartRepository;
	}
	
	
	
	
	

}
