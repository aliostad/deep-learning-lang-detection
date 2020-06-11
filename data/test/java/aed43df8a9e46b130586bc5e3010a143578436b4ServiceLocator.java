package ServiceLocator;


public class ServiceLocator {
    private static Cache cache = new Cache();
    private static InitialContext context = new InitialContext();
    
    public static Service getService(String jndiName) {
        Service cachedService = cache.getService(jndiName);
        if (cachedService != null) return cachedService;
        
        Service service = context.lookup(jndiName);
        if (service != null) cache.addService(service);
        
        return service;
    }
    
    public static void main(String[] args) {
        Service service = ServiceLocator.getService("Service1");
        service.execute();
        System.out.println();
        
        service = ServiceLocator.getService("Service2");
        service.execute();
        System.out.println();
               
        service = ServiceLocator.getService("Service1");
        service.execute();
        System.out.println();
        
        service = ServiceLocator.getService("Service2");
        service.execute();        
    }
}
