package co.ipq.d1v0id.design.patterns.servicelocator;

public class ServiceLocator {
    private static Cache cache;

    static {
        cache = new Cache();
    }

    public static Service getService(String jndiName) {
        Service cachedService = cache.getService(jndiName);

        if (cachedService != null) {
            return cachedService;
        }

        InitialContext context = new InitialContext();
        Service service = (Service) context.lookup(jndiName);
        cache.addService(service);

        return service;
    }
}
