package sonique.bango.app;

import sonique.bango.service.SearchApiService;
import sonique.bango.service.ServiceProblemApiService;

import static org.mockito.Mockito.mock;

public class ServiceWrapper {
    private final SearchApiService searchApiService;
    private final ServiceProblemApiService serviceProblemApiService;

    public ServiceWrapper() {
        searchApiService = mock(SearchApiService.class);
        serviceProblemApiService = mock(ServiceProblemApiService.class);
    }

    public SearchApiService searchApiService() {
        return searchApiService;
    }

    public ServiceProblemApiService serviceProblemApiService() {
        return serviceProblemApiService;
    }
}
