package yuanye.hadoop.service;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by Kali on 14-9-3.
 */
public class CompositeServer implements Service {

    private final List<Service> services = new LinkedList<>();

    @Override
    public void start() {
        synchronized (services) {
            for (Service service : services) {
                service.start();
            }
        }
    }

    @Override
    public void init() {
        synchronized (services) {
            for (Service service : services) {
                service.init();
            }
        }
    }

    @Override
    public void stop() {
        synchronized (services) {
            for (Service service : services) {
                service.stop();
            }
        }
    }

    public void addService(Service service) {
        synchronized (services) {
            if (!services.contains(service))
                services.add(service);
        }
    }
}
