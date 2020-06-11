package luke.projectmprg.repository.dummy;

import luke.projectmprg.repository.ICategoryRepository;
import luke.projectmprg.repository.IProductRepository;
import luke.projectmprg.IRepositoryCatalog;
import luke.projectmprg.repository.IShopRepository;
import luke.projectmprg.repository.IShoppingRepository;

public class DummyRepositoryCatalog implements IRepositoryCatalog {
    
    DummyDB db = new DummyDB();

    @Override
    public IProductRepository getProducts() {
        return new DummyProductRepository(db);
    }

    @Override
    public ICategoryRepository getCategories() {
        return new DummyCategoryRepository(db);
    }

    @Override
    public IShoppingRepository getShopping() {
        return new DummyShoppingRepository(db);
    }

    @Override
    public IShopRepository getShops() {
        return new DummyShopRepository(db);
    }

}
