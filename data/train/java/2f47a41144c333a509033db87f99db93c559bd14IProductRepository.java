package nl.sogeti.vertx.webshop.data;

import java.util.List;

import io.vertx.core.Handler;
import nl.sogeti.vertx.webshop.model.Product;

public interface IProductRepository {
	void getProducts(Handler<List<Product>> handler);
	void getProducts(Handler<List<Product>> handler, String categoryName);
	void getProducts(Handler<List<Product>> handler, String[] ids);
	void getProduct(Handler<Product> handler, String id);
	void deleteProduct(Handler<Boolean> handler, String id);
	void saveProduct(Handler<String> handler, Product product);
}
