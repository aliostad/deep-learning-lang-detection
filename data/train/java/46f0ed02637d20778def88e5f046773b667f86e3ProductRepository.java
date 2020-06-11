package deint.jroldan.manageproductfragment;

import java.util.List;

import deint.jroldan.manageproductfragment.model.Product;

/**
 * Created by usuario on 9/12/16.
 */

public class ProductRepository {
    private static ProductRepository repository;
    private List<Product> products;

    public ProductRepository(ProductRepository repository) {
        this.repository = repository;
    }

    public static ProductRepository getInstance() {
        if(repository == null)
            repository = new ProductRepository();
        return repository;
    }

    public List<Product> getProducts() {
        return null;
    }
}
