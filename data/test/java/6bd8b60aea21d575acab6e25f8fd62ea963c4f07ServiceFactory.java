package com.liberty.technical.logic.factory;

import com.liberty.technical.logic.service.GenericeCartService;
import com.liberty.technical.logic.service.AuthenticationService;
import com.liberty.technical.logic.service.ImageService;
import com.liberty.technical.logic.service.OrderService;


/**
 * @author AKI
 */
public class ServiceFactory {
  private static ServiceFactory instanse;

  private ServiceFactory()
  {

  }


  public static ServiceFactory getInstanse()
  {
    if (instanse == null) {
      instanse = new ServiceFactory();
    }
    return instanse;
  }


  public GenericeCartService createCartService()
  {
    return new GenericeCartService();
  }

  public ImageService createImageService()
  {
    return new ImageService();
  }


  public OrderService createOrderService()
  {
    return new OrderService();
  }


  public AuthenticationService createAuthenticationService()
  {
    return new AuthenticationService();
  }

}
