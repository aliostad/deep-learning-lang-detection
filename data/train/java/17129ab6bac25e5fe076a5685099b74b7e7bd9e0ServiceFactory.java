package com.xl.system.core.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


import com.xl.order.core.service.OrderService;
import com.xl.profile.core.service.UserService;

@Component("serviceFactory")
public class ServiceFactory {

    private UserService userService;
    private OrderService orderService;
    
    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }
    
    @Autowired
    public void setOrderService(OrderService orderService) {
        this.orderService = orderService;
    }
    
    public UserService getUserService() {
        return userService;
    }
    
    public OrderService getOrderService() {
        return orderService;
    }

    
}
