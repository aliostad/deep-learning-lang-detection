package com.belhard.service.factory;

import com.belhard.service.BikeService;
import com.belhard.service.ParkingService;
import com.belhard.service.RentItemService;
import com.belhard.service.SupportItemService;
import com.belhard.service.UserService;

public abstract class ServiceFactory {

    private static ServiceFactory serviceFactory;

    public abstract UserService getUserService();

    public abstract BikeService getBikeService();

    public abstract ParkingService getParkingService();

    public abstract SupportItemService getSupportItemService();

    public abstract RentItemService getRentItemService();

    static {
        serviceFactory = new ServiceFactoryImpl();
    }

    public static ServiceFactory getFactory() {
        return serviceFactory;
    }

}
