package com.xone.action.base;

import org.springframework.beans.factory.annotation.Autowired;

import com.xone.service.app.ProductService;
import com.xone.service.app.PurchaseService;

public class ExpiredTask {
    @Autowired
    ProductService productService;
    
    @Autowired
    PurchaseService purchaseService;
    
    public void updateFlagDeletedWhenExpired(){
        getProductService().updateFlagDeletedWhenExpired();
        getPurchaseService().updateFlagDeletedWhenExpired();
    }

    public ProductService getProductService() {
        return productService;
    }

    public void setProductService(ProductService productService) {
        this.productService = productService;
    }

    public PurchaseService getPurchaseService() {
        return purchaseService;
    }

    public void setPurchaseService(PurchaseService purchaseService) {
        this.purchaseService = purchaseService;
    }
    
    
}
