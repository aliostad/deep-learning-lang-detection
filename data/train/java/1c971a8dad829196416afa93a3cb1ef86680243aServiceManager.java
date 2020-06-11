package org.fun.mobile.common.framework.service;

import org.fun.mobile.service.ITNewsService;
import org.fun.mobile.service.ITUserService;

public class ServiceManager {
    
    private ITUserService tuserService;
    
    private ITNewsService tnewsService;
    
    public ITNewsService getTnewsService() {
        return tnewsService;
    }
    
    public void setTnewsService(ITNewsService tnewsService) {
        this.tnewsService = tnewsService;
    }
    
    public ITUserService getTuserService() {
        return tuserService;
    }
    
    public void setTuserService(ITUserService tuserService) {
        this.tuserService = tuserService;
    }
}
