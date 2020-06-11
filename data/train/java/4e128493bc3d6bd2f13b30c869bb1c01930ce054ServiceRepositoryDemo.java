package lesson10.service;

/**
 * Created by Игорь on 08.01.2015.
 */
public class ServiceRepositoryDemo {

    public static void main(String[] args) {

        ServiceRepository<Service> serviceRepository = new ServiceRepository<>();

        ServiceImplementer serviceImplementer1 = new ServiceImplementer();
        ServiceImplementer serviceImplementer2 = new ServiceImplementer();
        ServiceImplementer serviceImplementer3 = new ServiceImplementer();

        serviceRepository.addToRepository(serviceImplementer1);
        serviceRepository.addToRepository(serviceImplementer2);
        serviceRepository.addToRepository(serviceImplementer3);

        for (Service s : serviceRepository.getServiceList()) {
            s.showInfo();
        }

    }
}
