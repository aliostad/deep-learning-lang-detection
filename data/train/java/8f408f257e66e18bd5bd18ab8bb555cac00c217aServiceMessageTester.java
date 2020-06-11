package netlab.hub.test.integration;

import netlab.hub.core.Service;
import netlab.hub.core.ServiceException;
import netlab.hub.core.ServiceMessage;
import netlab.hub.test.mocks.MockServiceResponse;

public class ServiceMessageTester {
	
	Service service;
	
	public ServiceMessageTester(Service service) {
		this.service = service;
	}
	
	public MockServiceResponse send(String message) throws ServiceException {
		ServiceMessage request = new ServiceMessage(message);
		MockServiceResponse response = new MockServiceResponse(request, null);
		service.process(request, response);
		return response;
	}

}
