package be.kuleuven.swop.objectron.handler;

import java.util.HashMap;
import java.util.Map;

/**
 * A class of HandlerCatalogs.
 * @author : Nik Torfs
 *         Date: 14/03/13
 *         Time: 23:23
 */
public class HandlerCatalog {
    private Map<Class<?>, Handler> catalog = new HashMap<>();

    /**
     * Add a Handler to the HandlerCatalog.
     * @param handler
     *        The Handler to add to the HandlerCatalog.
     * @post  The Handler is added to the HandlerCatalog.
     *        | new.catalog.containsValue(handler)
     */
    public void addHandler(Handler handler) {
        catalog.put(handler.getClass(), handler);
    }

    /**
     * Get a handler from the HandlerCatalog.
     * @param handler
     *        The Handler to retrieve.
     * @return The requested handler.
     */
    public Handler getHandler(Class<?> handler) {
        return catalog.get(handler);
    }
}
