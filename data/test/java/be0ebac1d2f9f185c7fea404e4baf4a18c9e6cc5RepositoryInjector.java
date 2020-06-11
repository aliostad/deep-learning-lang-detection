package name.yamamoto.satoshi.persistence.model;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.inject.Named;

import name.yamamoto.satoshi.persistence.repository.CategoryRepository;
import name.yamamoto.satoshi.persistence.repository.OrderRepository;
import name.yamamoto.satoshi.persistence.repository.ProductRepository;
import name.yamamoto.satoshi.persistence.repository.TagRepository;

@Named
public class RepositoryInjector {
	@Inject
	private CategoryRepository categoryRepository;
	@Inject
	private OrderRepository orderRepository;
	@Inject
	private ProductRepository productRepository;
	@Inject
	private TagRepository tagRepository;

	@PostConstruct
	public void inject() {
		Category.repository = categoryRepository;
		Order.repository = orderRepository;
		Product.repository = productRepository;
		Tag.repository = tagRepository;
	}
}
