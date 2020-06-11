package service;

public class ServiceLocator {
	
	private static ServiceLocator instance = null;
	private Service emailService=null;
	
	private ServiceLocator() {}
	
	public static ServiceLocator getInstance() {
		if(instance == null) instance =new ServiceLocator();
		return instance;
	}
	
	public Service find(String serviceName) throws Exception{
		if (serviceName.equals("EmailService")) return getEmailService();
		else throw new Exception("Error al obtenir el servei");
		
	}
	
	private Service getEmailService() {
		if (emailService == null) emailService = new EmailServiceAdapter();
		return emailService;
	}
}
