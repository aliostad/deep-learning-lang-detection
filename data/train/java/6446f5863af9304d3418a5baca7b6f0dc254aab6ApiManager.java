package aikabot.apimanager;

import services.Service;
import services.Service_Service;

public class ApiManager {

//    @WebServiceRef(wsdlLocation = "http://localhost:8080/services/service?wsdl")
    private Service_Service service = new Service_Service();
    private static ApiManager instance = new ApiManager();

    public static ApiManager getInstance() {
        return instance;
    }

    private ApiManager() {
    }

    public Service getServicePort() {
        return service.getServicePort();
    }
}
