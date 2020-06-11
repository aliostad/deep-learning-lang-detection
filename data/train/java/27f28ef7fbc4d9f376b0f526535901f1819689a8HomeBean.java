package br.com.artesuzana.presentation.web.beans;

import java.util.ArrayList;
import java.util.List;

import br.com.artesuzana.model.domain.Category;
import br.com.artesuzana.model.domain.Product;
import br.com.artesuzana.model.repository.ICategoryRepository;
import br.com.artesuzana.model.repository.IProductRepository;

/**
 * @author francisco
 */
public class HomeBean {

	private IProductRepository productRepository;
	private ICategoryRepository categoryRepository;
	
	/**
	 * @return the categoryRepository
	 */
	public ICategoryRepository getCategoryRepository() {
		return categoryRepository;
	}

	/**
	 * @param categoryRepository the categoryRepository to set
	 */
	public void setCategoryRepository(ICategoryRepository categoryRepository) {
		this.categoryRepository = categoryRepository;
	}

	public List<Product> getHighlights() {
		
		// TODO pegar apenas os produto mais recentes
		List<Product> products = productRepository.list(); 
		
		return products;
	}

	/**
	 * @return the productRepository
	 */
	public IProductRepository getProductRepository() {
		return productRepository;
	}

	/**
	 * @param productRepository the productRepository to set
	 */
	public void setProductRepository(IProductRepository productRepository) {
		this.productRepository = productRepository;
	}
	
	public List<Category> getTopCategories() {
		return categoryRepository.findTop5();
	}
	
}
