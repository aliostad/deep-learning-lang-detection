package ua.be.dc.services.bankService.service;

import javax.xml.rpc.ServiceException;

public class BankServiceFactory {

	private static BankServiceImplServiceLocator serviceLocator = new BankServiceImplServiceLocator();
	private static BankService service;
	
	static {
		try {
			if (service == null) {
				BankServiceImplServiceLocator serviceLocator = new BankServiceImplServiceLocator();
				service = serviceLocator.getBankServiceImplPort();
			}
		} catch (ServiceException e) {
			System.out.println("Ticket Service couldn't be located");
			e.printStackTrace();
		}
	}
	
	public static BankService getService() {
		return service;
	}
	
	public static BankService getService(String address) {
		setServiceEndpoint(address);
		return service;
	}
	
	public static void setServiceEndpoint(String address) {
		try {
			serviceLocator.setBankServiceImplPortEndpointAddress(address);
			service = serviceLocator.getBankServiceImplPort();
		} catch (ServiceException e) {
			e.printStackTrace();
		}
	}
}
