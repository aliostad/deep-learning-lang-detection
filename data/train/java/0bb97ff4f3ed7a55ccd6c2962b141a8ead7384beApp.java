package behavioral.designPattern.command;

public class App {

	public static void main(String[] args) {
	
		
		ServiceProvider serviceProvider = new ServiceProvider();
		
		
		Command command = new OperationalCommand();
		
		Service service = new DatabaseService("Database Service");
		serviceProvider.serviceOperation(command, service);
		serviceProvider.previousState();
		
		service = new LocatorService("Locator Service");
		serviceProvider.serviceOperation(command, service);
		serviceProvider.previousState();
		
		
		
	}

}

