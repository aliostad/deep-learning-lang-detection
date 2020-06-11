package cg.service.lookup;

import cg.service.lookup.LocalServiceLookup.ServiceLookupStrategyEnum;

//this class is a facade of service lookup.
//it use LocalServiceLookup or RemoteServiceLookup to get/create the service implementor
public class ServiceManager
{
  //TODO: handle the remote service lookup
  public static <T> T findService( Class<T> service ) throws ServiceNotFoundException
  {
    return LocalServiceLookup.getServiceLookup().findService( service );
  }

  public static <T> T findService( Class<T> service, ServiceLookupStrategyEnum strategyEnum ) throws ServiceNotFoundException
  {
    return LocalServiceLookup.getServiceLookup( strategyEnum ).findService( service );
  }

}
