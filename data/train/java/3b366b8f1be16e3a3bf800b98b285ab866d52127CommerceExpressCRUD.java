package com.commerce.express.app.facade;

import com.commerce.express.app.config.GetContext;
import com.commerce.express.service.crud.AccessDetailsCrudService;
import com.commerce.express.service.crud.AddressCrudService;
import com.commerce.express.service.crud.AdministratorCrudService;
import com.commerce.express.service.crud.CategoryCrudService;
import com.commerce.express.service.crud.CustomerCrudService;
import com.commerce.express.service.crud.FAQCrudService;
import com.commerce.express.service.crud.OrderLineCrudService;
import com.commerce.express.service.crud.OrdersCrudService;
import com.commerce.express.service.crud.ProductCrudService;
import com.commerce.express.service.crud.RatingCrudService;
import com.commerce.express.service.crud.RolesCrudService;
import com.commerce.express.service.crud.UsersCrudService;
import com.commerce.express.service.crud.WishListCrudService;
import org.springframework.context.ApplicationContext;

/**
 *
 * @author om95446
 */
public class CommerceExpressCRUD {
    private static CommerceExpressCRUD commerceExpressCRUD;
    private final static ApplicationContext CTX = GetContext.getApplicationContext();
    private AdministratorCrudService administratorCrudService;
    private CategoryCrudService categoryCrudService;
    private ProductCrudService productCrudService;
    private CustomerCrudService customerCrudService;
    private OrdersCrudService ordersCrudService;
    private OrderLineCrudService orderLineCrudService;
    private AccessDetailsCrudService accessDetailsCrudService;
    private AddressCrudService addressCrudService;
    private FAQCrudService fAQCrudService;
    private RatingCrudService ratingCrudService;
    private RolesCrudService rolesCrudService;
    private UsersCrudService usersCrudService;
    private WishListCrudService wishListCrudService;
    
    private CommerceExpressCRUD() {
    }
    
    public static synchronized CommerceExpressCRUD getCommerceExpressCRUD(){
        if (commerceExpressCRUD == null) {
            commerceExpressCRUD = new CommerceExpressCRUD();
        }
        return commerceExpressCRUD;
    }
    
    public AdministratorCrudService getAdministratorCrudService() {
        administratorCrudService = (AdministratorCrudService) CTX.getBean("AdministratorCrudService");
        return administratorCrudService;
    }
    
    public WishListCrudService getWishListCrudService() {
        wishListCrudService = (WishListCrudService) CTX.getBean("WishListCrudService");
        return wishListCrudService;
    }
    
    public AddressCrudService getAddressCrudService() {
        addressCrudService = (AddressCrudService) CTX.getBean("AddressCrudService");
        return addressCrudService;
    }
    
    public FAQCrudService getFAQCrudService() {
        fAQCrudService = (FAQCrudService) CTX.getBean("FAQCrudService");
        return fAQCrudService;
    }
    
    public RatingCrudService getRatingCrudService() {
        ratingCrudService = (RatingCrudService) CTX.getBean("RatingCrudService");
        return ratingCrudService;
    }
    
    public OrdersCrudService getOrdersCrudService() {
        ordersCrudService = (OrdersCrudService) CTX.getBean("OrdersCrudService");
        return ordersCrudService;
    }
    
    public RolesCrudService getRolesCrudService() {
        rolesCrudService = (RolesCrudService) CTX.getBean("RolesCrudService");
        return rolesCrudService;
    }
    
    public UsersCrudService getUsersCrudService() {
        usersCrudService = (UsersCrudService) CTX.getBean("UsersCrudService");
        return usersCrudService;
    }
    
    public CustomerCrudService getCustomerCrudService() {
        customerCrudService = (CustomerCrudService) CTX.getBean("CustomerCrudService");
        return customerCrudService;
    }
    
    public OrderLineCrudService getOrderLineCrudService() {
        orderLineCrudService = (OrderLineCrudService) CTX.getBean("OrderLineCrudService");
        return orderLineCrudService;
    }
    
    public AccessDetailsCrudService getAccessDetailsCrudService() {
        accessDetailsCrudService = (AccessDetailsCrudService) CTX.getBean("AccessDetailsCrudService");
        return accessDetailsCrudService;
    }
    
    public ProductCrudService getProductCrudService() {
        productCrudService = (ProductCrudService) CTX.getBean("ProductCrudService");
        return productCrudService;
    }
    
    public CategoryCrudService getCategoryCrudService() {
        categoryCrudService = (CategoryCrudService) CTX.getBean("CategoryCrudService");
        return categoryCrudService;
    }
}
