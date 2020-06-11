package com.gbihealth.solr;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ProductService {
	private SolrProductRepository repository;

	@Autowired
	public ProductService(SolrProductRepository repository) {
		this.repository = repository;
	}

	public void doSomething() {
		repository.deleteAll();
		Product product = new Product();
		product.setId("spring-data-solr");
		repository.save(product);
		repository.findOne("spring-data-solr");
	}
}
