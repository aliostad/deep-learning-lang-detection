package ServiceLocatorPattern;

/**
 * Created by Ben Yu on 4/11/15.
 */
public class ServiceLocatorPatternDemo {
    public static void main(String[] args) {
        Service service = ServiceLocator.getService("Service1");
        service.execute();

        service = ServiceLocator.getService("Service2");
        service.execute();

        service = ServiceLocator.getService("Service1");
        service.execute();
        service = ServiceLocator.getService("Service2");
        service.execute();
    }
}
