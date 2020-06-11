package com.peergreen.prototype.basic;

import com.peergreen.prototype.api.FeatureContext;
import com.peergreen.prototype.api.Read;
import com.peergreen.prototype.api.Repository;

public class BasicFeatureContext implements FeatureContext {


    public Repository repository;

    public BasicFeatureContext(Repository repository) {
        this.repository = repository;
    }





    @Override
    public Read getProductionView() {
        return repository.read("production");
    }





    @Override
    public void setRepository(Repository repository) {
        this.repository = repository;
    }

}
