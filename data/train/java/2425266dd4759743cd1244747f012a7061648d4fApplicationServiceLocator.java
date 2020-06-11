/*
 * @(#)ApplicationServiceLocator.java  2005-1-6
 * Copyright (c) 2005. All rights reserved. 
 * 
 * $Header: /navysu/Smirt18/src/application/service/ApplicationServiceLocator.java,v 1.1 2005/01/20 03:14:27 navy Exp $
 * $Log: ApplicationServiceLocator.java,v $
 * Revision 1.1  2005/01/20 03:14:27  navy
 * Create SMiRT 18 project
 *
 */
package application.service;

import framework.service.ServiceLocator;

/**
 * <p><b>Description</b></p>
 * <p>Locator all business services which have defined in context.</p>
 * 
 * $Revision: 1.1 $
 * @author su_haijun  <a href=mailto:su_hj@126.com>su_hj@126.com</a>
 */
public class ApplicationServiceLocator extends ServiceLocator {
    
    public static UserService getUserService() {
        return (UserService)getService("userService");
    }
    
    public static MenuService getMenuService() {
        return (MenuService)getService("menuService");
    }
    
    public static SearchService getSearchService() {
        return (SearchService)getService("searchService");
    }

    public static RegisterService getRegisterService() {
        return (RegisterService)getService("registerService");
    }

    public static AccompanyPersonService getAccompanyPersonService() {
        return (AccompanyPersonService)getService("accompanyPersonService");
    }

    public static VisaService getVisaService() {
        return (VisaService)getService("visaService");
    }
    public static AccommodationService getAccommodationService() {
        return (AccommodationService)getService("accommodationService");
    }

    public static ManagerFeeService getManagerFeeService() {
        return (ManagerFeeService)getService("managerFeeService");
    }
    public static PaperPresentedService getPaperPresentedService() {
        return (PaperPresentedService)getService("paperPresentedService");
    }
}
