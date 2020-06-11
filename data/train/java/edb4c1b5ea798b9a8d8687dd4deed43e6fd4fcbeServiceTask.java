package prixma.opc.services;

import java.util.TimerTask;

public class ServiceTask extends TimerTask {
	
	private Service service;
	
	public ServiceTask(Service servico){
		this.service = servico;
	}
	
	public void run() {
		try {
		
			if(service.shouldExecute()){
				service.log("EXECUTING SERVICE " + service.getName());
				service.execute();
				service.hasExecuted();
			}
			else 
				service.log("SERVICE " + service.getName() + " SUSPENDED ");
		
		} catch (Exception e) {
			service.log("SERVICE EXECUTION ERROR " + e.getMessage());
			throw new ServiceException(e);
		}
		finally {
			if(!service.shouldContinue()){
				service.log("STOPPING SERVICE " + service.getName());
				service.stop();
			}
		}
	}
	
}
