/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package net.griddynamics.server;

import net.griddynamics.api.approach3.Context;
import net.griddynamics.api.servicesinterfaces.ProductService;
import net.griddynamics.api.servicesinterfaces.StoreService;
import org.springframework.beans.factory.annotation.Required;

/**
 *
 * @author one
 */
class ServerContext implements Context{
    private ProductService productService;
    private StoreService storeService;
       
    @Override
    public ProductService getProductService() {
        return productService;
    }

    @Required
    public void setProductService(ProductService productService) {
        this.productService = productService;
    }

    @Override
    public StoreService getStoreService() {
        return storeService;
    }
    
    @Required
    public void setStoreService(StoreService storeService) {
        this.storeService = storeService;
    }
}
